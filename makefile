pplc: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o pplc

lex.yy.c: y.tab.c flex.l
	lex flex.l

y.tab.c: bison.y
	yacc -d bison.y

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h pplc pplc.dSYM