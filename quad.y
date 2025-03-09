%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(const char *s);
int yylex();
int symbol_table[256];  // Store variables (single character names)

int a, b, c;
double root1, root2;

%}

%union {
    int num;
    char *str;
}

%token LET QUAD SHOW ROOTS VAR NUMBER
%type <num> NUMBER
%type <str> VAR

%%

program:
    | program statement
    ;

statement:
    LET VAR '=' NUMBER { 
        symbol_table[$2[0]] = $4; 
        printf("%s = %d stored.\n", $2, $4);
    }
    | QUAD '(' VAR ',' VAR ',' VAR ')' {
        a = symbol_table[$3[0]];
        b = symbol_table[$5[0]];
        c = symbol_table[$7[0]];
        double discriminant = b * b - 4 * a * c;
        if (discriminant >= 0) {
            root1 = (-b + sqrt(discriminant)) / (2 * a);
            root2 = (-b - sqrt(discriminant)) / (2 * a);
            printf("Quadratic roots computed.\n");
        } else {
            printf("No real roots exist.\n");
        }
    }
    | SHOW ROOTS {
        printf("x1 = %.2lf, x2 = %.2lf\n", root1, root2);
    }
    ;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter QuadLang expressions:\n");
    yyparse();
    return 0;
}
