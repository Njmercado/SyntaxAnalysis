%{
  #include<stdio.h> 
  typedef enum { false, true } bool;

  struct Identifier{
    char name[100];
    int id;
  };

  int identifierCounter = 0;
  struct Identifier ids[100];
%}

DIGIT [0-9]
LETTER [a-zA-Z]

DIGITS {DIGIT}{DIGIT}*
INT (\+|\-)?{DIGITS}
LONGINT {INT}("L"|"l")
DEC {INT}*\.({DIGITS}("e"(\+|\-)?{DIGITS})?)?
IMAGINARY ({INT}|{DEC})("J"|"j")
IDENTIFIER ({LETTER}|"_")({LETTER}|{DIGIT}|"_")*
STRINGS \'[^(\'|\")]*\'|\'[^(\'|\")]*\'

COMMENT \#.*

%%
("range"|"and"|"else"|"if"|"break"|"return"|"def"|"continue"|"elif"|"for"|"import"|"in"|"is"|"not"|"or"|"pass"|"print"|"while"|"True"|"False") {
  for(int i = 0; i < yyleng; i++) {
    printf("%c", yytext[i] - ('a'-'A'));
  }
}

{STRINGS} {printf(" cadena=%s ", yytext);}
{IDENTIFIER} {

  bool exist = false;
  //identifierCounter, porque es el tamaño, usado, del array.
  for(int i = 0; i < identifierCounter; i++){
    if( strcmp(ids[i].name, yytext) == 0 ){
      printf(" id%d=%s ", ids[i].id, yytext); 
      exist = true;
      break;
    } 
  }
  if(!exist) {
    struct Identifier id;
    strcpy(id.name, yytext);
    id.id = identifierCounter;
    ids[identifierCounter] = id;
    printf(" id%d=%s ", identifierCounter++, yytext);
  } 
}

\+ {printf(" op_suma=%s ", yytext);}
\- {printf(" op_resta=%s ", yytext);}
\* {printf(" op_mult=%s ", yytext);}
\*\* {printf(" op_exponente=%s ", yytext);}
\/ {printf(" op_division=%s ", yytext);}
\/\/ {printf(" op_divent=%s ", yytext);}
\<\< {printf(" op_leftshift=%s ", yytext);}
\>\> {printf(" op_rightshift=%s ", yytext);}
\~ {printf(" op_complemento=%s ", yytext);}
\=\= {printf(" op_igual=%s ", yytext);}
\!\=|\<\> {printf(" op_noigual=%s ", yytext);}
\= {printf(" op_assign=%s ", yytext);}
\% {printf(" op_modulo=%s ", yytext);}
\& {printf(" op_y=%s ", yytext);}
\< {printf(" op_menor=%s ", yytext);}
\<\= {printf(" op_menorig=%s ", yytext);}
\>\= {printf(" op_mayorig=%s ", yytext);}
\> {printf(" op_mayor=%s ", yytext);}
\, {printf(" coma=%s ", yytext);}
\( {printf(" parabre=%s ", yytext);}
\) {printf(" parcierra=%s ", yytext);}
\[ {printf(" corabre=%s ", yytext);}
\] {printf(" corcierra=%s ", yytext);}
\{ {printf(" llaveabre=%s ", yytext);}
\} {printf(" llavecierra=%s ", yytext);}
\: {printf(" dospuntos=%s ", yytext);}

{INT} {printf(" entero=%s ", yytext);}
{LONGINT} {printf(" longentero=%s ", yytext);}
{DEC} {printf(" decimal=%s ", yytext);}
{IMAGINARY} {printf(" imaginario=%s ", yytext);}
{COMMENT} {;}
%%

int yywrap(void){}

int main() {

  FILE *fp;

  fp = fopen("index.py", "r");
  yyin = fp;

  yylex();

  printf("\n\n%d identificadores: \n", identifierCounter);
  for(int i = 0; i < identifierCounter; i++) {
    printf("id%d=%s\n", ids[i].id, ids[i].name);
  }

  return 0;
}