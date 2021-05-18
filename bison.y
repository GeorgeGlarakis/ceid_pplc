// DECLARE
%{


%}

// FIRST PART

%union 
{
       char name[50000]; //******* 
       int integer;
       char character; 
}
%start
%token PROGRAM FUNCTION VARS CHAR INTEGER END_FUNCTION RETURN STARTMAIN ENDMAIN
%token <name> ID 
%token <integer> INT
%token <character> CHAR 
%token <name> STRING
%token <character> COMMENT  

//******* 
%type <name> prog dcl func_dcl var_decl type parm_types func main_func mult_stmt stmt assg mult_expr expr binop relop logical_op

%left '||'
%left '&&'
%left '==' '!='
%left '<' '<=' '>' '>='
%left '+' '-'
%left '*' '/'
%right '!' '-'

%%
// production               action


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

func_dcl : type var_decl 
         | dcl ',' var_decl 
         ;

var_decl : ID                           
         | ID '[' INT ']'
         ;

type   : char
 	| int
       ;

parm_types : void
 	    | type ID 
           | type ID '[' ']'  
           | parm_types ',' type ID 
           | parm_types ',' type ID '[' ']'
           ;         

func   : FUNCTION ID '(' parm_types ')' '\n'  func_dcl mult_stmt END_FUNCTION 
 	;

main_func   : STARTMAIN '(' parm_types ')' '\n'  func_dcl mult_stmt ENDMAIN 
 	     ;      

mult_stmt : stmt                
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
 	| expr binop expr
 	| expr relop expr
 	| expr logical_op expr
 	| ID                            
       | ID '(' mult_expr ')' 
       | ID '[' expr ']'
 	| '(' expr ')'                  
 	| INT                        
 	| CHAR                       
 	| STRING
        %token <character> COMMENT                     
       ;

binop	: +
 	| –
 	| *
 	| /
        ;

relop	: ==
 	| !=
 	| <=
 	| <
 	| >=
 	| >
        ;

logical_op : &&
 	    | ||
           ;

com    : COMMENT STRING '\n'
       ;

%%

// THIRD PART