andor_expression = andor_expression andor_operator operand
| operand andor_operator operand

comms_type = CHAN OF protocol
| TIMER
| PORT OF non_comms_type

conversion = primitive_type operand
| primitive_type ROUND operand
| primitive_type TRUNC operand

count = expression

element = element '[' subscript1 ']'
| '[' element1 FROM subscript1 FOR count1 ']'
| scalar

expression = monadic_operator operand
| operand dyadic_operator operand
| andor_expression
| conversion
| operand
| MOSTPOS data_type
| MOSTNEG data_type

expression_clist = expression | expression_clist ',' expression

expression_olist =  | expression_clist

operand = element | literal | table | '(' expression1 ')'
| name '(' expression_olist1 ')'

primitive_type = comms_type
| data_type

protocol = name | simple_protocol | ANY

simple_protocol = non_comms_type
| counting_type DOUBLE_COLON INDEF_SPEC non_comms_type

subscript =  expression

table = table '[' subscript1 ']'
| '[' expression_clist1 ']'
| '[' table1 FROM subscript1 FOR count1 ']'
| string

non_comms_type = data_type
| '[' expression1 ']' non_comms_type
