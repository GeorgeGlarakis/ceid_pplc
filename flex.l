%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <errno.h>
  #include "y.tab.h"
  extern int yylex();
%}

%option yylineno
%option nounput
%option noinput

%%

[ \t\n]					                  {;}
"PROGRAM"                       {printf("PROGRAM "); return PROGRAM;}
"FUNCTION"                      {printf("FUNCTION "); return FUNCTION;}
"VARS"                          {printf("VARS "); return VARS;}
"CHAR"                          {printf("CHAR "); return CHAR;}
"INTEGER"                       {printf("INTEGER "); return INTEGER;}
"END_FUNCTION"                  {printf("END_FUNCTION "); return END_FUNCTION;}
"RETURN"                        {printf("RETURN "); return RETURN;}
"STARTMAIN"                     {printf("STARTMAIN "); return STARTMAIN;}
"ENDMAIN"                       {printf("ENDMAIN "); return ENDMAIN;}
"IF"                            {printf("IF "); return IF;}
"THEN"                          {printf("THEN "); return THEN;}
"ENDIF"                         {printf("ENDIF "); return ENDIF;}
"ELSEIF"                        {printf("ELSEIF "); return ELSEIF;}
"ELSE"                          {printf("ELSE "); return ELSE;}
"FOR"                           {printf("FOR "); return FOR;}
"TO"                            {printf("TO "); return TO;}
"STEP"                          {printf("STEP "); return STEP;}
"ENDFOR"                        {printf("ENDFOR "); return ENDFOR;}
"WHILE"                         {printf("WHILE "); return WHILE;}
"ENDWHILE"                      {printf("ENDWHILE "); return ENDWHILE;}
"SWITCH"                        {printf("SWITCH "); return SWITCH;}
"CASE"                          {printf("CASE "); return CASE;}
"DEFAULT"                       {printf("DEFAULT "); return DEFAULT;}
"ENDSWITCH"                     {printf("ENDSWITCH "); return ENDSWITCH;}
"PRINT"                         {printf("PRINT "); return PRINT;}
"BREAK"                         {printf("BREAK "); return BREAK;}
"STRUCT"                        {printf("STRUCT "); return STRUCT;}
"ENDSTRUCT"                     {printf("ENDSTRUCT "); return ENDSTRUCT;}
"TYPEDEF"                       {printf("TYPEDEF "); return TYPEDEF;}

"{"                             {printf("LEFTCURL "); return LEFTCURL;}
"}"                             {printf("RIGHTCURL "); return RIGHTCURL;}
"["                             {printf("LEFTBRA "); return LEFTBRA;}
"]"                             {printf("RIGHTBRA "); return RIGHTBRA;}
"("                             {printf("LEFTPAR "); return LEFTPAR;}
")"                             {printf("RIGHTPAR "); return RIGHTPAR;}
","                             {printf("COMMA "); return COMMA;}
";"                             {printf("SEMICOLON "); return SEMICOLON;}
":"                             {printf("COLON "); return COLON;}
"="                             {printf("ASSIGN "); return ASSIGN;}
"/*"                            {printf("STARTCOM "); return STARTCOM;}
"*/"                            {printf("ENDCOM "); return ENDCOM;}
"!"                             {printf("NOT "); return NOT;}

[a-zA-Z]                        {printf("CHARACTER "); return CHARACTER;}
[a-zA-Z][_a-zA-Z0-9]+	          {printf("ID "); return ID;}
[\-? 0-9]+				              {printf("INT "); return INT;}
[+|\-|*|/]                      {printf("BINOP "); return BINOP;}
"=="                            {printf("RELOP "); return RELOP;}
"!="                            {printf("RELOP "); return RELOP;}
"<="                            {printf("RELOP "); return RELOP;}
">="                            {printf("RELOP "); return RELOP;}
"<"                             {printf("RELOP "); return RELOP;}
">"                             {printf("RELOP "); return RELOP;}
"&&"                            {printf("LOGICALOP "); return LOGICALOP;}
"||"                            {printf("LOGICALOP "); return LOGICALOP;}
"%"                             {printf("COMMENT "); return COMMENT;}
\"([^\n\"\\]*(\\[.\n])*)*\"     {printf("STRING "); return STRING;}

.					                      {printf("Unexpected character\n");}

%%

int yywrap(){
    return 1;
}
