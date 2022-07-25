%{
#include <string.h>    
#include <math.h>
unsigned int linha=1;
unsigned int coluna=1;
int comentarioAUX=0;
#include "grammar.tab.h"

void parse_print(const char* title,const char* yytext){
    printf( "%s: ,%s, ,%zu, (%d) encontrado em ( %d : %d )\n",title, yytext,strlen(yytext),atoi( yytext ),linha,coluna );
}
%}


DIGITO [0-9]
ID [A-Za-z][A-Za-z0-9_]*
TEXTO [A-Za-z0-9][A-Za-z0-9]*

%%

"#include" {
    if(comentarioAUX == 0){
        parse_print("Incluindo algo ",yytext);
        return INCLUDE;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"#define" {
    if(comentarioAUX == 0){
        parse_print("Definição",yytext);
        return T_DEFINE;
    }else{
        return COMENTARIO_T;
    }
}

void|char|short|int|long|float|double|signed|unsigned {
    if(comentarioAUX == 0){
        parse_print("Tipo primitivo ",yytext);
        return T_PRIMITIVO;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

";" {
     if(comentarioAUX == 0){
        parse_print("Ponto e virgula: ",yytext);
        return PONTO_V;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
} 

{DIGITO}+ {
    if(comentarioAUX == 0){
        parse_print("Inteiro: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return INTEIRO;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

return {
    if(comentarioAUX == 0){
        parse_print("palavra reservada RETURN: ",yytext);
        return PALAVRA_RETURN;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
print|read {
    if(comentarioAUX == 0){
        parse_print("palavra reservada: ",yytext);
        return PALAVRA_R;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
while {
     if(comentarioAUX == 0){
        parse_print("laco WHILE: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return LACO_WHILE;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
for {
     if(comentarioAUX == 0){
        parse_print("laco FOR: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return LACO_FOR;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

when {
    if(comentarioAUX == 0){
    parse_print("Seletor when: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return T_SWITCH;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

if {
     if(comentarioAUX == 0){
        parse_print("operador logico: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OP_LOGICO;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

else {
     if(comentarioAUX == 0){
        parse_print("condicional else: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OP_ELSE;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
do {
    if(comentarioAUX == 0){
        parse_print("Laço: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OPERADOR_DO;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

const {
    if(comentarioAUX == 0){
        parse_print("Constante: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    return T_CONST;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

{ID}+ {
    if(comentarioAUX == 0){
        parse_print("identificador: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return IDENTIFICADOR;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

{DIGITO}+"."{DIGITO}* {
    if(comentarioAUX == 0){
        parse_print( "Real: ,%s, ,%zu, (%g) localizado em ( %d : %d )\n", yytext,strlen(yytext),atof( yytext ),linha,coluna );
        return REAL;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
"->" {
    if(comentarioAUX == 0){
    parse_print("Ponteiro de seta: ,%s, ,%zu, (%g) localizado em ( %d : %d )\n", yytext,strlen(yytext),atof( yytext ),linha,coluna );
      return REAL;
    }else{
        return T_ARROW_RIGHT;
    }
    coluna += strlen(yytext);
}

"++"|"--" {
    if(comentarioAUX == 0){
        parse_print("Incremento: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    return T_INCREMENT;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"+" {
     if(comentarioAUX == 0){
        parse_print("operação de adição: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OPERACAO_AD;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"-" {
     if(comentarioAUX == 0){
        parse_print("operação de subtracao: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OPERACAO_SUB;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"*" {
    if(comentarioAUX == 0){
        parse_print("operação de multiplicação: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OPERACAO_MULT;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"/" {
    if(comentarioAUX == 0){
        parse_print("operação de divisao: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OPERACAO_DIV;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}


"(" {
    if(comentarioAUX == 0){
        parse_print("ABERTURA DE parenteses: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return ABRE_PAR;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

")" {
    if(comentarioAUX == 0){
        parse_print("parenteses: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return FECHA_PAR;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
"[" {
    if(comentarioAUX == 0){
        parse_print("abre colchetes: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return ABRE_COL;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"]" {
    if(comentarioAUX == 0){
        parse_print("fecha colchetes: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return FECHA_COL;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
"{" { 
    if(comentarioAUX == 0){
        parse_print("abre chaves: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return ABRE_CHAVE;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"}" { 
    if(comentarioAUX == 0){
        parse_print("fecha chaves: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return FECHA_CHAVE;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"!"|"@"|"#"|"$"|"%"|"&"|":" { 
    if(comentarioAUX == 0){
        parse_print("outro tipo: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return OUTRO_T;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
"=="|"!="|"!=="|"<="|">="|"<"|">"|"and"|"or" {
    if(comentarioAUX == 0){
        parse_print("Um operador lógico: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return COMPARADOR_LOGICO;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|=" {
    if(comentarioAUX == 0){
    parse_print("Atribuição: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
    return T_ASSIGN;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}
"//"({TEXTO}|.)* {
    if(comentarioAUX == 0){
        parse_print("Comentario de uma linha: ",yytext);
        return COMENTARIO_U;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

"/*" {
    if(comentarioAUX == 0){
        comentarioAUX=1;
        coluna += strlen(yytext);
        return ABRE_COM;
    }else{
        return COMENTARIO_T;
    }
}
"*/" {
    comentarioAUX=0;
    coluna += strlen(yytext);
    return FECHA_COM;
}

"\""({TEXTO}|.)*"\"" {
    if(comentarioAUX == 0){
        parse_print("String: ",yytext);
            return T_STRING;
    }else{
        return COMENTARIO_T;
    }
    coluna += strlen(yytext);
}

" " {
     
    coluna ++;
} 

[\n]+ {
	parse_print("quebra de linha\n");
	linha++;
	coluna = 1;
    return T_NEWLINE;
} 

"."|"," { 
    if(comentarioAUX == 0){
        parse_print("divisor: %s localizado em ( %d : %d )\n", yytext,linha,coluna );
        return DIVISOR_P;
    }else{
        return COMENTARIO_T;
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
