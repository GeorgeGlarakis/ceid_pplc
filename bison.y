// DECLARE
%{


%}

// FIRST PART

%union 
{
       char name[50];
       int integer;
       char character; 
}
%start
%token PROGRAM FUNCTION VARS CHAR INTEGER END_FUNCTION RETURN STARTMAIN ENDMAIN
%token <name> id 
%token <integer> intcon 
%token <character> charcon 
%token <name> stringcon  

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


prog	: PROGRAM id '\n'
       | dcl ';'               
       | func                  
       | prog dcl ';'
       | prog func
       ;

dcl	: type var_decl 
       | dcl ',' var_decl 
 	| extern type id '(' parm_types ')'         
       | type id '(' parm_types ')' 
 	| extern void id '(' parm_types ')' 
       | void id '(' parm_types ')' 
       | dcl ',' id '(' parm_types ')'
       ;

func_dcl : type var_decl 
         | dcl ',' var_decl 
         ;

var_decl : id                           
         | id '[' intcon ']'
         ;

type   : char
 	| int
       ;

parm_types : void
 	    | type id 
           | type id '[' ']'  
           | parm_types ',' type id 
           | parm_types ',' type id '[' ']'
           ;         

func   : FUNCTION id '(' parm_types ')' '\n'  func_dcl mult_stmt END_FUNCTION 
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
 	| id '(' mult_expr ')' ';'
 	| '{' stmt '}'
       | '{' '}'
 	| ';'                                           
       ;


assg	: id '=' expr                             
        | id '[' expr ']' '=' expr                
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
 	| id                            
       | id '(' mult_expr ')' 
       | id '[' expr ']'
 	| '(' expr ')'                  
 	| intcon                        
 	| charcon                       
 	| stringcon                     
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

%%

// THIRD PART