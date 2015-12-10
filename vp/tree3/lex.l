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
"D0"		{
	return KEY_D0;
}
"DN"		{
	return KEY_DN;
}
"T0"		{
	return KEY_T0;
}
"TN"		{
	return KEY_TN;
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

