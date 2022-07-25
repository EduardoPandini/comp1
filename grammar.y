%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

/*tokens*/

%token PONTO_V
%token COMENTARIO_T
%token INTEIRO REAL
%token PALAVRA_R
%token LACO_WHILE LACO_FOR
%token IDENTIFICADOR
%token OPERACAO_AD OPERACAO_SUB OPERACAO_MULT OPERACAO_DIV OPERACAO_AND
%token ABRE_PAR FECHA_PAR
%token ABRE_COL FECHA_COL
%token ABRE_CHAVE FECHA_CHAVE
%token OUTRO_T
%token OPERADOR_LOGICO
%token DEFINI_VALOR
%token ABRE_COM
%token FECHA_COM
%token T_PRIMITIVO
%token INCLUDE
%token T_STRING
%token T_NEWLINE
%token T_SWITCH
%token T_ARROW_RIGHT
%token OP_ELSE
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%type<fval> mixed_expr

%start start_

%%

start_:	start_2;

start_2: statement start_2
	| ;

statement: T_NEWLINE
	| logico_if
	| when
	| declaracao PONTO_V
	| comentario
	| condicao
	| chamada_funcao
	| incremento PONTO_V
	| loop_while
	| loop_for
	| loop_do
	;

function_block: ABRE_CHAVE function_statements FECHA_CHAVE | statement;
function_statements: statement function_statements | ;





chamada_funcao: funcao_scope ABRE_PAR funcao_args FECHA_PAR PONTO_V {printf("\033[0;34mSintático chamada de funcao\033[0m\n");};
funcao_scope: PALAVRA_R | PALAVRA_R;
funcao_args: | T_STRING | PALAVRA_R ;






when: T_SWITCH ABRE_PAR PALAVRA_R FECHA_PAR ABRE_CHAVE switch_statement FECHA_CHAVE {printf("\033[0;34mSintático When\033[0m\n");};

switch_statement: T_NEWLINE switch_statement
	| PALAVRA_R T_ARROW_RIGHT function_block switch_statement
	| mixed_expr T_ARROW_RIGHT function_block switch_statement
	| OP_ELSE T_ARROW_RIGHT function_block switch_statement
	| ;





loop_while: LACO_WHILE ABRE_PAR loop_while_cond FECHA_PAR function_block { printf("\033[0;34mSintático LOOP\033[0m\n");};

loop_while_cond: condicao loop_while_cond | ;





loop_for: LACO_FOR ABRE_PAR loop_for_cond FECHA_PAR function_block { printf("\033[0;34mSintático LOOP\033[0m\n");};

loop_for_cond: loop_for_dec PONTO_V loop_for_condicao PONTO_V loop_for_inc;
loop_for_dec: declaracao | ;
loop_for_condicao: condicao;
loop_for_inc: incremento | ;




loop_do: OPERADOR_DO function_block LACO_WHILE ABRE_PAR loop_while_cond FECHA_PAR PONTO_V;



condicao: 
    condicao_3 condicao_2;

condicao_2: |
	OPERADOR_LOGICO condicao_3 condicao_2 { printf("\033[0;34mSintático condicional and/or \033[0m\n");}
;

condicao_3: 
    mixed_expr OPERADOR_LOGICO mixed_expr { printf("\033[0;34mSintático condicional 1\033[0m\n");}
  | PALAVRA_R OPERADOR_LOGICO mixed_expr { printf("\033[0;34mSintático condicional 2\033[0m\n");}
  | mixed_expr OPERADOR_LOGICO PALAVRA_R { printf("\033[0;34mSintático condicional 3\033[0m\n");}
  | PALAVRA_R OPERADOR_LOGICO PALAVRA_R { printf("\033[0;34mSintático condicional 4\033[0m\n");}
  | ABRE_PAR condicao FECHA_PAR { printf("\033[0;34mSintático condicional 5\033[0m\n");};






logico_if: cond_2 { printf("\033[0;34mSintático logico_if sem else\033[0m\n");}
	| OP_ELSE function_block { printf("\033[0;34mSintático logico_if com else\033[0m\n");}
	;

cond_2: OP_LOGICO ABRE_PAR condicao FECHA_PAR function_block;







declaracao: 
	  PALAVRA_R T_ASSIGN mixed_expr { printf("\033[0;34mSintático atribuição sem primitivo\033[0m\n");}
	| PALAVRA_R T_ASSIGN condicao { printf("\033[0;34mSintático atribuição sem primitivo\033[0m\n");}
	| T_CONST T_PRIMITIVO PALAVRA_R T_ASSIGN mixed_expr { printf("\033[0;34mSintático atribuição com o const\033[0m\n");}
	| T_CONST T_PRIMITIVO PALAVRA_R T_ASSIGN condicao { printf("\033[0;34mSintático atribuição com o const\033[0m\n");}
	| T_PRIMITIVO PALAVRA_R T_ASSIGN condicao { printf("\033[0;34mSintático atribuição\033[0m\n");}
	| T_PRIMITIVO PALAVRA_R T_ASSIGN mixed_expr { printf("\033[0;34mSintático atribuição\033[0m\n");};



incremento: PALAVRA_R T_INCREMENT {printf("\033[0;34mIncremento\033[0m\n");};





comentario: T_SLC {printf("\033[0;34mSintatico Comentário unica linha\033[0m\n");}
	| ABRE_COM comm_ml FECHA_COM {printf("\033[0;34mSintatico Comentário multi-linhas\033[0m\n");};

comm_ml: T_COMMENT_C comm_ml | T_NEWLINE comm_ml | ;

mixed_expr: REAL							{ $$ = $1; }
	| INTEIRO								{ $$ = $1;}
	| mixed_expr OPERACAO_AD mixed_expr		{ $$ = $1 + $3; }
	| mixed_expr OPERACAO_SUB mixed_expr		{ $$ = $1 - $3; }
	| mixed_expr OPERACAO_MULT mixed_expr	{ $$ = $1 * $3; }
	| mixed_expr OPERACAO_DIV mixed_expr		{ $$ = $1 / $3; }
	| T_LEFT mixed_expr T_RIGHT			{ $$ = $2; }
	;



%%

/*

| expr T_PLUS mixed_expr				{ $$ = $1 + $3; }
	| expr T_MINUS mixed_expr				{ $$ = $1 - $3; }
	| expr T_MULTIPLY mixed_expr			{ $$ = $1 * $3; }
	| expr T_DIVIDE mixed_expr				{ $$ = $1 / $3; }
	| mixed_expr T_PLUS expr				{ $$ = $1 + $3; }
	| mixed_expr T_MINUS expr				{ $$ = $1 - $3; }
	| mixed_expr T_MULTIPLY expr			{ $$ = $1 * $3; }
	| mixed_expr T_DIVIDE expr				{ $$ = $1 / $3; }
	| expr T_DIVIDE expr						{ $$ = $1 / (float)$3; }


comentario: T_SLC T_NEWLINE {printf("Sintatico Comentário unica linha\n");}
	| ABRE_COM comm_ml FECHA_COM {printf("Sintatico Comentário multi-linhas\n");};

comm_ml: INTEIRO comm_ml | REAL comm_ml | T_PLUS comm_ml | T_MINUS comm_ml | T_MULTIPLY comm_ml | T_DIVIDE comm_ml | T_LEFT comm_ml | T_RIGHT comm_ml | T_NEWLINE comm_ml | T_QUIT comm_ml | T_SWITCH comm_ml | ABRE_CHAVE comm_ml | ABRE_PAR comm_ml | FECHA_CHAVE comm_ml | FECHA_PAR comm_ml | T_ASSIGN comm_ml | OP_LOGICO comm_ml | PALAVRA_R comm_ml | PALAVRA_R comm_ml | T_RETURN comm_ml | OPERADOR_LOGICO comm_ml | T_PRIMITIVO comm_ml | T_DEFINE comm_ml | T_SLC comm_ml | T_STRING comm_ml | T_INCLUDE comm_ml | T_LIBRARY comm_ml | T_LEFT_POINTER comm_ml | T_RIGHT_POINTER comm_ml | OPERACAO_AD comm_ml | OPERACAO_SUB comm_ml | OPERACAO_MULT comm_ml | OPERACAO_DIV comm_ml | T_LOOP comm_ml | OP_ELSE comm_ml | T_EMPTY comm_ml | T_TAB comm_ml | T_CARRIER comm_ml | T_UNKNOWN comm_ml | PONTO_V comm_ml | T_PLUS comm_ml | T_MINUS comm_ml | T_MULTIPLY comm_ml | T_DIVIDE | ;

expr: INTEIRO									{ $$ = $1; }
	| expr T_PLUS expr						{ $$ = $1 + $3; }
	| expr T_MINUS expr						{ $$ = $1 - $3; }
	| expr T_MULTIPLY expr					{ $$ = $1 * $3; }
	| T_LEFT expr T_RIGHT					{ $$ = $2; }
	;

funcao: PALAVRA_R ABRE_PAR FECHA_PAR function_block;

block: FECHA_CHAVE PALAVRA_R ABRE_CHAVE;

function_block: FECHA_CHAVE PALAVRA_R T_RETURN PALAVRA_R ABRE_CHAVE;

line: T_NEWLINE
	| mixed_expr T_NEWLINE					{ printf("\tResultado: %f\n", $1);}
	| expr T_NEWLINE							{ printf("\tResultado: %i\n", $1); }
	| T_QUIT T_NEWLINE						{ printf("Até mais...\n"); exit(0); }
	;

*/

int main( argc, argv )
int argc;
char **argv;
{
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Erro de análise (sintática): -- %s --\n", s);
	exit(1);
}

