%{
  #include<stdio.h> 
  #include<string.h>
  int counter = 1;
%}

%%
" "*(def|import|return|print) {printf(": %d\n", counter); counter++;}
%%

int yywrap(void){}

int main() {

  FILE *fp;

  fp = fopen("index.py", "r");
  yyin = fp;

  yylex();
  return 0;
}