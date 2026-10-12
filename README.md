# C-Subset Compiler: Lexer, Parser & Symbol Table

[![C++](https://img.shields.io/badge/Language-C%2B%2B-blue.svg)](https://isocpp.org/)
[![Flex](https://img.shields.io/badge/Lexer-Flex-red.svg)](https://github.com/westes/flex)
[![Bison](https://img.shields.io/badge/Parser-Bison-orange.svg)](https://www.gnu.org/software/bison/)
[![BRAC University](https://img.shields.io/badge/BRAC%20University-CSE420-green.svg)](https://www.bracu.ac.bd/)

A lexical analyzer and syntax parser implementation for a subset of the C programming language, developed for **CSE420 (Compiler Design)** at BRAC University.

---

## ⚙️ Features
- **Lexical Analysis (Flex)**: Tokenizes identifiers, keywords, integer/float constants, operators, comments, and string literals with line number tracking and error detection.
- **Syntax Analysis (Bison / Yacc)**: Context-free grammar parsing with lookahead LR (LALR) parser tables.
- **Symbol Table Management**: Custom hash-table based Symbol Table with nested scope tracking, type checking, and semantic validation.
- **Diagnostic Logging**: Generation of comprehensive token logs, parse tree transitions, and syntax error reports.

---

## 🛠️ Build and Execution

Run using Linux or WSL with Flex and Bison installed:

```bash
chmod +x script.sh
./script.sh
```

Or manually:
```bash
bison -d -y 22301737_21201675.y
g++ -w -c -o y.o y.tab.c
flex 22301737_21201675.l
g++ -w -c -o l.o lex.yy.c
g++ -o a.out y.o l.o
./a.out input.txt
```

---

## 👨‍💻 Contributors
- **B. M. Muktadir Wafi** (ID: 22301737, GitHub: [@RedRabies](https://github.com/RedRabies))
- BRAC University CSE Department
