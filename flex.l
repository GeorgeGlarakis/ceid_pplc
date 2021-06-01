%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <errno.h>
  #include "y.tab.h"
  extern int yylex();
  void yyerror(char *s);
%}

%option yylineno

%%

[ \t]					                {;}
"PROGRAM"                       {return PROGRAM;}
"FUNCTION"                      {return FUNCTION;}
"VARS"                          {return VARS;}
"CHAR"                          {return CHAR;}
"INTEGER"                       {return INTEGER;}
"END_FUNCTION"                  {return END_FUNCTION;}
"RETURN"                        {return RETURN;}
"STARTMAIN"                     {return STARTMAIN;}
"ENDMAIN"                       {return ENDMAIN;}
"IF"                            {return IF;}
"THEN"                          {return THEN;}
"ENDIF"                         {return ENDIF;}
"ELSEIF"                        {return ELSEIF;}
"ELSE"                          {return ELSE;}
"FOR"                           {return FOR;}
"TO"                            {return TO;}
"STEP"                          {return STEP;}
"ENDFOR"                        {return ENDFOR;}
"WHILE"                         {return WHILE;}
"ENDWHILE"                      {return ENDWHILE;}
"SWITCH"                        {return SWITCH;}
"CASE"                          {return CASE;}
"DEFAULT"                       {return DEFAULT;}
"ENDSWITCH"                     {return ENDSWITCH;}
"PRINT"                         {return PRINT;}
"BREAK"                         {return BREAK;}
"STRUCT"                        {return STRUCT;}
"ENDSTRUCT"                     {return ENDSTRUCT;}
"TYPEDEF"                       {return TYPEDEF;}




"{"                             {return LEFTCURL;}
"}"                            {return RIGHTCURL;}
"["                           {return LEFTBRA;}
"]"                           {return RIGHTBRA;}
"("                             {return LEFTPAR;}
")"                             {return RIGHTPAR;}
","                             {return COMMA;}
";"                             {return SEMICOLON;}
":"                             {return COLON;}
"="                             {return ASSIGN;}
["]                             {return QUOTES;}
[\n]                           {return NEWLINE;}
"/*"                          {return STARTCOM;}
"*/"                          {return ENDCOM;}



[a-zA-Z]                        {return CHARACTER;}
[a-zA-Z][_a-zA-Z0-9]+	          {return ID;}
[1-9][0-9]+				              {return INT;}
[+|-|*|/]                          {return BINOP;}
['=='|'!='|'<='|'>='|'<'|'>']   {return RELOP;}
['&&'|'||']                     {return LOGICALOP;}
"%"                             {return COMMENT;}
['ch']+                         {return STRING;} 
.					                      {printf("unexpected character\n");}

%%

int yywrap(){
    return 1;
}
