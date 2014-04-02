%option noyywrap 
%{
#include <stdio.h>
#include "header.h" 
int linenumber;
symtab * lookup();
symtab * ptr;
void     insertID();
void 	 printSymTab();
/* You need to define for all tokens in C--, here are some examples */
#define INT		10
#define FLOAT 		11 
#define OP_ASSIGN 	12 
#define OP_OR 		13 
#define MK_LPAREN 	14 
#define MK_RPAREN 	15 
#define ERROR 		100 

%}

letter   [A-Za-z]
digit    [0-9]
ID	 {letter}({letter}|{digit}|"_")*
WS	 [ \t]+
Int_constant {digit}+

/* You need to define the following RE's 
Float_constant
String_constant
comment
test
*/
	
Float_constant  ({digit}+)(e(\+|-)?{digit}+)|({digit}+(\.{digit}+)(e(\+|-)?{digit}+)?)|({digit}+)?(\.{digit}+)(e(\+|-)?{digit}+)? 
String_constant	\"(\\.|[^"])*\" 
comment	"/*"([^*]|\*+[^*/])*\*+"/"

/* Arithemetic operators */
OP_plus			"+"
OP_minus		"-"
OP_mul			"*"
OP_div			"/"

/* Assignment operator */
OP_assign       "="

/* Logical operators */
OP_or			"||"
OP_and			"&&"
OP_not			"!"

/* Relational operators */
OP_larger		">"
OP_less			"<"
OP_largerE		">="
OP_lessE		"<="
OP_notE			"!="
OP_equal		"=="

/* Other operators appear here */ 


newline  "\n"

DL_lbracket "["
DL_rbracket "]"
DL_lparen "("
DL_rparen ")"
DL_lbrace "{"
DL_rbrace "}"
DL_comma  ","
DL_semicol ";"
DL_dot  "."

/* Other separators appear here */

error    .

%%

{letter}  
{digit}    
{String_constant}

{Float_constant}	{}
{comment}	printf("%s\n", yytext);
{WS}           		{}
{Int_constant}		{}
{ID}            	{ 
			ptr = lookup(yytext);
			if (ptr == NULL)
			     insertID(yytext);	
			else 
			     ptr->counter++;
		}
{OP_plus}			
{OP_minus}		
{OP_mul}			
{OP_div}			
{OP_assign}       
{OP_or}			
{OP_and}			

{OP_larger}		
{OP_less}			
{OP_largerE}		
{OP_lessE}		
{OP_notE}			
{OP_equal}		

{DL_lbracket}
{DL_rbracket}
{DL_lparen}
{DL_rparen}
{DL_lbrace}
{DL_rbrace}
{DL_comma}
{DL_semicol}
{DL_dot}

{newline}       linenumber += 1;
{error}         printf("ERR \n");/* return ERROR; */


%%

main(int argc, char **argv)
{
 argc--; ++argv;
   if (argc > 0)
      yyin = fopen(argv[0], "r");
   else
      yyin = stdin;
   yylex();

   printSymTab();
}

