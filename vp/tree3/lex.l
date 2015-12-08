%{
#include "typedef.h"
#include "parse.h"
%}

digit         [0-9]
letter        [a-zA-Z]

%option noyywrap 

%%
"("				{
//	printf("(\n");
	return KEY_LPARENT;
}

")"				{
//	printf(")\n");
	return KEY_RPARENT;
}

"NULL"		{
//	printf("NULL");
	return KEY_NULL;
}

{digit}+  { 
	int x = atoi(yytext);
//	printf("%d\n",x);
	yylval.num = x;
//	fflush(stdout);
	return NUMBER;     
}

[ \t\n\r] {}           /* skip whitespace */

.   { 
	printf("Unknown character [%c]\n",yytext[0]);
	fflush(stdout);
	return UNKNOWN;    
}

%%

