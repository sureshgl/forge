lexer grammar ForgeLexer;

MASTER : 'master' ;

PORT_PREFIX : 'port_prefix';

FIELD : 'field' ;

MODEE : 'mode_e' ;

DESC : 'desc' ;

WRITE : 'write' ;

READ : 'read' ;

INCREMENT : 'increment';

CLEAR : 'clear';

FLOPDOUT : 'flopdout';

FLOPIN : 'flopin';

FLOPOUT : 'flopout';

FLOPMEM: 'flopmem';

INTERFACE_ONLY : 'interface_only';

PARAMETER : 'parameter';

LOCALPARAM : 'localparam';

FIELD_SET : 'field_set';

PARALLEL : 'parallel';

GROUP : 'group' ;

REGISTER : 'register' ;

MEMORY : 'memory' ;

MEMOGEN_CUT : 'memogen_cut' ;

SIM_PRINT : 'sim_print' ;

SIM_DEBUG : 'sim_debug';

HASHTABLE : 'hashtable';

TCAM : 'tcam';

BUNDLE : 'bundle';

REPEATER : 'repeater';

TYPE_WRITE : 'type_write';

TYPE_READ : 'type_read';

TYPE_FIELD : 'type_field';

TYPE_ECC : 'type_ecc';

TYPE_CPU_ACCESS : 'type_cpu_access';

TYPE_SLAVE : 'type_slave';

TYPE_ELAM : 'type_elam';

TYPE_ENUM : 'type_enum';

TYPE_HASHTABLE : 'type_hashtable';

TYPE_LOG : 'type_log' ->mode(type_log_mode);

DATA_WIDTH : 'data_width';

RING : 'ring';

ELAM : 'elam';

LOG : 'log';

TRIGGER : 'trigger';

TYPE : 'type';

BUCKETS : 'buckets';

KEY : 'key';

FLOP  : 'flop';

VALUE : 'value';

WIRE  : 'wire';

HOST  : 'host';

STATUS : 'status';

CONFIG : 'config';

COUNTER : 'counter';

ATOMIC : 'atomic';

SAT_COUNTER : 'sat_counter';

LOGICAL_DIRECT : 'logical_direct';

LOGICAL_INDIRECT : 'logical_indirect';

PHYSICAL_DIRECT : 'physical_direct';

PHYSICAL_INDIRECT : 'physical_indirect';

HINT_ESTIMATOR : 'hint_estimator';

HINT_TOOL : 'hint_tool';

HINT_MEMOGEN : 'hint_memogen';

HINT_ZEROTIME : 'hint_zerotime';

LATENCY : 'latency';

CELL_COUNT_LIMIT : 'cell_count_limit';

NO_SUBPACKING : 'no_subpacking';

POT_WORDS : 'pot_words';

POT_BANKS : 'pot_banks';

SECDED : 'secded';

EVEN_PARITY : 'even_parity';

ODD_PARITY : 'odd_parity';

DEC : 'dec';

CUCKOO: 'cuckoo';

DLEFT : 'dleft';

DECODED : 'decoded';

SLAVE : 'slave';

FLOP_ARRAY : 'flop_array';

PROPERTY_ELAM  : 'property_elam';

PORTCAP : 'port_cap' ->mode(port_cap_mode);

SIZE : 'size' ;

WORDS : 'words';

BITS : 'bits';

CPU : 'cpu' ;

ECC : 'ecc';

HINT : 'hint' ;

BANKS  : 'banks' ;

START_OFFSET : 'start_offset';

ID : [a-zA-Z_] [a-zA-Z0-9_$]* ;

ESCAPED_IDENTIFIER : '\\'~(' '| '\t'| '\r'| '\n')*;

COMMENT :   (('//'|'#') ~('\n'|'\r')* '\r'? '\n'
                |   '/*' .*? '*/' )-> channel(HIDDEN);

WS  :   [ \t\n\r]+ -> channel(HIDDEN);

//STRING : '"' ( ~[\n\r] )* '"' ;

LBRACE : '[' ;

LPAREN : '(';

RPAREN : ')';

LCURL : '{';

RCURL : '}';

RBRACE : ']' ;

COLON : ':' ;

PLUS : '+' ;

CROSS : 'x' ;

COMMA : ',' ;

DOT : '.' ;

MINUS : '-';

STAR : '*';

DIVIDE : '/';

MODULO : '%';

Real_number
    :   Unsigned_number '.' Unsigned_number
    |   Unsigned_number ( '.' Unsigned_number )? [eE] ( [+-] )? Unsigned_number
    ;

Decimal_number
    :   Unsigned_number
    | ( Size )? Decimal_base Unsigned_number
    | ( Size )? Decimal_base X_digit ( '_' )*
    | ( Size )? Decimal_base Z_digit ( '_' )*
    ;
Binary_number : ( Size )? Binary_base Binary_value ;
Octal_number : ( Size )? Octal_base Octal_value ;
Hex_number : ( Size )? Hex_base Hex_value ;

fragment
Sign : [+-] ;
fragment
Size : Non_zero_unsigned_number | ID;
fragment
Non_zero_unsigned_number : Non_zero_decimal_digit ( '_' | Decimal_digit )* ;
fragment
Unsigned_number : Decimal_digit ( '_' | Decimal_digit )* ;
fragment
Binary_value : Binary_digit ( '_' | Binary_digit )* ;
fragment
Octal_value : Octal_digit ( '_' | Octal_digit )* ;
fragment
Hex_value : Hex_digit ( '_' | Hex_digit )* ;

fragment
Decimal_base : '\'' [sS]? [dD] ;
fragment
Binary_base : '\'' [sS]? [bB] ;
fragment
Octal_base : '\'' [sS]? [oO] ;
fragment
Hex_base : '\'' [sS]? [hH] ;

fragment
Non_zero_decimal_digit : [1-9] ;
fragment
Decimal_digit : [0-9] ;
fragment
Binary_digit : X_digit | Z_digit | [01] ;
fragment
Octal_digit : X_digit | Z_digit | [0-7] ;
fragment
Hex_digit : X_digit | Z_digit | [0-9a-fA-F] ;
fragment
X_digit : [xX] ;
fragment
Z_digit : [zZ?] ;

Z_or_X: X_digit|Z_digit;

LQUOTE : '"' -> more, mode(STR) ;

mode port_cap_mode;

R : 'r'|'R'; //Read

W : 'w'|'W'; //Write

U : 'u'|'U'; //Update or Read Modified Write

M : 'm'|'M'; //Malloc or Master

C : 'c'|'C'; //Count

A : 'a'|'A'; //Push

D : 'd'|'D'; //Dequeue

K : 'k'|'K'; //Extract

L : 'l'|'L'; //Save

T : 't'|'T'; //Ternary CAM

B : 'b'|'B'; //Binary CAM

X : 'x'|'X'; //Interface/NAXI

S : 's'|'S'; //Slave

H : 'h'|'H'; //Hash

G : 'g'|'G';

P : 'p'|'P';

OR : 'or'|'OR';//Or operator

NOOP : 'NOOP';

PRT : 'S' | '1P' | '2P' | '4P' | '1PNADJ' | '2PNADJ' | '4PNADJ' | 'G' | 'P' | 'T' | 'C';

NUM     : (DIGIT)+ ;

fragment DIGIT  :   '0'..'9' ;

PORT_CAP_WS  :   [ \t]+ -> channel(HIDDEN);

PORT_COMMENT :   (('//'|'#') ~('\n'|'\r')*
                |   '/*' .*? '*/' )-> channel(HIDDEN) ;

PORT_CAP_NEW_LINE : ('\n' | '\r') ->mode(DEFAULT_MODE);

mode STR;

STRING : '"' -> mode(DEFAULT_MODE) ; // token we want parser to see

ESC : '\\' . -> more ;

TEXT : .   -> more ; // collect more text for string

mode type_log_mode;

TYPE_LOG_TRACE : 'TRACE';

TYPE_LOG_T : 'T';

TYPE_LOG_DEBUG : 'DEBUG';

TYPE_LOG_D : 'D';

TYPE_LOG_INFO : 'INFO';

TYPE_LOG_I : 'I';

TYPE_LOG_WARNING : 'WARNING';

TYPE_LOG_W : 'W';

TYPE_LOG_ERROR : 'ERROR';

TYPE_LOG_E : 'E';

TYPE_LOG_FATAL : 'FATAL';

TYPE_LOG_F : 'F';

TYPE_LOG_COMMA : ',';

TYPE_LOG_PLUS : '+' ;

TYPE_LOG_DOT : '.' ;

TYPE_LOG_ID: [a-zA-Z_] [a-zA-Z0-9_$]* ;

TYPE_LOG_WS : [ \t\n]+ -> channel(HIDDEN);

TYPE_LOG_COMMENT : (('//'|'#') ~('\n'|'\r')* '\r'? '\n'
                |   '/*' .*? '*/' )-> channel(HIDDEN);

TYPE_LOG_LCURL : '{' ;

TYPE_LOG_RCURL : '}' ->mode(DEFAULT_MODE);
