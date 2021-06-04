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
%token PRINT BREAK STRUCT ENDSTRUCT TYPEDEF STARTCOM ENDCOM
%token ID INT CHARACTER STRING COMMENT BINOP RELOP LOGICALOP  
%token LEFTCURL RIGHTCURL LEFTBRA RIGHTBRA LEFTPAR RIGHTPAR COMMA SEMICOLON COLON ASSIGN NEG NOT NEWLINE

%%

prog  : PROGRAM identifier
      | prog func
      | prog main_func
      | prog strct
      | prog com
      ;

identifier  : ID
            | CHARACTER
            ;

func_dcl : VARS type var_decl SEMICOLON
         | func_dcl VARS type var_decl SEMICOLON 
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
func    : FUNCTION identifier LEFTPAR parm_types RIGHTPAR func_dcl mult_stmt END_FUNCTION 
 	    ;

main_func   : STARTMAIN LEFTPAR parm_types RIGHTPAR func_dcl mult_stmt ENDMAIN 
 	        ;      

mult_stmt : stmt
          | com stmt
          | stmt com                
          | mult_stmt stmt                  
          ;

stmt	: IF LEFTPAR expr RIGHTPAR THEN mult_stmt ENDIF
        | IF LEFTPAR expr RIGHTPAR THEN mult_stmt multi_elseif ENDIF
        | IF LEFTPAR expr RIGHTPAR THEN mult_stmt else ENDIF

        | WHILE LEFTPAR expr RIGHTPAR mult_stmt ENDWHILE 

        | FOR assg TO INT STEP INT mult_stmt ENDFOR
        
        | SWITCH LEFTPAR expr RIGHTPAR sw_case DEFAULT COLON mult_stmt ENDSWITCH
        | SWITCH LEFTPAR expr RIGHTPAR sw_case ENDSWITCH

        | RETURN expr SEMICOLON
        | RETURN SEMICOLON
        | BREAK SEMICOLON
        | assg SEMICOLON
        | identifier LEFTPAR mult_expr RIGHTPAR SEMICOLON
        | print
        | com
        | SEMICOLON                                           
        ;

sw_case : CASE LEFTPAR expr RIGHTPAR COLON mult_stmt
        | sw_case CASE LEFTPAR expr RIGHTPAR COLON mult_stmt
        ;

multi_elseif   : ELSEIF LEFTPAR expr RIGHTPAR mult_stmt 
               | multi_elseif ELSEIF LEFTPAR expr RIGHTPAR mult_stmt 

else : ELSE mult_stmt
     | multi_elseif ELSE mult_stmt
     ;

strct : STRUCT identifier func_dcl ENDSTRUCT
        | TYPEDEF STRUCT identifier func_dcl ENDSTRUCT
        ;

assg	: identifier ASSIGN expr                             
        | identifier LEFTBRA expr RIGHTBRA ASSIGN expr                
        ;

mult_expr : expr                        
          | mult_expr COMMA expr
          ;

expr	: NOT expr            
        | identifier                            
        | identifier LEFTPAR mult_expr RIGHTPAR 
        | identifier LEFTBRA expr RIGHTBRA
        | LEFTPAR expr RIGHTPAR                  
        | INT                     
        | expr BINOP expr
        | expr RELOP expr
        | expr LOGICALOP expr                                              
        ;

print_var   : COMMA identifier
            | COMMA identifier LEFTBRA INT RIGHTBRA
            | print_var COMMA identifier
            | print_var COMMA identifier LEFTBRA INT RIGHTBRA
            ;

print : PRINT LEFTPAR STRING RIGHTPAR SEMICOLON
      | PRINT LEFTPAR STRING print_var RIGHTPAR SEMICOLON
      ;

com : COMMENT STRING
    ;

// TODO:  MULTI COMMENT
//str : STRING
//     | STRING str
//     ;

// mult_com : STARTCOM str ENDCOM
//          | STARTCOM str ENDCOM
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