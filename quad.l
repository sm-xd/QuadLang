%{
#include "quad.tab.h"
%}

%%

"LET"       { return LET; }
"QUAD"      { return QUAD; }
"SHOW"      { return SHOW; }
"ROOTS"     { return ROOTS; }
[a-zA-Z][a-zA-Z0-9]*  { yylval.str = strdup(yytext); return VAR; }
[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
"-"[0-9]+   { yylval.num = atoi(yytext); return NUMBER; }  // Handle negative numbers
"="         { return '='; }
","         { return ','; }
"("         { return '('; }
")"         { return ')'; }
[ \t\n]+    { /* Ignore whitespace */ }
.           { printf("Invalid character: %s\n", yytext); }

%%

int yywrap(void) {
    return 1;  // Return 1 to signal the end of input.
}
