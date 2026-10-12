%option noyywrap

%{
#include<iostream>
#include<fstream>
#include<string>
#include"symbol_info.h"

#define YYSTYPE symbol_info*

#include "y.tab.h"

extern YYSTYPE yylval;

using namespace std;

void yyerror(char *);

extern int line_num;
extern ofstream outlog;
string loglist;

%}

/* Regular Definitions */
delim    [ \t\v\r]
ws       {delim}+
newline  \r?\n
letter_  [A-Za-z_]
digit    [0-9]

/* write regular expressions for id, float and integers */
id       {letter_}({letter_}|{digit})*
integers {digit}+
floats   {digit}*(\.{digit}+)|{digit}+\.{digit}*

%%

{ws}        { /* ignore whitespace */ }
{newline}   { line_num++; }

"if"        { 
                loglist="Line no "+to_string(line_num)+": Token <IF> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return IF; 
            }
"else"      { 
                loglist="Line no "+to_string(line_num)+": Token <ELSE> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return ELSE; 
            }
"for"       { 
                loglist="Line no "+to_string(line_num)+": Token <FOR> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return FOR; 
            }
"while"     { 
                loglist="Line no "+to_string(line_num)+": Token <WHILE> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return WHILE; 
            }
"do"        { 
                loglist="Line no "+to_string(line_num)+": Token <DO> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return DO; 
            }
"break"     { 
                loglist="Line no "+to_string(line_num)+": Token <BREAK> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return BREAK; 
            }
"int"       { 
                loglist="Line no "+to_string(line_num)+": Token <INT> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return INT; 
            }
"char"      { 
                loglist="Line no "+to_string(line_num)+": Token <CHAR> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return CHAR; 
            }
"float"     { 
                loglist="Line no "+to_string(line_num)+": Token <FLOAT> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return FLOAT; 
            }
"double"    { 
                loglist="Line no "+to_string(line_num)+": Token <DOUBLE> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return DOUBLE; 
            }
"void"      { 
                loglist="Line no "+to_string(line_num)+": Token <VOID> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return VOID; 
            }
"return"    { 
                loglist="Line no "+to_string(line_num)+": Token <RETURN> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return RETURN; 
            }
"switch"    { 
                loglist="Line no "+to_string(line_num)+": Token <SWITCH> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return SWITCH; 
            }
"case"      { 
                loglist="Line no "+to_string(line_num)+": Token <CASE> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return CASE; 
            }
"default"   { 
                loglist="Line no "+to_string(line_num)+": Token <DEFAULT> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return DEFAULT; 
            }
"continue"  { 
                loglist="Line no "+to_string(line_num)+": Token <CONTINUE> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return CONTINUE; 
            }
"printf"    { 
                loglist="Line no "+to_string(line_num)+": Token <PRINTLN> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return PRINTLN; 
            }
"goto"      { 
                loglist="Line no "+to_string(line_num)+": Token <GOTO> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return GOTO; 
            }

{floats}    { 
                symbol_info *s = new symbol_info((string)yytext,"CONST_FLOAT");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <CONST_FLOAT> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return CONST_FLOAT; 
            }
{integers}  { 
                symbol_info *s = new symbol_info((string)yytext,"CONST_INT");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <CONST_INT> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return CONST_INT; 
            }
{id}        { 
                symbol_info *s = new symbol_info((string)yytext,"ID");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <ID> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return ID; 
            }

"+"|"-"     { 
                symbol_info *s = new symbol_info((string)yytext,"ADDOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <ADDOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return ADDOP; 
            }
"*"|"/"|"%" { 
                symbol_info *s = new symbol_info((string)yytext,"MULOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <MULOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return MULOP; 
            }
"++"        { 
                symbol_info *s = new symbol_info((string)yytext,"INCOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <INCOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return INCOP; 
            }
"--"        { 
                symbol_info *s = new symbol_info((string)yytext,"DECOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <DECOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return DECOP; 
            }
"<"|">"|"=="|"<="|">="|"!=" { 
                symbol_info *s = new symbol_info((string)yytext,"RELOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <RELOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return RELOP; 
            }
"="         { 
                symbol_info *s = new symbol_info((string)yytext,"ASSIGNOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <ASSIGNOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return ASSIGNOP; 
            }
"&&"|"||"   { 
                symbol_info *s = new symbol_info((string)yytext,"LOGICOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <LOGICOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return LOGICOP; 
            }
"!"         { 
                symbol_info *s = new symbol_info((string)yytext,"NOT");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(line_num)+": Token <NOT> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return NOT; 
            }

"("         { 
                loglist="Line no "+to_string(line_num)+": Token <LPAREN> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return LPAREN; 
            }
")"         { 
                loglist="Line no "+to_string(line_num)+": Token <RPAREN> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return RPAREN; 
            }
"{"         { 
                loglist="Line no "+to_string(line_num)+": Token <LCURL> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return LCURL; 
            }
"}"         { 
                loglist="Line no "+to_string(line_num)+": Token <RCURL> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return RCURL; 
            }
"["         { 
                loglist="Line no "+to_string(line_num)+": Token <LTHIRD> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return LTHIRD; 
            }
"]"         { 
                loglist="Line no "+to_string(line_num)+": Token <RTHIRD> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return RTHIRD; 
            }
","         { 
                loglist="Line no "+to_string(line_num)+": Token <COMMA> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return COMMA; 
            }
":"         { 
                loglist="Line no "+to_string(line_num)+": Token <COLON> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return COLON; 
            }
";"         { 
                loglist="Line no "+to_string(line_num)+": Token <SEMICOLON> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return SEMICOLON; 
            }

.           { /* unhandled character */ }

%%
