%{
/* A Lex program for OCCAM language.
 * Stripped down. LJD 20180531
*/
#include <stdio.h>
#include "y.tab.h"
#define YY_SKIP_YYWRAP
#define yywrap() 1
int lineno = 1;
int indent = 0;
int cntinu = 0; /* next is continuation line if at end */
int wasindent = -1;
int realindent = -1;
int initialindent = -1;
void count();
%}

/* sub-parser state A normal, N nesting change */
%s N
%s A

strippedline            [^\r\n]+
D                       [0-9]
L                       [a-zA-Z]
H                       [A-F0-9]
E                       [Ee][+-]?{D}+
S                       [CcNnTtSs'"*]
%%
<INITIAL>" "*#" "*INCLUDE[^\r\n]* { indent = strspn(yytext, " ");
                                    /*
                                    printf("INDENT %d, LINENO %d ", indent, lineno);
                                    printf(" directive: %s\n", yytext+indent);
                                    */
                                    BEGIN(A); }
<INITIAL>" "*#" "*USE[^\r\n]* { indent = strspn(yytext, " ");
                                    /*
                                    printf("INDENT %d, LINENO %d ", indent, lineno);
                                    printf(" directive: %s\n", yytext+indent);
                                    */
                                    BEGIN(A); }
<INITIAL>" "*#" "*IMPORT[^\r\n]* { indent = strspn(yytext, " ");
                                    /*
                                    printf("INDENT %d, LINENO %d ", indent, lineno);
                                    printf(" directive: %s\n", yytext+indent);
                                    */
                                    BEGIN(A); }
<INITIAL>" "*#" "*COMMENT[^\r\n]* { indent = strspn(yytext, " ");
                                    /*
                                    printf("INDENT %d, LINENO %d ", indent, lineno);
                                    printf(" directive: %s\n", yytext+indent);
                                    */
                                    BEGIN(A); }
<INITIAL>" "*#" "*OPTION[^\r\n]* { indent = strspn(yytext, " ");
                                    /*
                                    printf("INDENT %d, LINENO %d ", indent, lineno);
                                    printf(" directive: %s\n", yytext+indent);
                                    */
                                    BEGIN(A); }
<INITIAL>" "*#" "*PRAGMA[^\r\n]* { indent = strspn(yytext, " ");
                                    /*
                                    printf("INDENT %d, LINENO %d ", indent, lineno);
                                    printf(" directive: %s\n", yytext+indent);
                                    */
                                    BEGIN(A); }
<INITIAL>" "*--[^\r\n]* { indent = strspn(yytext, " ");
                          /*
                          printf("INDENT %d, LINENO %d ", indent, lineno);
                          printf(" full-line-comment: %s\n", yytext+indent);
                          */
                          BEGIN(A); }
<INITIAL>" "*[*]([*]{S}|[^*"\r\n]|[*]#{H}{H})*[*] { cntinu = 1;
                                    indent = strspn(yytext, " ");
                                    /* printf("INDENT %d, LINENO %d ", indent, lineno); */
                                    printf("STRING_LITERAL_MIDDLE\t\t%s\n", yytext+indent);
                                    count(NULL);
                                    BEGIN(A); return STRING_LITERAL_MIDDLE; }
<INITIAL>" "*[*]([*]{S}|[^*"\r\n]|[*]#{H}{H})*["] { cntinu = 0;
                                    indent = strspn(yytext, " ");
                                    /* printf("INDENT %d, LINENO %d ", indent, lineno); */
                                    printf("STRING_LITERAL_END\t\t%s\n", yytext+indent);
                                    count(NULL);
                                    BEGIN(A); return STRING_LITERAL_END; }
<INITIAL>" " { indent++; }
<INITIAL><<EOF>> {
                   if (realindent >= 0) {
                     int delindent = initialindent - realindent;
                     printf("NEWLINE\n");
                     if (delindent&1) {
                       printf("!!!ERROR - ODD DEL INDENTATION %d", delindent);
                       yyterminate();
                     } else {
                       BEGIN(N);
                       return NEWLINE;
                     }
                   } else {
                     yyterminate();
                   }
                 }
<INITIAL>. {
             int delindent = 0;
             int wasnewline = 0;
             if (!cntinu) {
               if (realindent >= 0) {
                 wasindent = realindent;
                 realindent = indent;
                 delindent = realindent - wasindent;
                 printf("NEWLINE\n");
                 wasnewline = 1;
                 if (delindent&1) {
                   printf("!!!ERROR - ODD DEL INDENTATION %d", delindent);
                   yyterminate();
                 } else if (delindent) {
                   BEGIN(N);
                 } else {
                   /*
                   printf("\n");
                   printf("INDENT %d, LINENO %d\n", indent, lineno);
                   */
                 }
               } else {
                 initialindent = indent;
                 realindent = indent;
                 /* printf("INDENT %d, LINENO %d\n", indent, lineno); */
               }
             } else {
               /* printf("INDENT %d, LINENO %d\n", indent, lineno); */
             }
             if (*yytext) unput(*yytext);
             if (!delindent) {
               BEGIN(A);
             }
             if (wasnewline) return NEWLINE;
           }

<N><<EOF>> { if (realindent >= 0) {
               int delindent = initialindent - realindent;
               if (delindent&1) {
                 printf("!!!ERROR - ODD DEL INDENTATION %d", delindent);
                 yyterminate();
               } else if (delindent>0) {
                 printf("RIND\n"); realindent += 2;
                 return RIND;
               } else if (delindent<0) {
                 printf("ROUTD\n"); realindent -= 2;
                 return ROUTD;
               } else {
                 printf("ENDFILE\n");
                 yyterminate();
               }
             } else {
               yyterminate();
             }
           }
<N>. { int delindent = 0;
       int wasrind = 0;
       int wasroutd = 0;
       if (!cntinu) {
         if (realindent >= 0) {
           delindent = realindent - wasindent;
           if (delindent&1) {
             printf("!!!ERROR - ODD DEL INDENTATION %d", delindent);
             yyterminate();
           } else if (delindent>0) {
             printf("RIND\n"); wasindent += 2;
             wasrind = 1;
           } else if (delindent<0) {
             printf("ROUTD\n"); wasindent -= 2;
             wasroutd = 1;
           } else {
             /*
             printf("\n");
             printf("INDENT %d, LINENO %d\n", indent, lineno);
             */
           }
         }
       }
       if (*yytext) unput(*yytext);
       if (!delindent) {
         BEGIN(A);
       }
       if (wasrind) return RIND;
       if (wasroutd) return ROUTD;
     }

<A>--[^\r\n]*                    { count(NULL); }
<A>"AFTER"                  { cntinu = 1; count("");  return AFTER; }
<A>"ALT"                  { cntinu = 0; count("");  return ALT; }
<A>"AND"                  { cntinu = 1; count("");  return AND; }
<A>"ANY"                  { cntinu = 0; count("");  return ANY; }
<A>"AT"                  { cntinu = 0; count("");  return AT; }
<A>"BITAND"                  { cntinu = 1; count("");  return BITAND; }
<A>"BITNOT"                  { cntinu = 1; count("");  return BITNOT; }
<A>"BITOR"                  { cntinu = 1; count("");  return BITOR; }
<A>"BOOL"                  { cntinu = 0; count("");  return BOOL; }
<A>"BYTE"                  { cntinu = 0; count("");  return BYTE; }
<A>"CASE"                  { cntinu = 0; count("");  return CASE; }
<A>"CHAN"                  { cntinu = 0; count("");  return CHAN; }
<A>"ELSE"                  { cntinu = 0; count("");  return ELSE; }
<A>"FALSE"                  { cntinu = 0; count("");  return FALSE; }
<A>"FOR"                  { cntinu = 1; count("");  return FOR; }
<A>"FROM"                  { cntinu = 1; count("");  return FROM; }
<A>"FUNCTION"                  { cntinu = 0; count("");  return FUNCTION; }
<A>"IF"                  { cntinu = 0; count("");  return IF; }
<A>"IS"                  { cntinu = 1; count("");  return IS; }
<A>"INT"                  { cntinu = 0; count("");  return INT; }
<A>"INT16"                  { cntinu = 0; count("");  return INT16; }
<A>"INT32"                  { cntinu = 0; count("");  return INT32; }
<A>"INT64"                  { cntinu = 0; count("");  return INT64; }
<A>"MINUS"                  { cntinu = 1; count("");  return MINUS; }
<A>"MOSTNEG"                  { cntinu = 0; count("");  return MOSTNEG; }
<A>"MOSTPOS"                  { cntinu = 0; count("");  return MOSTPOS; }
<A>"NOT"                  { cntinu = 1; count("");  return NOT; }
<A>"OF"                  { cntinu = 0; count("");  return OF; }
<A>"OR"                  { cntinu = 1; count("");  return OR; }
<A>"PAR"                  { cntinu = 0; count("");  return PAR; }
<A>"PLACE"                  { cntinu = 0; count("");  return PLACE; }
<A>"PLACED"                  { cntinu = 0; count("");  return PLACED; }
<A>"PLUS"                  { cntinu = 1; count("");  return PLUS; }
<A>"PORT"                  { cntinu = 0; count("");  return PORT; }
<A>"PRI"                  { cntinu = 0; count("");  return PRI; }
<A>"PROC"                  { cntinu = 0; count("");  return PROC; }
<A>"PROCESSOR"                  { cntinu = 0; count("");  return PROCESSOR; }
<A>"PROTOCOL"                  { cntinu = 0; count("");  return PROTOCOL; }
<A>"REAL32"                  { cntinu = 0; count("");  return REAL32; }
<A>"REAL64"                  { cntinu = 0; count("");  return REAL64; }
<A>"REM"                  { cntinu = 1; count("");  return REM; }
<A>"RESULT"                  { cntinu = 0; count("");  return RESULT; }
<A>"RETYPES"                  { cntinu = 0; count("");  return RETYPES; }
<A>"ROUND"                  { cntinu = 0; count("");  return ROUND; }
<A>"SEQ"                  { cntinu = 0; count("");  return SEQ; }
<A>"SIZE"                  { cntinu = 1; count("");  return SIZE; }
<A>"SKIP"                  { cntinu = 0; count("");  return SKIP; }
<A>"STOP"                  { cntinu = 0; count("");  return STOP; }
<A>"TIMER"                  { cntinu = 0; count("");  return TIMER; }
<A>"TIMES"                  { cntinu = 1; count("");  return TIMES; }
<A>"TRUE"                  { cntinu = 0; count("");  return TRUE; }
<A>"TRUNC"                  { cntinu = 0; count("");  return TRUNC; }
<A>"VAL"                  { cntinu = 0; count("");  return VAL; }
<A>"VALOF"                  { cntinu = 0; count("");  return VALOF; }
<A>"WHILE"                  { cntinu = 0; count("");  return WHILE; }
<A>{L}({L}|{D}|[.])*           { cntinu = 0; count("IDENTIFIER");
                                 return IDENTIFIER; }
<A>#{H}+          { cntinu = 0; count("HEX_CONSTANT"); return HEX_CONSTANT; }
<A>{D}+               { cntinu = 0; count("INT_CONSTANT");
                        return INT_CONSTANT; }
<A>'([*]{S}|[^*'\r\n]|[*]#{H}{H})'       { cntinu = 0; count("BYTE_CONSTANT");
                                          return BYTE_CONSTANT; }
<A>{D}*"."{D}+({E})?  { cntinu = 0; count("REAL_CONSTANT");
                                          return REAL_CONSTANT; }
<A>{D}+"."{D}*({E})?  { cntinu = 0; count("REAL_CONSTANT");
                                          return REAL_CONSTANT; }
<A>["]([*]{S}|[^*"\r\n]|[*]#{H}{H})*["] { cntinu = 0; count("STRING_LITERAL");
                                          return STRING_LITERAL; }
<A>["]([*]{S}|[^*"\r\n]|[*]#{H}{H})*[*] { cntinu = 1;
                                         count("STRING_LITERAL_START");
                                         return STRING_LITERAL_START; }
<A>":="                    { cntinu = 1; count("ASSIGN");
                             return ASSIGN; }
<A>">>"                    { cntinu = 1; count("RIGHT_OP");
                             return RIGHT_OP; }
<A>"<<"                    { cntinu = 1; count("LEFT_OP");
                             return LEFT_OP; }
<A>"/\\"                    { cntinu = 1; count("AND_OP");
                             return AND_OP; }
<A>"\\/"                    { cntinu = 1; count("OR_OP");
                             return OR_OP; }
<A>"<="                    { cntinu = 1; count("LE_OP");
                             return LE_OP; }
<A>">="                    { cntinu = 1; count("GE_OP");
                             return GE_OP; }
<A>"><"                    { cntinu = 1; count("XOR_OP");
                             return XOR_OP; }
<A>"<>"                    { cntinu = 1; count("NE_OP");
                             return NE_OP; }
<A>"[]"              { cntinu = 0; count("INDEF_SPEC");
                             return INDEF_SPEC; }
<A>"::"                     { cntinu = 0; count("DOUBLE_COLON");
                             return DOUBLE_COLON; }
<A>[=]                    { cntinu = 1; count("\'=\'");  return '='; }
<A>";"                     { cntinu = 1; count("\';\'");  return ';'; }
<A>"["              { cntinu = 0; count("\'[\'");  return '['; }
<A>"]"              { cntinu = 0; count("\']\'");  return ']'; }
<A>","                     { cntinu = 1; count("\',\'");  return ','; }
<A>":"                     { cntinu = 0; count("\':\'");  return ':'; }
<A>"!"                     { cntinu = 0; count("\'!\'");  return '!'; }
<A>"?"                     { cntinu = 0; count("\'?\'");  return '?'; }
<A>"("                     { cntinu = 0; count("\'(\'");  return '('; }
<A>")"                     { cntinu = 0; count("\')\'");  return ')'; }
<A>"."                     { cntinu = 0; count("\'.\'");  return '.'; }
<A>"&"                     { cntinu = 0; count("\'&\'");  return '&'; }
<A>"~"                     { cntinu = 1; count("\'~\'");  return '~'; }
<A>"-"                     { cntinu = 1; count("\'-\'");  return '-'; }
<A>"+"                     { cntinu = 1; count("\'+\'");  return '+'; }
<A>"*"                     { cntinu = 1; count("\'*\'");  return '*'; }
<A>"/"                     { cntinu = 1; count("\'/\'");  return '/'; }
<A>"\\"                     { cntinu = 1; count("\'\\\'");  return '\\'; }
<A>"<"                     { cntinu = 1; count("\'<\'");  return '<'; }
<A>">"                     { cntinu = 1; count("\'>\'");  return '>'; }
<A>"#"                     { cntinu = 0; count("\'#\'");  return '#'; }
<A>[ \t\v\f]             { count(NULL); }
<A>[\r\n]+ {
             lineno++;
             indent = 0;
             /* if (cntinu) printf("CONTINUATION "); */
             BEGIN(INITIAL);
           }
<A>.                         ;
%%
int column = 0;

void count(const char *name)
{
        int i;

        for (i = 0; yytext[i] != '\0'; i++)
                if (yytext[i] == '\n')
                        column = 0;
                else if (yytext[i] == '\t')
                        column += 8 - (column % 8);
                else
                        column++;

        if (name) {
          if (*name) printf("%s\t\t", name);
          ECHO;
          printf("\n");
        }
}
