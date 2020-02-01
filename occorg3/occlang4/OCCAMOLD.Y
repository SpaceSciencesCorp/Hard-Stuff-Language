%token '!' '&' '(' ')' '*' '+' ',' '-' '/'
%token ':' ';' '<' '=' '>' '?' '[' '\\' ']' '~'
%token AFTER ALT AND AND_OP ANY ASSIGN AT BITAND
%token BITNOT BITOR BOOL BYTE BYTE_CONSTANT CASE
%token CHAN DOUBLE_COLON ELSE FALSE FOR FROM FUNCTION
%token GE_OP HEX_CONSTANT IDENTIFIER IF INDEF_SPEC INT
%token INT16 INT32 INT64 INT_CONSTANT IS LEFT_OP LE_OP
%token MINUS MOSTNEG MOSTPOS NEWLINE NE_OP NOT OF OR
%token OR_OP PAR PLACE PLACED PLUS PORT PRI PROC
%token PROCESSOR PROTOCOL REAL32 REAL64 REAL_CONSTANT
%token REM RESULT RETYPES RIGHT_OP RIND ROUND ROUTD
%token SEQ SIZE SKIP STOP STRING_LITERAL STRING_LITERAL_END
%token STRING_LITERAL_MIDDLE STRING_LITERAL_START TIMER
%token TIMES TRUE TRUNC VAL VALOF WHILE XOR_OP
%%
program : process
| block_definition_list
;
block_definition_list : block_definition
| block_definition_list
  block_definition
;
alternation : ALT NEWLINE
                RIND alternative_vlist ROUTD
| ALT NEWLINE
| ALT replicator NEWLINE
    RIND alternative ROUTD
| PRI ALT NEWLINE
    RIND alternative_vlist ROUTD
| PRI ALT NEWLINE
| PRI ALT replicator NEWLINE
    RIND alternative ROUTD
;
alternative : guarded_alternative
| alternation
| specification
  alternative
| channel '?' CASE NEWLINE
    RIND variant_vlist ROUTD
| channel '?' CASE NEWLINE
| boolean '&' channel '?' CASE NEWLINE
    RIND variant_vlist ROUTD
| boolean '&' channel '?' CASE NEWLINE
;
alternative_vlist : alternative
| alternative_vlist
  alternative
;
block_definition : PROC name '(' formal_olist ')' NEWLINE
                     RIND procedure_body ROUTD
                   ':' NEWLINE
| data_type_clist FUNCTION name '(' formal_olist ')' NEWLINE
    RIND function_body ROUTD
  ':' NEWLINE
;
case_input : channel '?' CASE NEWLINE
               RIND variant_vlist ROUTD
| channel '?' CASE NEWLINE
;
choice : guarded_choice
| conditional
| specification
  choice
;
choice_vlist : choice
| choice_vlist
  choice
;
conditional : IF NEWLINE
                RIND choice_vlist ROUTD
| IF NEWLINE
| IF replicator NEWLINE
    RIND choice ROUTD
;
construction : sequence | conditional | selection | loop
| parallel | alternation
;
definition : PROTOCOL name IS simple_protocol ':' NEWLINE
| PROTOCOL name IS sequential_protocol ':' NEWLINE
| PROTOCOL name NEWLINE
    RIND CASE NEWLINE
      RIND tagged_protocol_vlist ROUTD ROUTD
  ':' NEWLINE
| PROTOCOL name NEWLINE
    RIND CASE NEWLINE ROUTD
  ':' NEWLINE
| ANY FUNCTION name '(' ')' NEWLINE
    RIND function_body ROUTD
  ':' NEWLINE
| data_type_clist FUNCTION name '(' formal_olist ')' IS expression_list ':' NEWLINE
| specifier name RETYPES element ':' NEWLINE
| VAL specifier name RETYPES expression ':' NEWLINE
| block_definition
;
function_body : value_process
;
guarded_alternative : guard
                        RIND process ROUTD
;
guarded_choice : boolean NEWLINE
                   RIND process ROUTD
;
loop : WHILE boolean NEWLINE
         RIND process ROUTD
;
option : case_expression_clist NEWLINE
           RIND process ROUTD
| ELSE NEWLINE
    RIND process ROUTD
| specification
  option
;
option_vlist : option
| option_vlist
  option
;
parallel : PAR NEWLINE
             RIND process_vlist ROUTD
| PAR NEWLINE
| PAR replicator NEWLINE
    RIND process ROUTD
| PRI PAR NEWLINE
    RIND process_vlist ROUTD
| PRI PAR NEWLINE
| PRI PAR replicator NEWLINE
    RIND process ROUTD
| placedpar
;
placedpar : PLACED PAR NEWLINE
              RIND placedpar_vlist ROUTD
| PLACED PAR NEWLINE
| PLACED PAR replicator NEWLINE
    RIND placedpar ROUTD
| PROCESSOR expression NEWLINE
    RIND process ROUTD
;
placedpar_vlist : placedpar
| placedpar_vlist
  placedpar
;
procedure_body : process
;
process : SKIP NEWLINE
| STOP NEWLINE
| action | construction | instance | case_input
| specification
  process
| allocation
  process
;
process_vlist : process
| process_vlist
  process
;
selection : CASE selector NEWLINE
              RIND option_vlist ROUTD
| CASE selector NEWLINE
;
sequence : SEQ NEWLINE
             RIND process_vlist ROUTD
| SEQ NEWLINE
| SEQ replicator NEWLINE
    RIND process ROUTD
;
specification : declaration | abbreviation | definition
;
valof : VALOF NEWLINE
          RIND process
          RESULT expression_list NEWLINE ROUTD
| specification
  valof
;
value_process : valof
;
variant : tagged_list NEWLINE
            RIND process ROUTD
| specification
  variant
;
variant_vlist : variant
| variant_vlist
  variant
;
abbreviation : specifier name IS element ':' NEWLINE
| name IS element ':' NEWLINE
| VAL specifier name IS expression ':' NEWLINE
| VAL name IS expression ':' NEWLINE
;
action : assignment NEWLINE
| input NEWLINE
| output NEWLINE
;
allocation : PLACE name AT expression ':' NEWLINE
;
declaration : type name_clist ':' NEWLINE
;
guard : input NEWLINE
| boolean '&' input NEWLINE
| boolean '&' SKIP NEWLINE
;
instance : name '(' actual_olist ')' NEWLINE
;
tagged_protocol : tag | tag ';' sequential_protocol NEWLINE
;
tagged_protocol_vlist : tagged_protocol
| tagged_protocol_vlist
  tagged_protocol
;
actual : element | expression
;
actual_clist : actual | actual_clist ',' actual
;
actual_olist :  | actual_clist
;
assignment : variable ASSIGN expression
| variable_list ASSIGN expression_list
;
base : expression
;
boolean :  expression
;
case_expression : expression
;
case_expression_clist : case_expression | case_expression_clist ',' case_expression
;
channel : element
;
delayed_input : timer '?' AFTER expression
;
expression_list : name '(' expression_olist ')'
| expression_clist
;
formal : specifier name_clist | VAL specifier name_clist
;
formal_clist : formal | formal_clist ',' formal
;
formal_olist :  | formal_clist
;
input : channel '?' variable
| channel '?' input_item
| channel '?' input_item_slist
| channel '?' CASE tagged_list
| timer_input
| delayed_input
| port '?' variable
;
input_item : variable | variable DOUBLE_COLON variable
;
input_item_slist : input_item | input_item_slist ';' input_item
;
output : channel '!' expression
| channel '!' output_item
| channel '!' output_item_slist
| channel '!' tag
| channel '!' tag ';' output_item_slist
| port '!' expression
;
output_item : expression | expression DOUBLE_COLON expression
;
output_item_slist : output_item | output_item_slist ';' output_item
;
port : element
;
replicator :  name '=' base FOR count
;
selector : expression
;
sequential_protocol : simple_protocol_slist
;
simple_protocol_slist : simple_protocol | simple_protocol_slist ';' simple_protocol
;
specifier : primitive_type
| INDEF_SPEC specifier
| '[' expression ']' specifier
;
tagged_list : tag | tag ';' input_item_slist
;
timer : element
;
timer_input : timer '?' variable
;
variable : element
;
variable_clist : variable | variable_clist ',' variable
;
variable_list : variable_clist
;
andor_expression : andor_expression andor_operator operand
| operand andor_operator operand
;
array_type : '[' expression ']' type
;
comms_type : CHAN OF protocol
| TIMER
| PORT OF type
;
conversion : primitive_type operand
| primitive_type ROUND operand
| primitive_type TRUNC operand
;
count : expression
;
element : element '[' subscript ']'
| '[' element FROM subscript FOR subscript ']'
| name
;
expression : monadic_operator operand
| operand dyadic_operator operand
| andor_expression
| conversion
| operand
| MOSTPOS data_type
| MOSTNEG data_type
;
expression_clist : expression | expression_clist ',' expression
;
expression_olist :  | expression_clist
;
operand : element | literal | table | '(' expression ')'
| name '(' expression_olist ')'
;
primitive_type : comms_type
| data_type
;
protocol : name | simple_protocol | ANY
;
simple_protocol : type | counting_type DOUBLE_COLON INDEF_SPEC type
;
subscript :  expression
;
table : table '[' subscript ']'
| '[' expression_clist ']'
| '[' table FROM subscript FOR count ']'
;
type : primitive_type | array_type
;
andor_operator : AND | OR
;
byte : BYTE_CONSTANT
;
counting_type : BYTE
| INT
| INT16
| INT32
| INT64
;
data_type : counting_type
| BOOL
| REAL32
| REAL64
;
data_type_clist : data_type | data_type_clist ',' data_type
;
dyadic_operator : AFTER | BITAND | BITOR | MINUS | PLUS | REM
| TIMES | RIGHT_OP | LEFT_OP | AND_OP | OR_OP | LE_OP | GE_OP
| XOR_OP | NE_OP | '-' | '+' | '*' | '/' | '\\' | '<' | '>'
;
integer : INT_CONSTANT | HEX_CONSTANT
;
literal : integer
| byte
| integer '(' data_type ')'
| byte '(' data_type ')'
| real '(' data_type ')'
| string
| TRUE | FALSE
;
monadic_operator : BITNOT | MINUS | NOT | SIZE | '~' | '-'
;
name : IDENTIFIER
;
name_clist : name | name_clist ',' name
;
real : REAL_CONSTANT
;
string : STRING_LITERAL | string_head STRING_LITERAL_END
;
string_head : STRING_LITERAL_START | string_head STRING_LITERAL_MIDDLE
;
tag : name
;
