%{
#include "y.tab.h"
%}

digit         [0-9]
letter        [a-zA-Z]

%%
"("				{return LPARENT;}
")"				{return RPARENT;}
"NULL"		{return NULL;}
{digit}* {
}
{letter}({letter}|{digit})* {
                       yylval.id = strdup(yytext);
											                        return IDENT;      }
																							{digit}+             { yylval.num = atoi(yytext);
																							                       return NUMBER;     }
																																		 [ \t\n\r]            /* skip whitespace */
																																		 .                    { printf("Unknown character [%c]\n",yytext[0]);
																																		                        return UNKNOWN;    }
																																														%%

																																														int yywrap(void){return 1;}
