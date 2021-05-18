%{
  #include <stdio.h>
  extern int yylex();
%}

%%

[a-zA-Z]                {yylval.character = yytext[0]; return charcon;}
[a-zA-Z][_a-zA-Z0-9]+	{yylval.name = yytext; return id;}
[1-9][0-9]+				{yylval.integer = atoi(yytext); return intcon;}
['ch']+                 {yylval.name = yytext; return stringcon;} //******* 
[+-*/]                  {yylval.character = yytext[0]; return binop;}
[ \t\n]					;
.					    printf("unexpected character\n");

%%