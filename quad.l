%{
#include "quad.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"LET"                  { return LET; }
"QUAD"                 { return QUAD; }
"SHOW"                 { return SHOW; }
"ROOTS"                { return ROOTS; }
"IF"                   { return IF; }
"ELSE"                 { return ELSE; }
"THEN"                 { return THEN; }
"ENDIF"                { return ENDIF; }
">="                   { yylval.str = strdup(yytext); return CMP; }
"<="                   { yylval.str = strdup(yytext); return CMP; }
"=="                   { yylval.str = strdup(yytext); return CMP; }
"!="                   { yylval.str = strdup(yytext); return CMP; }
">"                    { yylval.str = strdup(yytext); return CMP; }
"<"                    { yylval.str = strdup(yytext); return CMP; }
[a-zA-Z][a-zA-Z0-9]*     { yylval.str = strdup(yytext); return VAR; }
[0-9]+                 { yylval.num = atoi(yytext); return NUMBER; }
"-"[0-9]+              { yylval.num = atoi(yytext); return NUMBER; }
"="                    { return '='; }
","                    { return ','; }
"("                    { return '('; }
")"                    { return ')'; }
[ \t\n]+               { /* ignore whitespace */ }
.                      { printf("Invalid character: %s\n", yytext); }
%%

int yywrap(void) {
    return 1;
}
