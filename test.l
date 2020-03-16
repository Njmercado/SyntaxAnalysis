%{
  #include<stdio.h> 
  typedef enum { false, true } bool;

  struct Identifier{
    char name[100];
    int id;
  };

  int identifierCounter = 0;
  int errors = 0;
  struct Identifier ids[100];
%}

DIGIT [0-9]
LETTER [a-zA-Z]

DIGITS {DIGIT}{DIGIT}*
INT {DIGITS}
LONGINT {INT}("L"|"l")
DEC {INT}*\.({DIGITS}("e"(\+|\-)?{DIGITS})?)?
IMAGINARY ({INT}|{DEC})("J"|"j")
IDENTIFIER ({LETTER}|"_")({LETTER}|{DIGIT}|"_")*
STRINGS \'[^(\'|\")]*\'|\'[^(\'|\")]*\'
ERROR ([^(" "*|\n|\+|\%|\&|\-|\*|\*\*|\/|\/\/|\<|\<\<|\<=|\>\=|\>\>|\>|\~|\=|\=\=|\!\=|\=|\<\>|\,|\(|\)|\[|\]|\{|\}|\:|{INT}|{LONGINT}|{DEC}|{IMAGINARY}|{IDENTIFIER}|{STRINGS}|{COMMENT})]|{INT}{IDENTIFIER})

COMMENT \#.*

%%
("range"|"and"|"else"|"if"|"break"|"return"|"def"|"continue"|"elif"|"for"|"import"|"in"|"is"|"not"|"or"|"pass"|"print"|"while"|"True"|"False") {
  for(int i = 0; i < yyleng; i++) {
    fprintf(yyout,"%c", yytext[i] - ('a'-'A'));
  }
}

{STRINGS} {fprintf(yyout," cadena=%s ", yytext);}
{IDENTIFIER} {

  bool exist = false;
  //identifierCounter, porque es el tamaño, usado, del array.
  for(int i = 0; i < identifierCounter; i++){
    if( strcmp(ids[i].name, yytext) == 0 ){
      fprintf(yyout," id%d=%s ", ids[i].id, yytext); 
      exist = true;
      break;
    } 
  }
  if(!exist) {
    struct Identifier id;
    strcpy(id.name, yytext);
    id.id = identifierCounter;
    ids[identifierCounter] = id;
    fprintf(yyout," id%d=%s ", identifierCounter++, yytext);
  } 
}

{INT} {fprintf(yyout," entero=%s ", yytext);}
{LONGINT} {fprintf(yyout," longentero=%s ", yytext);}
{DEC} {fprintf(yyout," decimal=%s ", yytext);}
{IMAGINARY} {fprintf(yyout," imaginario=%s ", yytext);}

\+ {fprintf(yyout," op_suma=%s ", yytext);}
\- {fprintf(yyout," op_resta=%s ", yytext);}
\* {fprintf(yyout," op_mult=%s ", yytext);}
\*\* {fprintf(yyout," op_exponente=%s ", yytext);}
\/ {fprintf(yyout," op_division=%s ", yytext);}
\/\/ {fprintf(yyout," op_divent=%s ", yytext);}
\<\< {fprintf(yyout," op_leftshift=%s ", yytext);}
\>\> {fprintf(yyout," op_rightshift=%s ", yytext);}
\~ {fprintf(yyout," op_complemento=%s ", yytext);}
\=\= {fprintf(yyout," op_igual=%s ", yytext);}
\!\=|\<\> {fprintf(yyout," op_noigual=%s ", yytext);}
\= {fprintf(yyout," op_assign=%s ", yytext);}
\% {fprintf(yyout," op_modulo=%s ", yytext);}
\& {fprintf(yyout," op_y=%s ", yytext);}
\< {fprintf(yyout," op_menor=%s ", yytext);}
\<\= {fprintf(yyout," op_menorig=%s ", yytext);}
\>\= {fprintf(yyout," op_mayorig=%s ", yytext);}
\> {fprintf(yyout," op_mayor=%s ", yytext);}
\, {fprintf(yyout," coma=%s ", yytext);}
\( {fprintf(yyout," parabre=%s ", yytext);}
\) {fprintf(yyout," parcierra=%s ", yytext);}
\[ {fprintf(yyout," corabre=%s ", yytext);}
\] {fprintf(yyout," corcierra=%s ", yytext);}
\{ {fprintf(yyout," llaveabre=%s ", yytext);}
\} {fprintf(yyout," llavecierra=%s ", yytext);}
\: {fprintf(yyout," dospuntos=%s ", yytext);}

{COMMENT} {;}

{ERROR} {fprintf(yyout, " ERROR=%s", yytext); errors++;}
%%

int yywrap(void){}

int main() {

  FILE *fr, *fw;

  fr = fopen("index.py", "r");
  fw = fopen("output.txt", "w");
  yyin = fr;
  yyout = fw;

  yylex();

  fprintf(fw, "\n\n%d identificadores: \n", identifierCounter);
  for(int i = 0; i < identifierCounter; i++) {
    fprintf(fw, "id%d=%s\n", ids[i].id, ids[i].name);
  }
  fprintf(fw, "\n %d Errores", errors);

  fclose(fr);
  fclose(fw);

  return 0;
}