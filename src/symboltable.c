#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include<math.h>
#include"header.h"

#define TABLE_SIZE	256

symtab * hash_table[TABLE_SIZE];
extern int linenumber;

int symbol_size = 0;

int HASH(char * str){
	int idx=0;
	while(*str){
		idx = idx << 1;
		idx+=*str;
		str++;
	}	
	return (idx & (TABLE_SIZE-1));
}

/*returns the symbol table entry if found else NULL*/

symtab * lookup(char *name){
	int hash_key;
	symtab* symptr;
	if(!name)
		return NULL;
	hash_key=HASH(name);
	symptr=hash_table[hash_key];

	while(symptr){
		if(!(strcmp(name,symptr->lexeme)))
			return symptr;
		symptr=symptr->front;
	}
	return NULL;
}


void insertID(char *name){
	int hash_key;
	symtab* ptr;
	symtab* symptr=(symtab*)malloc(sizeof(symtab));	
	
	hash_key=HASH(name);
	ptr=hash_table[hash_key];
	
	if(ptr==NULL){
		/*first entry for this hash_key*/
		hash_table[hash_key]=symptr;
		symptr->front=NULL;
		symptr->back=symptr;
	}
	else{
		symptr->front=ptr;
		ptr->back=symptr;
		symptr->back=symptr;
		hash_table[hash_key]=symptr;	
	}
	
	strcpy(symptr->lexeme,name);
	symptr->line=linenumber;
	symptr->counter=1;
	
	//symbol_size用於判斷表中有多少個id
	symbol_size += 1;
}

void printSym(symtab* ptr) 
{

	printf("%-15s %d\n", ptr->lexeme, ptr->counter);
}

typedef struct {
	symtab* front;
	symtab* back;	
} Node;

int compr(const void* p1, const void* p2)
{
	char* str1 = (*(symtab**)p1)->lexeme;
	char* str2 = (*(symtab**)p2)->lexeme;
	return strcmp(str1,str2);
}

void printSymTab()
{
    int i;

	//準備一個存放指向的symtable各項id的陣列
	symtab** sym_ptr_ary = (symtab**)malloc(symbol_size * sizeof(symtab*)); 
	int ary_top = 0;
	
	for(i=0; i<TABLE_SIZE; i++)
	{
		symtab* symptr;
		symptr = hash_table[i];
		while(symptr != NULL)
		{
			//把指標存到陣列裡
			sym_ptr_ary[ary_top] = symptr;
			ary_top++;
			//get next symbol
			symptr = symptr->front;
		}
	}

	//parameter list: 
	//    base,        number,      size,            
	qsort(sym_ptr_ary, symbol_size, sizeof(symtab*), compr);
	printf("Frequency of identifiers:\n");
	for(i=0; i<symbol_size; i++)
	{
		printSym(sym_ptr_ary[i]);
	}
}
