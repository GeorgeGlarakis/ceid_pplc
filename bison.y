// DECLARE
%{


%}

// FIRST PART
%token NAME

%%
// production               action


prog	: dcl ';'               {$$ = $1;}
        | func                  {$$ = $1;}
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

var_decl : id                           {$$ = $1;}
         | id '[' intcon ']'
         ;

type    : char
 	| int
        ;

parm_types : void
 	   | type id 
           | type id '[' ']'  
           | parm_types ',' type id 
           | parm_types ',' type id '[' ']'
           ;         

func    : type id '(' parm_types ')' '{' func_dcl mult_stmt '}'
 	| void id '(' parm_types ')' '{' func_dcl mult_stmt '}'
        ;

mult_stmt : stmt                {$$ = $1;}
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
 	| return expr ';'
        | return ';'
 	| assg ';'
 	| id '(' mult_expr ')' ';'
 	| '{' stmt '}'
        | '{' '}'
 	| ';'                                           {;}
        ;


assg	: id '=' expr                             {$1 = $2;}
        | id '[' expr ']' '=' expr                {$1 = $3;}
        ;

mult_expr : expr                        {$$ = $1;}
          | mult_expr ',' expr
          | ''
          ;

expr	: '–' expr                      {$$ = - $1;}
 	| '!' expr                      {$$ = ! $1;}
 	| expr binop expr
 	| expr relop expr
 	| expr logical_op expr
 	| id                            {$$ = $1;}
        | id '(' mult_expr ')' 
        | id '[' expr ']'
 	| '(' expr ')'                  {$$ = $1;}
 	| intcon                        {$$ = $1;}
 	| charcon                       {$$ = $1;}
 	| stringcon                     {$$ = $1;}
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