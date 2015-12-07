%{
//#include "y.tab.h"
%}

digit         [0-9]
letter        [a-zA-Z]

%%
"("				{return KEY_LPARENT;}
")"				{return KEY_RPARENT;}
"NULL"		{return KEY_NULL;}
{digit}+  { 
	yylval.num = atoi(yytext);
	return NUMBER;     
}
[ \t\n\r]            /* skip whitespace */
.   { 
	printf("Unknown character [%c]\n",yytext[0]);
	return UNKNOWN;    
}
%%

