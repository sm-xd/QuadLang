%{
#include "ast.h"      // Ensure that Node and AST definitions are available
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void yyerror(const char *s);
int yylex();

int symbol_table[256]; // Variable storage
int a, b, c;
double root1, root2;

// Global pointer to the AST root (a sequence of statements)
Node *ast_root = NULL;

// Function declarations for AST node creation
Node *create_assign_node(char *var, int value);
Node *create_quad_node(char *var1, char *var2, char *var3);
Node *create_show_node();
Node *create_if_node(Node *cond, Node *thenStmt, Node *elseStmt);
Node *create_comp_node(char *var, char *cmp, int number);
Node *create_literal_node(int literal);
Node *append_node(Node *list, Node *node);

// Evaluation functions
void evaluate(Node *node);
int evaluate_expr(Node *node);
%}

/* This block ensures that Node is defined before the %union is processed */
%code requires {
#include "ast.h"
}

%union {
    int num;
    char *str;
    Node *node;
}

%token LET QUAD SHOW ROOTS IF ELSE THEN ENDIF
%token <str> CMP
%token <num> NUMBER
%token <str> VAR
%type <node> program statement assign quad show if_statement opt_else condition

%%

program:
      /* empty */ { $$ = NULL; ast_root = $$; }
    | program statement { $$ = append_node($1, $2); ast_root = $$; }
    ;

statement:
      assign       { $$ = $1; }
    | quad         { $$ = $1; }
    | show         { $$ = $1; }
    | if_statement { $$ = $1; }
    ;

assign:
    LET VAR '=' NUMBER { $$ = create_assign_node($2, $4); }
    ;

quad:
    QUAD '(' VAR ',' VAR ',' VAR ')' { $$ = create_quad_node($3, $5, $7); }
    ;

show:
    SHOW ROOTS { $$ = create_show_node(); }
    ;

if_statement:
    IF condition THEN statement opt_else ENDIF { $$ = create_if_node($2, $4, $5); }
    ;

opt_else:
      /* empty */ { $$ = NULL; }
    | ELSE statement { $$ = $2; }
    ;

condition:
    VAR CMP NUMBER { $$ = create_comp_node($1, $2, $3); }
    | NUMBER       { $$ = create_literal_node($1); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

// --- AST Node Creation Functions ---

Node *create_assign_node(char *var, int value) {
    Node *node = malloc(sizeof(Node));
    node->type = NODE_ASSIGN;
    node->next = NULL;
    node->data.assign.var = var;
    node->data.assign.value = value;
    return node;
}

Node *create_quad_node(char *var1, char *var2, char *var3) {
    Node *node = malloc(sizeof(Node));
    node->type = NODE_QUAD;
    node->next = NULL;
    node->data.quad.var1 = var1;
    node->data.quad.var2 = var2;
    node->data.quad.var3 = var3;
    return node;
}

Node *create_show_node() {
    Node *node = malloc(sizeof(Node));
    node->type = NODE_SHOW;
    node->next = NULL;
    return node;
}

Node *create_if_node(Node *cond, Node *thenStmt, Node *elseStmt) {
    Node *node = malloc(sizeof(Node));
    node->type = NODE_IF;
    node->next = NULL;
    node->data.ifnode.cond = cond;
    node->data.ifnode.thenStmt = thenStmt;
    node->data.ifnode.elseStmt = elseStmt;
    return node;
}

Node *create_comp_node(char *var, char *cmp, int number) {
    Node *node = malloc(sizeof(Node));
    node->type = NODE_EXPR_COMP;
    node->next = NULL;
    node->data.comp.var = var;
    node->data.comp.cmp = cmp;
    node->data.comp.number = number;
    return node;
}

Node *create_literal_node(int literal) {
    Node *node = malloc(sizeof(Node));
    node->type = NODE_EXPR_LITERAL;
    node->next = NULL;
    node->data.literal.literal = literal;
    return node;
}

Node *append_node(Node *list, Node *node) {
    if (list == NULL) return node;
    Node *temp = list;
    while (temp->next != NULL)
        temp = temp->next;
    temp->next = node;
    return list;
}

// --- Evaluation Functions ---

void evaluate(Node *node) {
    while (node) {
        switch (node->type) {
            case NODE_ASSIGN: {
                symbol_table[node->data.assign.var[0]] = node->data.assign.value;
                printf("%s = %d stored.\n", node->data.assign.var, node->data.assign.value);
                break;
            }
            case NODE_QUAD: {
                char var1 = node->data.quad.var1[0];
                char var2 = node->data.quad.var2[0];
                char var3 = node->data.quad.var3[0];
                a = symbol_table[(int)var1];
                b = symbol_table[(int)var2];
                c = symbol_table[(int)var3];
                double discriminant = b * b - 4 * a * c;
                if (discriminant >= 0) {
                    root1 = (-b + sqrt(discriminant)) / (2 * a);
                    root2 = (-b - sqrt(discriminant)) / (2 * a);
                    printf("Quadratic roots computed.\n");
                } else {
                    printf("No real roots exist.\n");
                }
                break;
            }
            case NODE_SHOW: {
                printf("x1 = %.2lf, x2 = %.2lf\n", root1, root2);
                break;
            }
            case NODE_IF: {
                int cond = evaluate_expr(node->data.ifnode.cond);
                if (cond) {
                    evaluate(node->data.ifnode.thenStmt);
                } else if (node->data.ifnode.elseStmt) {
                    evaluate(node->data.ifnode.elseStmt);
                }
                break;
            }
            default:
                break;
        }
        node = node->next;
    }
}

int evaluate_expr(Node *node) {
    if (!node) return 0;
    switch (node->type) {
        case NODE_EXPR_LITERAL:
            return node->data.literal.literal;
        case NODE_EXPR_COMP: {
            int var_value = symbol_table[node->data.comp.var[0]];
            if (strcmp(node->data.comp.cmp, ">") == 0)
                return var_value > node->data.comp.number;
            else if (strcmp(node->data.comp.cmp, "<") == 0)
                return var_value < node->data.comp.number;
            else if (strcmp(node->data.comp.cmp, ">=") == 0)
                return var_value >= node->data.comp.number;
            else if (strcmp(node->data.comp.cmp, "<=") == 0)
                return var_value <= node->data.comp.number;
            else if (strcmp(node->data.comp.cmp, "==") == 0)
                return var_value == node->data.comp.number;
            else if (strcmp(node->data.comp.cmp, "!=") == 0)
                return var_value != node->data.comp.number;
            return 0;
        }
        default:
            return 0;
    }
}

int main() {
    printf("Enter QuadLang expressions:\n");
    yyparse();
    evaluate(ast_root);
    return 0;
}
