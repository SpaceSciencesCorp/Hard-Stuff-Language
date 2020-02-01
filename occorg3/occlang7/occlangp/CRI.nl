alternation = ALT NEWLINE
                RIND alternative_vlist1 ROUTD
| ALT NEWLINE
| ALT replicator NEWLINE
    RIND alternative1 ROUTD
| PRI ALT NEWLINE
    RIND alternative_vlist1 ROUTD
| PRI ALT NEWLINE
| PRI ALT replicator NEWLINE
    RIND alternative1 ROUTD

alternative = guarded_alternative
| alternation
| specification
  alternative
| channel '?' CASE NEWLINE
    RIND variant_vlist1 ROUTD
| channel '?' CASE NEWLINE
| boolean '&' channel '?' CASE NEWLINE
    RIND variant_vlist1 ROUTD
| boolean '&' channel '?' CASE NEWLINE

alternative_vlist = alternative
| alternative_vlist
  alternative

block_definition = PROC name '(' formal_olist ')' NEWLINE
                     RIND procedure_body1 ROUTD
                   ':' NEWLINE
| data_type_clist FUNCTION name '(' formal_olist ')' NEWLINE
    RIND function_body1 ROUTD
  ':' NEWLINE

case_input = channel '?' CASE NEWLINE
               RIND variant_vlist1 ROUTD
| channel '?' CASE NEWLINE

choice = guarded_choice
| conditional
| specification
  choice

choice_vlist = choice
| choice_vlist
  choice

conditional = IF NEWLINE
                RIND choice_vlist1 ROUTD
| IF NEWLINE
| IF replicator NEWLINE
    RIND choice1 ROUTD

construction = sequence | conditional | selection | loop
| parallel | alternation

definition = value_definition
| ANY FUNCTION name '(' ')' NEWLINE
    RIND function_body1 ROUTD
  ':' NEWLINE
| data_type_clist FUNCTION name '(' formal_olist ')' IS expression_list ':' NEWLINE
| specifier name RETYPES element ':' NEWLINE
| block_definition

function_body = value_process

guarded_alternative = guard
                        RIND process1 ROUTD

guarded_choice = boolean NEWLINE
                   RIND process1 ROUTD

loop = WHILE boolean NEWLINE
         RIND process1 ROUTD

option = case_expression_clist NEWLINE
           RIND process1 ROUTD
| ELSE NEWLINE
    RIND process1 ROUTD
| specification
  option

option_vlist = option
| option_vlist
  option

parallel = PAR NEWLINE
             RIND process_vlist1 ROUTD
| PAR NEWLINE
| PAR replicator NEWLINE
    RIND process1 ROUTD
| PRI PAR NEWLINE
    RIND process_vlist1 ROUTD
| PRI PAR NEWLINE
| PRI PAR replicator NEWLINE
    RIND process1 ROUTD
| placedpar

placedpar = PLACED PAR NEWLINE
              RIND placedpar_vlist1 ROUTD
| PLACED PAR NEWLINE
| PLACED PAR replicator NEWLINE
    RIND placedpar1 ROUTD
| PROCESSOR expression NEWLINE
    RIND process1 ROUTD

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
              RIND option_vlist1 ROUTD
| CASE selector NEWLINE

sequence = SEQ NEWLINE
             RIND process_vlist1 ROUTD
| SEQ NEWLINE
| SEQ replicator NEWLINE
    RIND process1 ROUTD

specification = declaration | abbreviation | definition

valof = VALOF NEWLINE
          RIND process1
          RESULT expression_list NEWLINE ROUTD
| specification
  valof

value_process = valof

variant = tagged_list NEWLINE
            RIND process1 ROUTD
| specification
  variant

variant_vlist = variant
| variant_vlist
  variant
