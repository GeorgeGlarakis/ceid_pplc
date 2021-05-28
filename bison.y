%{
#include <stdio.h>

int yylex();
extern FILE *yyin;    
extern int yylineno;

%}
%union 
{
       char name[50000]; //******* 
       int integer;
       char character; 
}
%start
%token PROGRAM FUNCTION VARS CHAR INTEGER END_FUNCTION RETURN STARTMAIN ENDMAIN
%token IF THEN ENDIF ELSEIF ELSE FOR TO STEP ENDFOR WHILE ENDWHILE SWITCH CASE DEFAULT ENDSWITCH 
%token PRINT BREAK STRUCT ENDSTRUCT TYPEDEF 
%token <name> ID 
%token <integer> INT
%token <character> CHARACTER 
%token <name> STRING
%token <character> COMMENT
%token <character> BINOP
%token <name> RELOP
%token <name> LOGICALOP  

%token LEFTCURL RIGHTCURL LEFTBRA RIGHTBRA LEFTPAR RIGHTPAR COMMA SEMICOLON COLON ASSIGN NEWLINE NEG NOT

//******* 
%type <name> prog dcl func_dcl var_decl type parm_types func main_func mult_stmt stmt assg mult_expr expr com

%left '||'
%left '&&'
%left '==' '!='
%left '<' '<=' '>' '>='
%left '+' '-'
%left '*' '/'
%right '!' '-'

%%

prog  : PROGRAM ID NEWLINE
    //   | dcl SEMICOLON               
    //   | func                  
    //   | prog dcl SEMICOLON
      | prog func
      | prog main_func
      ;

dcl	: type var_decl 
    //  | dcl COMMA var_decl 
 	//  | extern type ID LEFTPAR parm_types RIGHTPAR         
    //  | type ID LEFTPAR parm_types RIGHTPAR 
 	//  | extern void ID LEFTPAR parm_types RIGHTPAR 
    //  | void ID LEFTPAR parm_types RIGHTPAR 
    //  | dcl COMMA ID LEFTPAR parm_types RIGHTPAR
     ;

func_dcl : VARS type var_decl SEMICOLON
         | dcl COMMA var_decl 
         ;

var_decl : ID                           
         | ID LEFTBRA INT RIGHTBRA
         | var_decl COMMA ID
         | var_decl COMMA ID LEFTBRA INT RIGHTBRA
         ;

type  : CHAR
 	| INTEGER
      ;

parm_types : void
 	     | type ID 
           | type ID LEFTBRA RIGHTBRA  
           | parm_types COMMA type ID 
           | parm_types COMMA type ID LEFTBRA RIGHTBRA
           ;         

// υποχρεωτική προσθήκη RETURN πριν τη λήξη της συνάρτησης
func  : FUNCTION ID LEFTPAR parm_types RIGHTPAR NEWLINE  func_dcl mult_stmt END_FUNCTION 
 	;

main_func  : STARTMAIN LEFTPAR parm_types RIGHTPAR NEWLINE  func_dcl mult_stmt ENDMAIN 
 	     ;      

mult_stmt : stmt
          | com stmt
          | stmt com                
          | mult_stmt stmt
          | ''                  
          ;

stmt	: IF LEFTPAR expr RIGHTPAR THEN stmt ENDIF
    | IF LEFTPAR expr RIGHTPAR THEN stmt if_elseif ENDIF
    | IF LEFTPAR expr RIGHTPAR THEN stmt if_elseif ELSE stmt ENDIF

 	| WHILE LEFTPAR expr RIGHTPAR stmt ENDWHILE 

    | FOR assg TO INT STEP INT NEWLINE mult_stmt NEWLINE ENDFOR
    
    | SWITCH LEFTPAR stmt RIGHTPAR sw_case DEFAULT COLON stmt ENDSWITCH
    | SWITCH LEFTPAR stmt RIGHTPAR sw_case ENDSWITCH

 	| RETURN expr SEMICOLON
      | RETURN SEMICOLON
 	| assg SEMICOLON
 	| ID LEFTPAR mult_expr RIGHTPAR SEMICOLON
 	| LEFTCURL stmt RIGHTCURL
      | LEFTCURL RIGHTCURL
 	| SEMICOLON                                           
      ;

if_elseif   : ELSEIF stmt if_elseif
    | ELSEIF stmt
    ;

sw_case    : CASE LEFTPAR stmt RIGHTPAR COLON sw_case
    | CASE LEFTPAR stmt RIGHTPAR COLON 
    ;

assg	: ID ASSIGN expr                             
      | ID LEFTBRA expr RIGHTBRA ASSIGN expr                
      ;

mult_expr : expr                        
          | mult_expr COMMA expr
          | ''
          ;

expr	: NEG expr                      
 	| NOT expr                      
 	| expr BINOP expr
 	| expr RELOP expr
 	| expr LOGICALOP expr
 	| ID                            
      | ID LEFTPAR mult_expr RIGHTPAR 
      | ID LEFTBRA expr RIGHTBRA
 	| LEFTPAR expr RIGHTPAR                  
 	| INT                        
 	| CHARACTER                                           
      ;

com   : COMMENT STRING NEWLINE
      ;

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
            sleep(2);
            printf("\n===================================\n\n");
            yyin = file_pointer;   // Search about yyin
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