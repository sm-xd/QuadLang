# QuadLang

**Overview:**
- An interpreter for QuadLang supporting:
- Variable assignments
- Quadratic computations (QUAD)
- Showing computed roots (SHOW ROOTS)
- IF-ELSE conditionals with AST evaluation

**Files:**
- `ast.h` – AST type definitions and declarations
- `quad.y` – Bison grammar file (builds the AST)
- `quad.l` – Flex lexer file (tokenizes input)
- `testcases.txt` – Sample test cases with expected outputs

**Build Commands:**
- **Flex:**  
  `flex quad.l`
- **Bison:**  
  `bison -d quad.y`
- **GCC:**  
  `gcc -o quad quad.tab.c lex.yy.c -lm`

**Code Versions:**
- **-main:**  
  - Basic QuadLang interpreter.
  - Runs simple code where you paste input and the output is shown repeatedly until exit.
- **-cnd:**  
  - Enhanced version with added IF-ELSE conditions.

**How to Run:**
- **For -main:**
  - Execute the compiled program (`./quad`).
  - Paste your QuadLang input.
  - Output is displayed after you finish input (signal EOF with Ctrl‑D on Linux).

- **For -cnd:**
  - **Direct Input:**
    - Run `./quad`.
    - Enter your input code interactively.
    - Signal EOF (Ctrl‑D on Linux) to execute and display the output.
  - **Via Input File:**
    - Write your input in a text file (e.g., `input.txt`).
    - Execute with:  
      `./quad < input.txt`


**Notes:**
    - The interpreter builds an AST during parsing; evaluation happens after EOF.
    - Ensure your input strictly follows QuadLang syntax.
