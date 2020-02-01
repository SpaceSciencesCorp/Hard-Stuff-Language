alternation = ALT NEWLINE
| PRI ALT NEWLINE

alternative = guarded_alternative
| alternation
| specification
  alternative
| channel '?' CASE NEWLINE
| boolean '&' channel '?' CASE NEWLINE

alternative_vlist = alternative
| alternative_vlist
  alternative

block_definition =

case_input = channel '?' CASE NEWLINE

choice = guarded_choice
| conditional
| specification
  choice

choice_vlist = choice
| choice_vlist
  choice

conditional = IF NEWLINE

construction = sequence | conditional | selection | loop
| parallel | alternation

definition = value_definition
| data_type_clist FUNCTION name '(' formal_olist ')' IS expression_list ':' NEWLINE
| specifier name RETYPES element ':' NEWLINE
| block_definition

function_body = value_process

guarded_alternative =

guarded_choice =

loop =

option = specification
         option

option_vlist = option
| option_vlist
  option

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

valof = specification
        valof

value_process = valof

variant = specification
          variant

variant_vlist = variant
| variant_vlist
  variant
