%{
#include "typedef.h"
#include "parse.h"
%}

digit         [0-9]

%option noyywrap 
%option align
%option fast
%%
"("				{
	return KEY_LPARENT;
}

")"				{
	return KEY_RPARENT;
}

"NULL"		{
	return KEY_NULL;
}

{digit}+  { 
	int x = atoi(yytext);
	yylval.num = x;
	return NUMBER;     
}

[ \t\n\r] {}           /* skip whitespace */

.   { 
	printf("Unknown character [%c]\n",yytext[0]);
	fflush(stdout);
	return UNKNOWN;    
}

%%

