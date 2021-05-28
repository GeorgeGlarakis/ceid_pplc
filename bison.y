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

%token LEFTCURL RIGHTCURL LEFTBRA RIGHTBRA LEFTPAR RIGHTPAR COMMA SEMICOLON ASSIGN NEWLINE

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

prog	: PROGRAM ID '\n'
      | dcl ';'               
      | func                  
      | prog dcl ';'
      | prog func
      ;

dcl	: type var_decl 
     | dcl ',' var_decl 
 	| extern type ID '(' parm_types ')'         
     | type ID '(' parm_types ')' 
 	| extern void ID '(' parm_types ')' 
     | void ID '(' parm_types ')' 
     | dcl ',' ID '(' parm_types ')'
     ;

func_dcl : VARS type var_decl 
         | dcl ',' var_decl 
         ;

var_decl : ID                           
         | ID '[' INT ']'
         | var_decl ',' ID
         | var_decl ',' ID '[' INT ']'
         ;

type  : CHAR
 	| INTEGER
      ;

parm_types : void
 	     | type ID 
           | type ID '[' ']'  
           | parm_types ',' type ID 
           | parm_types ',' type ID '[' ']'
           ;         

// υποχρεωτική προσθήκη RETURN πριν τη λήξη της συνάρτησης
func  : FUNCTION ID '(' parm_types ')' '\n'  func_dcl mult_stmt END_FUNCTION 
 	;

main_func  : STARTMAIN '(' parm_types ')' '\n'  func_dcl mult_stmt ENDMAIN 
 	     ;      

mult_stmt : stmt
          | com stmt
          | stmt com                
          | mult_stmt stmt
          | ''                  
          ;

stmt	: if '(' expr ')' stmt                          
      | if '(' expr ')' stmt else stmt 
 	| while '(' expr ')' stmt 
 	| for '(' ';' ';' ')' stmt
      | for '(' ';' ';' assg ')' stmt
      | for '(' ';' expr ';' ')' stmt
      | for '(' ';' expr ';' assg ')' stmt
      | for '(' assg ';' ';' ')' stmt
      | for '(' assg ';' ';' assg ')' stmt
      | for '(' assg ';' expr ';' ')' stmt
      | for '(' assg ';' expr ';' assg ')' stmt
 	| RETURN expr ';'
      | RETURN ';'
 	| assg ';'
 	| ID '(' mult_expr ')' ';'
 	| '{' stmt '}'
      | '{' '}'
 	| ';'                                           
      ;


assg	: ID '=' expr                             
      | ID '[' expr ']' '=' expr                
      ;

mult_expr : expr                        
          | mult_expr ',' expr
          | ''
          ;

expr	: '–' expr                      
 	| '!' expr                      
 	| expr BINOP expr
 	| expr RELOP expr
 	| expr LOGICALOP expr
 	| ID                            
      | ID '(' mult_expr ')' 
      | ID '[' expr ']'
 	| '(' expr ')'                  
 	| INT                        
 	| CHARACTER                                           
      ;

com   : COMMENT STRING '\n'
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
