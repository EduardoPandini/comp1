%{
#include <string.h>    
#include <math.h>
unsigned int linha=1;
unsigned int coluna=1;
int comentarioAUX=0;
%}


DIGITO [0-9]
ID [A-Za-z][A-Za-z0-9_]*
TEXTO [A-Za-z0-9][A-Za-z0-9]*

%%


";" {
     if(comentarioAUX == 0){
        printf("Ponto e virgula: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),linha,coluna );
    }
    coluna += strlen(yytext);
} 
bool|int|float|char|double {
     if(comentarioAUX == 0){
        printf("Tipo simples: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}
{DIGITO}+ {
    if(comentarioAUX == 0){
        printf("Inteiro: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}
"FALSE"|"TRUE" {
    if(comentarioAUX == 0){
        printf("valor booleano: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}
return|print|read {
    if(comentarioAUX == 0){
        printf("palavra reservada: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),linha,coluna );
    }
    coluna += strlen(yytext);
}
while|for {
     if(comentarioAUX == 0){
        printf("laco de repeticao: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

if|else {
     if(comentarioAUX == 0){
        printf("operador logico: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}
{ID}+ {
    if(comentarioAUX == 0){
        printf("identificador: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

{DIGITO}+"."{DIGITO}* {
    if(comentarioAUX == 0){
        printf( "Real: ,%s, ,%zu, (%g) localizado em ( %d : %d )\n", yytext,strlen(yytext),atof( yytext ),linha,coluna );
    }
    coluna += strlen(yytext);
}

"+"|"-"|or {
     if(comentarioAUX == 0){
        printf("operação de adição ou or: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

"*"|"/"|and {
    if(comentarioAUX == 0){
        printf("operação de multiplicação ou and: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

"("|")" {
    if(comentarioAUX == 0){
        printf("parenteses: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

"["|"]" {
    if(comentarioAUX == 0){
        printf("colchetes: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

"{"|"}" { 
    if(comentarioAUX == 0){
        printf("chaves: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

"!"|"@"|"#"|"$"|"%"|"&"|":" { 
    if(comentarioAUX == 0){
        printf("outro tipo: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}
"<"|">"|"<="|">="|"<>"|"==" {
    if(comentarioAUX == 0){
        printf("comparador: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}



"=" {
    if(comentarioAUX == 0){
        printf("definicao de valor: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}



"//"({TEXTO}|.)* {
    if(comentarioAUX == 0){
        printf("Comentario de uma linha: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),linha,coluna );
    }
    coluna += strlen(yytext);
}

"/*" {
    comentarioAUX=1;
    coluna += strlen(yytext);
}
"*/" {
    comentarioAUX=0;
    coluna += strlen(yytext);
}

"\""({TEXTO}|.)*"\"" {
    if(comentarioAUX == 0){
        printf("String: ,%s, ,%zu, encontrado em ( %d : %d )\n", yytext,strlen(yytext),linha,coluna );
    }
    coluna += strlen(yytext);
}




" " {
     
    coluna ++;
} 

[\n]+ {
     if(comentarioAUX == 0){
		printf("quebra de linha\n");
	}
	linha++;
	coluna = 1;
} 

"."|"," { 
    if(comentarioAUX == 0){
        printf("divisor: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    }
    coluna += strlen(yytext);
}

%%

int main( argc, argv )
int argc;
char **argv;
{
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

	yylex();
    
	return 0;
}