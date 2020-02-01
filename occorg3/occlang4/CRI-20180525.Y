/*{{{  TOP*/

program : process
| block_definition_list

block_definition_list : block_definition
| block_definition_list
  block_definition
/*}}}  */
/*{{{  PROCESS*/

alternation : ALT
                { alternative }
| ALT replicator
    alternative
| PRI ALT
    { alternative }
| PRI ALT replicator
    alternative

alternative : guarded_alternative | alternation
| specification
  alternative
| channel '?' CASE
    { variant }
| boolean '&' channel '?' CASE
    { variant }

block_definition : PROC name '(' {o ',' formal } ')'
                     procedure_body
                   ':'
| {1 ',' data_type } FUNCTION name '(' {o ',' formal } ')'
    function_body
  ':'

case_input : channel '?' CASE
               { variant }

choice : guarded_choice
| conditional
| specification
  choice

conditional : IF
                { choice }
| IF replicator
    choice

construction : sequence | conditional | selection | loop
| parallel | alternation

definition : PROTOCOL name IS simple_protocol ':'
| PROTOCOL name IS sequential_protocol ':'
| PROTOCOL name
    CASE
      { tagged_protocol }
  ':'
| ANY FUNCTION name '(' ')'
    function_body
  ':'
| {1 ',' data_type } FUNCTION name '(' {o ',' formal } ')' IS expression_list ':'
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

option : {1 ',' case_expression }
           process
| ELSE
    process
| specification
  option

parallel : PAR
             { process }
| PAR replicator
    process
| PRI PAR
    { process }
| PRI PAR replicator
    process
| placedpar

placedpar : PLACED PAR
              { placedpar }
| PLACED PAR replicator
    placedpar
| PROCESSOR expression
    process

procedure_body : process

process : SKIP | STOP | action | construction | instance | case_input
| specification
  process
| allocation
  process

selection : CASE selector
              { option }

sequence : SEQ
             { process }
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
/*}}}  */
/*{{{  LINE*/

abbreviation : specifier name IS element ':'
| name IS element ':'
| VAL specifier name IS expression ':'
| VAL name IS expression ':'

action : assignment | input | output

allocation : PLACE name AT expression ':'

declaration : type {1 ',' name } ':'

guard : input
| boolean '&' input
| boolean '&' SKIP

instance : name '(' {o ',' actual } ')'

tagged_protocol : tag | tag ';' sequential_protocol
/*}}}  */
/*{{{  MIDDLE*/

actual : element | expression

assignment : variable := expression
| variable_list := expression_list

base : expression

boolean :  expression

case_expression : expression

channel : element

delayed_input : timer '?' AFTER expression

expression_list : name '(' {o ',' expression } ')'
| {1 ',' expression }

formal : specifier {1 ',' name } | VAL specifier {1 ',' name }

input : channel '?' variable
| channel '?' input_item
| channel '?' {1 ';' input_item }
| channel '?' CASE tagged_list
| timer_input
| delayed_input
| port '?' variable

input_item : variable | variable :: variable

output : channel '!' expression
| channel '!' output_item
| channel '!' {1 ';' output_item }
| channel '!' tag
| channel '!' tag ';' {1 ';' output_item }
| port '!' expression

output_item : expression | expression :: expression

port : element

replicator :  name = base FOR count

selector : expression

sequential_protocol : {1 ';' simple_protocol }

specifier : primitive_type
| [] specifier
| '[' expression ']' specifier

tagged_list : tag | tag ';' {1 ';' input_item }

timer : element

timer_input : timer '?' variable

variable : element

variable_list : {1 ',' variable }
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

operand : element | literal | table | '(' expression ')'
| name '(' {o ',' expression } ')'

primitive_type : comms_type
| data_type

protocol : name | simple_protocol | ANY

simple_protocol : type | counting_type :: [] type

subscript :  expression

table : table '[' subscript ']'
| '[' {1 ',' expression } ']'
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

real : digits_digits | digits_digitsEexponent

tag : name
/*}}}  */
