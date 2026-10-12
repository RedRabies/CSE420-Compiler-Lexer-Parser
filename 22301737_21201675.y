%{
#include<iostream>
#include<fstream>
#include<string>
#include"symbol_info.h"

#define YYSTYPE symbol_info*

using namespace std;

int yyparse(void);
int yylex(void);

extern FILE *yyin;

ofstream outlog;
int line_num = 1;

void yyerror(const char *s) {
    outlog << "Error at line " << line_num << ": " << s << "\n\n";
}

%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN GOTO
%token CONST_FLOAT CONST_INT ID
%token ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA COLON SEMICOLON

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program
    {
        outlog << "At line no: " << line_num << " start : program\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "start");
    }
    ;

program : program unit
    {
        string code = $1->getnameofsymbol() + "\n" + $2->getnameofsymbol();
        outlog << "At line no: " << line_num << " program : program unit\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "program");
    }
    | unit
    {
        outlog << "At line no: " << line_num << " program : unit\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "program");
    }
    ;

unit : variable_decl
    {
        outlog << "At line no: " << line_num << " unit : variable_decl\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "unit");
    }
    | func_definition
    {
        outlog << "At line no: " << line_num << " unit : func_definition\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "unit");
    }
    ;

func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement
    {
        string code = $1->getnameofsymbol() + " " + $2->getnameofsymbol() + "(" + $4->getnameofsymbol() + ")" + $6->getnameofsymbol();
        outlog << "At line no: " << line_num << " func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "func_definition");
    }
    | type_specifier ID LPAREN RPAREN compound_statement
    {
        string code = $1->getnameofsymbol() + " " + $2->getnameofsymbol() + "()\n" + $5->getnameofsymbol();
        outlog << "At line no: " << line_num << " func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "func_definition");
    }
    ;

param_list : param_list COMMA type_specifier ID
    {
        string code = $1->getnameofsymbol() + "," + $3->getnameofsymbol() + " " + $4->getnameofsymbol();
        outlog << "At line no: " << line_num << " param_list : param_list COMMA type_specifier ID\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "param_list");
    }
    | param_list COMMA type_specifier
    {
        string code = $1->getnameofsymbol() + "," + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " param_list : param_list COMMA type_specifier\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "param_list");
    }
    | type_specifier ID
    {
        string code = $1->getnameofsymbol() + " " + $2->getnameofsymbol();
        outlog << "At line no: " << line_num << " param_list : type_specifier ID\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "param_list");
    }
    | type_specifier
    {
        outlog << "At line no: " << line_num << " param_list : type_specifier\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "param_list");
    }
    ;

compound_statement : LCURL statements RCURL
    {
        string code = "{\n" + $2->getnameofsymbol() + "\n}";
        outlog << "At line no: " << line_num << " compound_statement : LCURL statements RCURL\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "compound_statement");
    }
    | LCURL RCURL
    {
        outlog << "At line no: " << line_num << " compound_statement : LCURL RCURL\n\n" << "{}" << "\n\n";
        $$ = new symbol_info("{}", "compound_statement");
    }
    ;

variable_decl : type_specifier declaration_list SEMICOLON
    {
        string code = $1->getnameofsymbol() + " " + $2->getnameofsymbol() + ";";
        outlog << "At line no: " << line_num << " variable_decl : type_specifier declaration_list SEMICOLON\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "variable_decl");
    }
    ;

type_specifier : INT
    {
        outlog << "At line no: " << line_num << " type_specifier : INT\n\n" << "int" << "\n\n";
        $$ = new symbol_info("int", "type_specifier");
    }
    | FLOAT
    {
        outlog << "At line no: " << line_num << " type_specifier : FLOAT\n\n" << "float" << "\n\n";
        $$ = new symbol_info("float", "type_specifier");
    }
    | VOID
    {
        outlog << "At line no: " << line_num << " type_specifier : VOID\n\n" << "void" << "\n\n";
        $$ = new symbol_info("void", "type_specifier");
    }
    | CHAR
    {
        outlog << "At line no: " << line_num << " type_specifier : CHAR\n\n" << "char" << "\n\n";
        $$ = new symbol_info("char", "type_specifier");
    }
    ;

declaration_list : declaration_list COMMA ID
    {
        string code = $1->getnameofsymbol() + "," + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " declaration_list : declaration_list COMMA ID\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "declaration_list");
    }
    | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
    {
        string code = $1->getnameofsymbol() + "," + $3->getnameofsymbol() + "[" + $5->getnameofsymbol() + "]";
        outlog << "At line no: " << line_num << " declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "declaration_list");
    }
    | ID
    {
        outlog << "At line no: " << line_num << " declaration_list : ID\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "declaration_list");
    }
    | ID LTHIRD CONST_INT RTHIRD
    {
        string code = $1->getnameofsymbol() + "[" + $3->getnameofsymbol() + "]";
        outlog << "At line no: " << line_num << " declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "declaration_list");
    }
    ;

statements : statement
    {
        outlog << "At line no: " << line_num << " statements : statement\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "statements");
    }
    | statements statement
    {
        string code = $1->getnameofsymbol() + "\n" + $2->getnameofsymbol();
        outlog << "At line no: " << line_num << " statements : statements statement\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "statements");
    }
    ;

statement : variable_decl
    {
        outlog << "At line no: " << line_num << " statement : variable_decl\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "statement");
    }
    | expression_statement
    {
        outlog << "At line no: " << line_num << " statement : expression_statement\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "statement");
    }
    | compound_statement
    {
        outlog << "At line no: " << line_num << " statement : compound_statement\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "statement");
    }
    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    {
        string code = "for(" + $3->getnameofsymbol() + $4->getnameofsymbol() + $5->getnameofsymbol() + ")\n" + $7->getnameofsymbol();
        outlog << "At line no: " << line_num << " statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "statement");
    }
    | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
    {
        string code = "if(" + $3->getnameofsymbol() + ")\n" + $5->getnameofsymbol();
        outlog << "At line no: " << line_num << " statement : IF LPAREN expression RPAREN statement\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "statement");
    }
    | IF LPAREN expression RPAREN statement ELSE statement
    {
        string code = "if(" + $3->getnameofsymbol() + ")\n" + $5->getnameofsymbol() + "\nelse\n" + $7->getnameofsymbol();
        outlog << "At line no: " << line_num << " statement : IF LPAREN expression RPAREN statement ELSE statement\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "statement");
    }
    | WHILE LPAREN expression RPAREN statement
    {
        string code = "while(" + $3->getnameofsymbol() + ")\n" + $5->getnameofsymbol();
        outlog << "At line no: " << line_num << " statement : WHILE LPAREN expression RPAREN statement\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "statement");
    }
    | PRINTLN LPAREN ID RPAREN SEMICOLON
    {
        string code = "printf(" + $3->getnameofsymbol() + ");";
        outlog << "At line no: " << line_num << " statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "statement");
    }
    | RETURN expression SEMICOLON
    {
        string code = "return " + $2->getnameofsymbol() + ";";
        outlog << "At line no: " << line_num << " statement : RETURN expression SEMICOLON\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "statement");
    }
    ;

expression_statement : SEMICOLON
    {
        outlog << "At line no: " << line_num << " expression_statement : SEMICOLON\n\n" << ";" << "\n\n";
        $$ = new symbol_info(";", "expression_statement");
    }
    | expression SEMICOLON
    {
        string code = $1->getnameofsymbol() + ";";
        outlog << "At line no: " << line_num << " expression_statement : expression SEMICOLON\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "expression_statement");
    }
    ;

variable : ID
    {
        outlog << "At line no: " << line_num << " variable : ID\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "variable");
    }
    | ID LTHIRD expression RTHIRD
    {
        string code = $1->getnameofsymbol() + "[" + $3->getnameofsymbol() + "]";
        outlog << "At line no: " << line_num << " variable : ID LTHIRD expression RTHIRD\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "variable");
    }
    ;

expression : logic_expression
    {
        outlog << "At line no: " << line_num << " expression : logic_expression\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "expression");
    }
    | variable ASSIGNOP logic_expression
    {
        string code = $1->getnameofsymbol() + "=" + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " expression : variable ASSIGNOP logic_expression\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "expression");
    }
    ;

logic_expression : rel_expression
    {
        outlog << "At line no: " << line_num << " logic_expression : rel_expression\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "logic_expression");
    }
    | rel_expression LOGICOP rel_expression
    {
        string code = $1->getnameofsymbol() + $2->getnameofsymbol() + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " logic_expression : rel_expression LOGICOP rel_expression\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "logic_expression");
    }
    ;

rel_expression : simple_expression
    {
        outlog << "At line no: " << line_num << " rel_expression : simple_expression\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "rel_expression");
    }
    | simple_expression RELOP simple_expression
    {
        string code = $1->getnameofsymbol() + $2->getnameofsymbol() + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " rel_expression : simple_expression RELOP simple_expression\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "rel_expression");
    }
    ;

simple_expression : term
    {
        outlog << "At line no: " << line_num << " simple_expression : term\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "simple_expression");
    }
    | simple_expression ADDOP term
    {
        string code = $1->getnameofsymbol() + $2->getnameofsymbol() + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " simple_expression : simple_expression ADDOP term\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "simple_expression");
    }
    ;

term : unary_expression
    {
        outlog << "At line no: " << line_num << " term : unary_expression\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "term");
    }
    | term MULOP unary_expression
    {
        string code = $1->getnameofsymbol() + $2->getnameofsymbol() + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " term : term MULOP unary_expression\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "term");
    }
    ;

unary_expression : ADDOP unary_expression
    {
        string code = $1->getnameofsymbol() + $2->getnameofsymbol();
        outlog << "At line no: " << line_num << " unary_expression : ADDOP unary_expression\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "unary_expression");
    }
    | NOT unary_expression
    {
        string code = "!" + $2->getnameofsymbol();
        outlog << "At line no: " << line_num << " unary_expression : NOT unary_expression\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "unary_expression");
    }
    | factor_info
    {
        outlog << "At line no: " << line_num << " unary_expression : factor_info\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "unary_expression");
    }
    ;

factor_info : factor
    {
        outlog << "At line no: " << line_num << " factor_info : factor\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "factor_info");
    }
    ;

factor : variable
    {
        outlog << "At line no: " << line_num << " factor : variable\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "factor");
    }
    | ID LPAREN argument_list RPAREN
    {
        string code = $1->getnameofsymbol() + "(" + $3->getnameofsymbol() + ")";
        outlog << "At line no: " << line_num << " factor : ID LPAREN argument_list RPAREN\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "factor");
    }
    | LPAREN expression RPAREN
    {
        string code = "(" + $2->getnameofsymbol() + ")";
        outlog << "At line no: " << line_num << " factor : LPAREN expression RPAREN\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "factor");
    }
    | CONST_INT
    {
        outlog << "At line no: " << line_num << " factor : CONST_INT\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "factor");
    }
    | CONST_FLOAT
    {
        outlog << "At line no: " << line_num << " factor : CONST_FLOAT\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "factor");
    }
    | variable INCOP
    {
        string code = $1->getnameofsymbol() + "++";
        outlog << "At line no: " << line_num << " factor : variable INCOP\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "factor");
    }
    | variable DECOP
    {
        string code = $1->getnameofsymbol() + "--";
        outlog << "At line no: " << line_num << " factor : variable DECOP\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "factor");
    }
    ;

argument_list : arguments
    {
        outlog << "At line no: " << line_num << " argument_list : arguments\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "argument_list");
    }
    | 
    {
        outlog << "At line no: " << line_num << " argument_list : \n\n" << "" << "\n\n";
        $$ = new symbol_info("", "argument_list");
    }
    ;

arguments : arguments COMMA logic_expression
    {
        string code = $1->getnameofsymbol() + "," + $3->getnameofsymbol();
        outlog << "At line no: " << line_num << " arguments : arguments COMMA logic_expression\n\n" << code << "\n\n";
        $$ = new symbol_info(code, "arguments");
    }
    | logic_expression
    {
        outlog << "At line no: " << line_num << " arguments : logic_expression\n\n" << $1->getnameofsymbol() << "\n\n";
        $$ = new symbol_info($1->getnameofsymbol(), "arguments");
    }
    ;

%%

int main(int c, char *v[])
{
    if(c != 2) 
    {
        cout << "Please provide input file name" << endl;
        return 0;
    }
    
    yyin = fopen(v[1], "r");
    if(yyin == NULL)
    {
        cout << "Couldn't open file" << endl;
        return 0;
    }
    
    outlog.open("my_log.txt", ios::trunc);
    
    yyparse();
    
    outlog << "Total lines: " << line_num << endl;
    
    outlog.close();
    fclose(yyin);
    
    return 0;
}