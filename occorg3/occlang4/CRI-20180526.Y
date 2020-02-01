/*{{{  TOP*/

program : process
| block_definition_list

block_definition_list : block_definition
| block_definition_list
  block_definition
/*}}}  */
/*{{{  PROCESS*/

alternation : ALT
                alternative_vlist
| ALT replicator
    alternative
| PRI ALT
    alternative_vlist
| PRI ALT replicator
    alternative

alternative : guarded_alternative | alternation
| specification
  alternative
| channel '?' CASE
    variant_vlist
| boolean '&' channel '?' CASE
    variant_vlist

alternative_vlist :
| alternative_vlist
  alternative

block_definition : PROC name '(' formal_olist ')'
                     procedure_body
                   ':'
| data_type_clist FUNCTION name '(' formal_olist ')'
    function_body
  ':'

case_input : channel '?' CASE
               variant_vlist

choice : guarded_choice
| conditional
| specification
  choice

choice_vlist :
| choice_vlist
  choice

conditional : IF
                choice_vlist
| IF replicator
    choice

construction : sequence | conditional | selection | loop
| parallel | alternation

definition : PROTOCOL name IS simple_protocol ':'
| PROTOCOL name IS sequential_protocol ':'
| PROTOCOL name
    CASE
      tagged_protocol_vlist
  ':'
| ANY FUNCTION name '(' ')'
    function_body
  ':'
| data_type_clist FUNCTION name '(' formal_olist ')' IS expression_list ':'
| specifier name RETYPES element ':'
| VAL specifier name RETYPES expression ':'
| block_definition

function_body : value_process

guarded_alternative : guard
                        process

guarded_choice : boolean
                   process

loop : WHILE boolean
         process

option : case_expression_clist
           process
| ELSE
    process
| specification
  option

option_vlist :
| option_vlist
  option

parallel : PAR
             process_vlist
| PAR replicator
    process
| PRI PAR
    process_vlist
| PRI PAR replicator
    process
| placedpar

placedpar : PLACED PAR
              placedpar_vlist
| PLACED PAR replicator
    placedpar
| PROCESSOR expression
    process

placedpar_vlist :
| placedpar_vlist
  placedpar

procedure_body : process

process : SKIP | STOP | action | construction | instance | case_input
| specification
  process
| allocation
  process

process_vlist :
| process_vlist
  process

selection : CASE selector
              option_vlist

sequence : SEQ
             process_vlist
| SEQ replicator
    process

specification : declaration | abbreviation | definition

valof : VALOF
          process
          RESULT expression_list
| specification
  valof

value_process : valof

variant : tagged_list
            process
| specification
  variant

variant_vlist :
| variant_vlist
  variant
/*}}}  */
/*{{{  LINE*/

abbreviation : specifier name IS element ':'
| name IS element ':'
| VAL specifier name IS expression ':'
| VAL name IS expression ':'

action : assignment | input | output

allocation : PLACE name AT expression ':'

declaration : type name_clist ':'

guard : input
| boolean '&' input
| boolean '&' SKIP

instance : name '(' actual_olist ')'

tagged_protocol : tag | tag ';' sequential_protocol

tagged_protocol_vlist :
| tagged_protocol_vlist
  tagged_protocol
/*}}}  */
/*{{{  MIDDLE*/

actual : element | expression

actual_clist : actual | actual_clist ',' actual

actual_olist :  | actual_clist

assignment : variable ASSIGN expression
| variable_list ASSIGN expression_list

base : expression

boolean :  expression

case_expression : expression

case_expression_clist : case_expression | case_expression_clist ',' case_expression

channel : element

delayed_input : timer '?' AFTER expression

expression_list : name '(' expression_olist ')'
| expression_clist

formal : specifier name_clist | VAL specifier name_clist

formal_clist : formal | formal_clist ',' formal

formal_olist :  | formal_clist

input : channel '?' variable
| channel '?' input_item
| channel '?' input_item_slist
| channel '?' CASE tagged_list
| timer_input
| delayed_input
| port '?' variable

input_item : variable | variable DOUBLE_COLON variable

input_item_slist : input_item | input_item_slist ';' input_item

output : channel '!' expression
| channel '!' output_item
| channel '!' output_item_slist
| channel '!' tag
| channel '!' tag ';' output_item_slist
| port '!' expression

output_item : expression | expression DOUBLE_COLON expression

output_item_slist : output_item | output_item_slist ';' output_item

port : element

replicator :  name '=' base FOR count

selector : expression

sequential_protocol : simple_protocol_slist

simple_protocol_slist : simple_protocol | simple_protocol_slist ';' simple_protocol

specifier : primitive_type
| INDEF_SPEC specifier
| '[' expression ']' specifier

tagged_list : tag | tag ';' input_item_slist

timer : element

timer_input : timer '?' variable

variable : element

variable_clist : variable | variable_clist ',' variable

variable_list : variable_clist
/*}}}  */
/*{{{  EXPRESSON*/

andor_expression : andor_expression andor_operator operand
| operand andor_operator operand

array_type : '[' expression ']' type

comms_type : CHAN OF protocol
| TIMER
| PORT OF type

conversion : primitive_type operand
| primitive_type ROUND operand
| primitive_type TRUNC operand

count : expression

element : element '[' subscript ']'
| '[' element FROM subscript FOR subscript ']'
| name

expression : monadic_operator operand
| operand dyadic_operator operand
| andor_expression
| conversion
| operand
| MOSTPOS data_type
| MOSTNEG data_type

expression_clist : expression | expression_clist ',' expression

expression_olist :  | expression_clist

operand : element | literal | table | '(' expression ')'
| name '(' expression_olist ')'

primitive_type : comms_type
| data_type

protocol : name | simple_protocol | ANY

simple_protocol : type | counting_type DOUBLE_COLON INDEF_SPEC type

subscript :  expression

table : table '[' subscript ']'
| '[' expression_clist ']'
| '[' table FROM subscript FOR count ']'

type : primitive_type | array_type
/*}}}  */
/*{{{  SIMPLE*/

byte : ''' character '''

counting_type : BYTE
| INT
| INT16
| INT32
| INT64

data_type : counting_type
| BOOL
| REAL32
| REAL64

data_type_clist : data_type | data_type_clist ',' data_type

digit : 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

exponent : '+' digits | '-' digits

hex_digit : digit | 'A' | 'B' | 'C' | 'D' | 'E' | 'F'

integer : digits | '#' hex_digits

literal : integer
| byte
| integer '(' data_type ')'
| byte '(' data_type ')'
| real '(' data_type ')'
| string
| TRUE | FALSE

name_clist : name | name_clist ',' name

real : digits_digits | digits_digitsEexponent

tag : name
/*}}}  */
