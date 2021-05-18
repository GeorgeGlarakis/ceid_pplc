%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <errno.h>
  // #include header file
  extern int yylex();
  void yyerror(char *s);
%}

%%

[a-zA-Z]                {yylval.character = yytext[0]; return CHAR;}
[a-zA-Z][_a-zA-Z0-9]+	  {yylval.name = yytext; return ID;}
[1-9][0-9]+				      {yylval.integer = atoi(yytext); return INT;}
['ch']+                 {yylval.name = yytext; return STRING;} //******* 
[+-*/]                  {yylval.character = yytext[0]; return binop;} //*******
[%]                     {yylval.character = yytext[0]; return COMMENT}
[ \t\n]					;
.					              {printf("unexpected character\n");}

%%