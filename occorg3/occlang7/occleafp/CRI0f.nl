alternation = ALT NEWLINE
| PRI ALT NEWLINE

alternative = alternation
| specification
  alternative
| channel '?' CASE NEWLINE
| boolean '&' channel '?' CASE NEWLINE

alternative_vlist = alternative
| alternative_vlist
  alternative

case_input = channel '?' CASE NEWLINE

choice = conditional
| specification
  choice

choice_vlist = choice
| choice_vlist
  choice

conditional = IF NEWLINE

construction = sequence | conditional | selection
| parallel | alternation

definition = value_definition
| data_type_clist FUNCTION name '(' formal_olist ')' IS expression_list ':' NEWLINE
| specifier name RETYPES element ':' NEWLINE

function_body =

parallel = PAR NEWLINE
| PRI PAR NEWLINE
| placedpar

placedpar = PLACED PAR NEWLINE

placedpar_vlist = placedpar
| placedpar_vlist
  placedpar

procedure_body = process

process = SKIP NEWLINE
| STOP NEWLINE
| action | construction | instance | case_input
| specification
  process
| allocation
  process

process_vlist = process
| process_vlist
  process

selection = CASE selector NEWLINE

sequence = SEQ NEWLINE

specification = declaration | abbreviation | definition
