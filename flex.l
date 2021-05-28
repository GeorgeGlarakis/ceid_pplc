%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <errno.h>
  // #include header file
  extern int yylex();
  void yyerror(char *s);
%}

%option yylineno

%%

[ \t\n]					                {;}
["PROGRAM"]                       {yylval.name = yytext; return PROGRAM;}
["FUNCTION"]                      {yylval.name = yytext; return FUNCTION;}
["VARS"]                          {yylval.name = yytext; return VARS;}
["CHAR"]                          {yylval.name = yytext; return CHAR;}
["INTEGER"]                       {yylval.name = yytext; return INTEGER;}
["END_FUNCTION"]                  {yylval.name = yytext; return END_FUNCTION;}
["RETURN"]                        {yylval.name = yytext; return RETURN;}
["STARTMAIN"]                     {yylval.name = yytext; return STARTMAIN;}
["ENDMAIN"]                       {yylval.name = yytext; return ENDMAIN;}

[{]                             {return LEFTCURL}
[}]                             {return RIGHTCURL}
["["]                           {return LEFTBRA}
["]"]                           {return RIGHTBRA}
[(]                             {return LEFTPAR}
[)]                             {return RIGHTPAR}
[,]                             {return COMMA}
[;]                             {return SEMICOLON}
[=]                             {return ASSIGN}
[\n]                            {return NEWLINE}



[a-zA-Z]                        {yylval.character = yytext[0]; return CHARACTER;}
[a-zA-Z][_a-zA-Z0-9]+	          {yylval.name = yytext; return ID;}
[1-9][0-9]+				              {yylval.integer = atoi(yytext); return INT;}
[+-*/]                          {yylval.character = yytext[0]; return BINOP;}
['=='|'!='|'<='|'>='|'<'|'>']   {yylval.name = yytext; return RELOP;}
['&&'|'||']                     {yylval.name = yytext; return LOGICALOP;}
[%]                             {yylval.character = yytext[0]; return COMMENT}
// ['ch']+                         {yylval.name = yytext; return STRING;} 

.					                      {printf("unexpected character\n");}

%%

int yywrap(){
    return 1;
}