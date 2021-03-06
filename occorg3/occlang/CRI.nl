
abbreviation = specifier name IS element :
| name IS element :
| VAL specifier name IS expression :
| VAL name IS expression :

action = assignment | input | output

actual = element | expression

allocation = PLACE name AT expression :

alternation = ALT
                { alternative }
| ALT replicator
    alternative
| PRI ALT
    { alternative }
| PRI ALT replicator
    alternative

alternative = guarded.alternative | alternation
| specification
  alternative
| channel ? CASE
    { variant }
| boolean & channel ? CASE
    { variant }

array.type = [ expression ] type

assignment = variable := expression
| variable.list := expression.list

base = expression

boolean =  expression

byte = ' character '

case.expression = expression

case.input = channel ? CASE
               { variant }

channel = element

choice = guarded.choice
| conditional
| specification
  choice

conditional = IF
                { choice }
| IF replicator
    choice

construction = sequence | conditional | selection | loop
| parallel | alternation

conversion = primitive.type operand
| primitive.type ROUND operand
| primitive.type TRUNC operand

count = expression

declaration = type {1 , name } :

definition = PROTOCOL name IS simple.protocol :
| PROTOCOL name IS sequential.protocol :
| PROTOCOL name
    CASE
      { tagged.protocol }
  :
| PROC name ( {o , formal } )
    procedure.body
  :
| {1 , primitive.type } FUNCTION name ( {o , formal } )
    function.body
  :
| {1 , primitive.type } FUNCTION name ( {o , formal } ) IS expression.list :
| specifier name RETYPES element :
| VAL specifier name RETYPES expression :

delayed.input = timer ? AFTER expression

digit = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

element = element [ subscript ]
| [ element FROM subscript FOR subscript ]
| name

exponent = + digits | - digits

expression = monadic.operator operand
| operand dyadic.operator operand
| conversion
| operand
| MOSTPOS type
| MOSTNEG type

expression.list = ( value.process
                  )
| name ( {o , expression } )
| {1 , expression }

formal = specifier {1 , name } | VAL specifier {1 , name }

function.body = value.process

guard = input
| boolean & input
| boolean & SKIP

guarded.alternative = guard
                        process

guarded.choice = boolean
                   process

hex.digit = digit | A | B | C | D | E | F

input = channel ? variable
| channel ? input.item
| channel ? {1 ; input.item }
| channel ? CASE tagged.list
| timer.input
| delayed.input
| port ? variable

input.item = variable | variable :: variable

instance = name ( {o , actual } )

integer = digits | # hex.digits

literal = integer
| byte
| integer ( type )
| byte ( type )
| real ( type )
| string
| TRUE | FALSE

loop = WHILE boolean
         process

operand = element | literal | table | ( expression )
| ( value.process
  )
| name ( {o , expression } )

option = {1 , case.expression }
           process
| ELSE
    process
| specification
  option

output = channel ! expression
| channel ! output.item
| channel ! {1 ; output.item }
| channel ! tag
| channel ! tag ; {1 ; output.item }
| port ! expression

output.item = expression | expression :: expression

parallel = PAR
             { process }
| PAR replicator
    process
| PRI PAR
    { process }
| PRI PAR replicator
    process
| placedpar

placedpar = PLACED PAR
              { placedpar }
| PLACED PAR replicator
    placedpar
| PROCESSOR expression
    process

port = element

primitive.type = CHAN OF protocol
| TIMER
| BOOL
| BYTE
| INT
| INT16
| INT32
| INT64
| REAL32
| REAL64
| PORT OF type

procedure.body = process

process = SKIP | STOP | action | construction | instance | case.input
| specification
  process
| allocation
  process

protocol = name | simple.protocol | ANY

real = digits.digits | digits.digitsEexponent

replicator =  name = base FOR count

selection = CASE selector
              { option }

selector = expression

sequence = SEQ
             { process }
| SEQ replicator
    process

sequential.protocol = {1 ; simple.protocol }

simple.protocol = type | primitive.type :: [] type

specification = declaration | abbreviation | definition

specifier = primitive.type
| [] specifier
| [ expression ] specifier

subscript =  expression

table = table [ subscript ]
| [ {1 , expression } ]
| [ table FROM subscript FOR count ]

tag = name

tagged.list = tag | tag ; {1 ; input.item }

tagged.protocol = tag | tag ; sequential.protocol

timer = element

timer.input = timer ? variable

type = primitive.type | array.type

valof = VALOF
          process
          RESULT expression.list
| specification
  valof

value.process = valof

variable = element

variable.list = {1 , variable }

variant = tagged.list
            process
| specification
  variant
