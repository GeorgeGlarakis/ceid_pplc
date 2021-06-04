%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>

int yylex();
extern FILE *yyin;    
extern int yylineno;
void yyerror(const char *msg);

%}

%token PROGRAM FUNCTION VARS CHAR INTEGER END_FUNCTION RETURN STARTMAIN ENDMAIN
%token IF THEN ENDIF ELSEIF ELSE FOR TO STEP ENDFOR WHILE ENDWHILE SWITCH CASE DEFAULT ENDSWITCH 
%token PRINT BREAK STRUCT ENDSTRUCT TYPEDEF QUOTES STARTCOM ENDCOM
%token ID INT CHARACTER STRING COMMENT BINOP RELOP LOGICALOP  
%token LEFTCURL RIGHTCURL LEFTBRA RIGHTBRA LEFTPAR RIGHTPAR COMMA SEMICOLON COLON ASSIGN NEWLINE NEG NOT

%%

prog  : PROGRAM identifier NEWLINE
      | prog func
      | prog main_func
      ;

identifier  : ID
            | CHARACTER
            ;

func_dcl : VARS type var_decl SEMICOLON
         | 
         ;

var_decl : identifier                           
         | identifier LEFTBRA INT RIGHTBRA
         | var_decl COMMA identifier
         | var_decl COMMA identifier LEFTBRA INT RIGHTBRA
         ;

type    : CHAR
        | INTEGER
        ;

parm_types : type identifier 
           | type identifier LEFTBRA RIGHTBRA  
           | parm_types COMMA type identifier 
           | parm_types COMMA type identifier LEFTBRA RIGHTBRA
           | 
           ;         

// υποχρεωτική προσθήκη RETURN πριν τη λήξη της συνάρτησης
func    : FUNCTION identifier LEFTPAR parm_types RIGHTPAR NEWLINE func_dcl mult_stmt NEWLINE END_FUNCTION 
 	    ;

main_func   : STARTMAIN LEFTPAR parm_types RIGHTPAR NEWLINE func_dcl NEWLINE mult_stmt NEWLINE ENDMAIN 
 	        ;      

mult_stmt : stmt
          | com stmt
          | stmt com                
          | mult_stmt NEWLINE stmt                  
          ;

stmt	: IF LEFTPAR expr RIGHTPAR THEN NEWLINE mult_stmt NEWLINE ENDIF
        | IF LEFTPAR expr RIGHTPAR THEN NEWLINE mult_stmt multi_elseif NEWLINE ENDIF
        | IF LEFTPAR expr RIGHTPAR THEN NEWLINE mult_stmt else NEWLINE ENDIF

        | WHILE LEFTPAR expr RIGHTPAR NEWLINE mult_stmt NEWLINE ENDWHILE 

        | FOR assg TO INT STEP INT NEWLINE mult_stmt NEWLINE ENDFOR
        
        | SWITCH LEFTPAR expr RIGHTPAR NEWLINE sw_case NEWLINE DEFAULT COLON NEWLINE mult_stmt NEWLINE ENDSWITCH
        | SWITCH LEFTPAR expr RIGHTPAR NEWLINE sw_case NEWLINE ENDSWITCH

        | RETURN expr SEMICOLON
        | RETURN SEMICOLON
        | BREAK SEMICOLON
        | assg SEMICOLON
        | identifier LEFTPAR mult_expr RIGHTPAR SEMICOLON
        | print
        | com
        | SEMICOLON                                           
        ;

sw_case : CASE LEFTPAR expr RIGHTPAR COLON NEWLINE mult_stmt
        | sw_case CASE LEFTPAR expr RIGHTPAR COLON NEWLINE mult_stmt
        ;

multi_elseif   : ELSEIF LEFTPAR expr RIGHTPAR NEWLINE mult_stmt 
               | multi_elseif ELSEIF LEFTPAR expr RIGHTPAR NEWLINE mult_stmt 

else : ELSE NEWLINE mult_stmt
     | multi_elseif ELSE NEWLINE mult_stmt
     ;

assg	: identifier ASSIGN expr                             
        | identifier LEFTBRA expr RIGHTBRA ASSIGN expr                
        ;

mult_expr : expr                        
          | mult_expr COMMA expr
          ;

expr	: NEG expr                      
        | NOT expr                      
        | expr BINOP expr
        | expr RELOP expr
        | expr LOGICALOP expr
        | identifier                            
        | identifier LEFTPAR mult_expr RIGHTPAR 
        | identifier LEFTBRA expr RIGHTBRA
        | LEFTPAR expr RIGHTPAR                  
        | INT                                                                   
        ;

print_var   : COMMA identifier
            | COMMA identifier LEFTBRA INT RIGHTBRA
            | print_var COMMA identifier
            | print_var COMMA identifier LEFTBRA INT RIGHTBRA
            ;

print : PRINT LEFTPAR QUOTES STRING QUOTES RIGHTPAR SEMICOLON
      | PRINT LEFTPAR QUOTES STRING QUOTES print_var RIGHTPAR SEMICOLON
      ;

com : COMMENT STRING NEWLINE
    ;

// str : STRING
//     | STRING NEWLINE str
//     ;

// mult_com : STARTCOM str ENDCOM
//          | STARTCOM str NEWLINE ENDCOM
//          ;

%%

void yyerror(const char *msg){
    printf("%s at line %d", msg, yylineno); 
}

int main(int argc, char *argv[]){
    ++argv; --argc;  
    int parser_return_value = 0;
    if (argc==1) {
        FILE *file_pointer = fopen(argv[0],"r");
        if (file_pointer!=NULL) {
            printf("\nFile %s selected.\n",argv[0]);
            printf("\nParsing...\n");
            // sleep(2);
            printf("\n===================================\n\n");
            yyin = file_pointer;   
            parser_return_value = yyparse();
        } 
        else {
            printf("Error processing file.\n");
            return 1;
        }
    } 
    else {
           printf ("Parsing from terminal input:\n");
           parser_return_value = yyparse();
    }
    if (parser_return_value==0) {
        printf("Parsing complete. No errors found!\n\n");
        printf("===================================\n");
    } 
    else if (parser_return_value==2) {
        printf("\nParsing failed due to memory exhaustion.\n\n");
        printf("===================================\n");
    }
    else {
        printf("\n\nParsing failed.\n\n");
        printf("===================================\n");
    }
    return 0;
}