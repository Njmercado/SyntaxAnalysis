%{
  #include<stdio.h> 
  #include<string.h>
  int identifierCounter = 0;
  int numericIdentifier = 0;
  int varIdentifier = 0;
%}

DIGIT [0-9]
LETTER [a-zA-Z]
STRINGS (\".*\")|(\'.*\')

%%
("continue"|"range"|"and"|"else"|"if"|"break"|"return"|"def"|"continue"|"elif"|"for"|"import"|"in"|"is"|"not"|"or"|"pass"|"print"|"while"|"len") {
  for(int i = 0; i < yyleng; i++) {
    printf("%c", yytext[i] - ('a'-'A'));
  }
}
\+ {printf(" suma=%s ", yytext);}
\- {printf(" resta=%s ", yytext);}
\= {printf(" assign=%s ", yytext);}
\( {printf(" parabre=%s ", yytext);}
\) {printf(" parcierra=%s ", yytext);}
\[ {printf(" corabre=%s ", yytext);}
\] {printf(" corcierra=%s ", yytext);}
\: {printf(" dospuntos=%s ", yytext);}
\* {printf(" mult=%s ", yytext);}
\, {printf(" coma=%s ", yytext);}
\/ {printf(" division=%s ", yytext);}
\% {printf(" modulo=%s ", yytext);}
\& {printf(" and=%s ", yytext);}
\< {printf(" menor=%s ", yytext);}
\<\= {printf(" menor_ig=%s ", yytext);}
\>\= {printf(" mayor_ig=%s ", yytext);}
\> {printf(" mayor=%s ", yytext);}

{STRINGS} {printf(" cadena=%s ", yytext);}
{LETTER}+ {printf(" id%d=%s ", varIdentifier++, yytext);}
{DIGIT}+ {printf(" entero%d=%s ", numericIdentifier++, yytext);}
%%

int yywrap(void){}

int main() {

  FILE *fp;

  fp = fopen("index.py", "r");
  yyin = fp;

  yylex();
  return 0;
}