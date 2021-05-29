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
["IF"]                            {yylval.name = yytext; return IF;}
["THEN"]                          {yylval.name = yytext; return THEN;}
["ENDIF"]                         {yylval.name = yytext; return ENDIF;}
["ELSEIF"]                        {yylval.name = yytext; return ELSEIF;}
["ELSE"]                          {yylval.name = yytext; return ELSE;}
["FOR"]                           {yylval.name = yytext; return FOR;}
["TO"]                            {yylval.name = yytext; return TO;}
["STEP"]                          {yylval.name = yytext; return STEP;}
["ENDFOR"]                        {yylval.name = yytext; return ENDFOR;}
["WHILE"]                         {yylval.name = yytext; return WHILE;}
["ENDWHILE"]                      {yylval.name = yytext; return ENDWHILE;}
["SWITCH"]                        {yylval.name = yytext; return SWITCH;}
["CASE"]                          {yylval.name = yytext; return CASE;}
["DEFAULT"]                       {yylval.name = yytext; return DEFAULT;}
["ENDSWITCH"]                     {yylval.name = yytext; return ENDSWITCH;}
["PRINT"]                         {yylval.name = yytext; return PRINT;}
["BREAK"]                         {yylval.name = yytext; return BREAK;}
["STRUCT"]                        {yylval.name = yytext; return STRUCT;}
["ENDSTRUCT"]                     {yylval.name = yytext; return ENDSTRUCT;}
["TYPEDEF"]                       {yylval.name = yytext; return TYPEDEF;}




[{]                             {return LEFTCURL}
[}]                             {return RIGHTCURL}
["["]                           {return LEFTBRA}
["]"]                           {return RIGHTBRA}
[(]                             {return LEFTPAR}
[)]                             {return RIGHTPAR}
[,]                             {return COMMA}
[;]                             {return SEMICOLON}
[:]                             {return COLON}
[=]                             {return ASSIGN}
["]                             {return QUOTES}
[\n]                            {return NEWLINE}
['/*']                          {return STARTCOM}
['*/']                          {return ENDCOM}



[a-zA-Z]                        {yylval.character = yytext[0]; return CHARACTER;}
[a-zA-Z][_a-zA-Z0-9]+	          {yylval.name = yytext; return ID;}
[1-9][0-9]+				              {yylval.integer = atoi(yytext); return INT;}
[+-*/]                          {yylval.character = yytext[0]; return BINOP;}
['=='|'!='|'<='|'>='|'<'|'>']   {yylval.name = yytext; return RELOP;}
['&&'|'||']                     {yylval.name = yytext; return LOGICALOP;}
[%]                             {yylval.character = yytext[0]; return COMMENT}
['ch']+                         {yylval.name = yytext; return STRING;} 

.					                      {printf("unexpected character\n");}

%%

int yywrap(){
    return 1;
}
