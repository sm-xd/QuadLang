#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef enum {
    NODE_ASSIGN,
    NODE_QUAD,
    NODE_SHOW,
    NODE_IF,
    NODE_EXPR_LITERAL, // For literal number conditions.
    NODE_EXPR_COMP     // For variable comparisons (e.g. a > 5).
} NodeType;

typedef struct Node {
    NodeType type;
    struct Node *next; // To chain statements in a sequence.
    union {
        struct { // For assignment: LET var = number.
            char *var;
            int value;
        } assign;
        struct { // For quadratic: QUAD(var, var, var).
            char *var1;
            char *var2;
            char *var3;
        } quad;
        struct { // For IF statements.
            struct Node *cond;      // Condition expression.
            struct Node *thenStmt;  // Statement if true.
            struct Node *elseStmt;  // Statement if false (optional).
        } ifnode;
        struct { // For literal expressions.
            int literal;
        } literal;
        struct { // For variable comparisons.
            char *var;
            char *cmp; // Comparison operator as string.
            int number;
        } comp;
    } data;
} Node;

#endif
