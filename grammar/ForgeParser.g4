parser grammar ForgeParser;

options {
        tokenVocab=ForgeLexer;
}

@header{
    import com.forge.parser.ext.*;
}

start
locals [ StartContextExt extendedContext ]
: constarint_list* ;

constarint_list
locals [ Constarint_listContextExt extendedContext ]
: register 
| memory
| memogen_cut
| tcam
| sim_print
| bundle
| hashtable
| sim_debug
| elam
| flop_array
| property_elam
| type_read
| type_write
| type_field
| type_cpu_access
| type_ecc
| type_slave
| type_elam
| type_log
| type_hashtable
| hint_zerotime
| slave
| type_enum
| field_set
| localparam
| parameter
| repeater 
| master ;

master 
locals [ MasterContextExt extendedContext ]
: MASTER master_name COLON chain;

master_name 
locals [ Master_nameContextExt extendedContext ]
: simple_identifier;

chain
locals [ ChainContextExt extendedContext ]
: slave_name ( COMMA slave_name )* ;

slave_name
locals [ Slave_nameContextExt extendedContext ]
: simple_identifier;

type_log
locals [ Type_logContextExt extendedContext]
: TYPE_LOG type_log_identifier TYPE_LOG_LCURL (type_log_properties)+ TYPE_LOG_RCURL;

type_log_identifier
locals [ Type_log_identifierContextExt extendedContext]
: TYPE_LOG_ID ;

type_log_properties
locals [ Type_log_propertiesContextExt extendedContext]
: (trace | debug | info | warning | error | fatal);

trace
locals [ TraceContextExt extendedContext]
: TYPE_LOG_TRACE  (TYPE_LOG_COMMA TYPE_LOG_T)? | TYPE_LOG_TRACE | TYPE_LOG_T ;

debug
locals [ DebugContextExt extendedContext]
: TYPE_LOG_DEBUG  (TYPE_LOG_COMMA TYPE_LOG_D)? | TYPE_LOG_DEBUG | TYPE_LOG_D ;

info 
locals [ InfoContextExt extendedContext]
: TYPE_LOG_INFO  (TYPE_LOG_COMMA TYPE_LOG_I)? | TYPE_LOG_INFO | TYPE_LOG_I ;

warning
locals [ WarningContextExt extendedContext]
: TYPE_LOG_WARNING  (TYPE_LOG_COMMA TYPE_LOG_W)? | TYPE_LOG_WARNING | TYPE_LOG_W ;

error
locals [ ErrorContextExt extendedContext]
: TYPE_LOG_ERROR  (TYPE_LOG_COMMA TYPE_LOG_E)? | TYPE_LOG_ERROR | TYPE_LOG_E ;

fatal
locals [ FatalContextExt extendedContext]
: TYPE_LOG_FATAL  (TYPE_LOG_COMMA TYPE_LOG_F)? | TYPE_LOG_FATAL | TYPE_LOG_F ;

parameter
locals [ ParameterContextExt extendedContext]
:PARAMETER parameter_identifier parameter_value;

parameter_identifier
locals [ Parameter_identifierContextExt extendedContext]
:simple_identifier;

parameter_value
locals [ Parameter_valueContextExt extendedContext]
:(simple_identifier | number );

localparam
locals [ LocalparamContextExt extendedContext]
:LOCALPARAM localparam_identifier localparam_value;

localparam_identifier
locals [ Localparam_identifierContextExt extendedContext]
: simple_identifier;

localparam_value
locals [ Localparam_valueContextExt extendedContext]
: (simple_identifier | number );

field_set
locals [ Field_setContextExt extendedContext]
: FIELD_SET field_set_identifier LCURL (field_set_properties)+ RCURL ;

field_set_identifier
locals [ Field_set_identifierContextExt extendedContext]
:simple_identifier;

field_set_properties
locals [ Field_set_propertiesContextExt extendedContext ]
:field;

type_enum
locals [ Type_enumContextExt extendedContext ]
: TYPE_ENUM enum_identifier LCURL (enum_properties)+ RCURL ;

enum_identifier
locals [ Enum_identifierContextExt extendedContext ]
:simple_identifier;

enum_properties
locals [ Enum_propertiesContextExt extendedContext ]
: hash_map;

hash_map
locals [ Hash_mapContextExt extendedContext ]
: (hash_map_integer COMMA hash_map_mnemonic COMMA hash_map_description);

hash_map_integer
locals [ Hash_map_integerContextExt extendedContext ]
: number;

hash_map_mnemonic
locals [ Hash_map_mnemonicContextExt extendedContext ]
: STRING;

hash_map_description
locals [ Hash_map_descriptionContextExt extendedContext ]
: STRING;

slave
locals [ SlaveContextExt extendedContext ]
:SLAVE LCURL (slave_properties)+ RCURL;

slave_properties
locals [ Slave_propertiesContextExt extendedContext ]
: (slave_type | data_width);

slave_type
locals [ Slave_typeContextExt extendedContext ]
: TYPE type_slave_action (  PLUS   type_slave_action )* ;

type_slave_action
locals [ Type_slave_actionContextExt extendedContext ]
: type_slave_identifier  type_slave_action_part1;

type_slave_action_part1
locals [ Type_slave_action_part1ContextExt extendedContext ]
:  (  DOT (  type_slave_properties ));

data_width
locals [ Data_widthContextExt extendedContext ]
: DATA_WIDTH  number;

hint_zerotime
locals [ Hint_zerotimeContextExt extendedContext ]
: HINT_ZEROTIME hint_zerotime_identifier LCURL (hint_zerotime_properties) RCURL;

hint_zerotime_identifier
locals [ Hint_zerotime_identifierContextExt extendedContext ]
:simple_identifier;

hint_zerotime_properties
locals [ Hint_zerotime_propertiesContextExt extendedContext ]
: simple_identifier;

type_hashtable
locals [ Type_hashtableContextExt extendedContext ]
: TYPE_HASHTABLE  type_hashtable_identifier LCURL (type_hashtable_properties)+  RCURL;

type_hashtable_identifier
locals [ Type_hashtable_identifierContextExt extendedContext ]
:simple_identifier;

type_hashtable_properties
locals [ Type_hashtable_propertiesContextExt extendedContext ]
: (CUCKOO | DLEFT);

type_elam
locals [ Type_elamContextExt extendedContext ]
: TYPE_ELAM  type_elam_identifier LCURL (type_elam_properties)+  RCURL;

type_elam_identifier
locals [ Type_elam_identifierContextExt extendedContext ]
:simple_identifier;

type_elam_properties
locals [ Type_elam_propertiesContextExt extendedContext ]
: (DECODED | SLAVE);

type_slave
locals [ Type_slaveContextExt extendedContext ]
: TYPE_SLAVE  type_slave_identifier LCURL (type_slave_properties)+ RCURL;

type_slave_identifier
locals [ Type_slave_identifierContextExt extendedContext ]
:simple_identifier;

type_slave_properties
locals [ Type_slave_propertiesContextExt extendedContext ]
:( DECODED | HOST | RING );

type_ecc
locals [ Type_eccContextExt extendedContext ]
: TYPE_ECC  type_ecc_identifier LCURL (type_ecc_properties)+ RCURL;

type_ecc_identifier
locals [ Type_ecc_identifierContextExt extendedContext ]
:simple_identifier;

type_ecc_properties
locals [ Type_ecc_propertiesContextExt extendedContext ]
: (SECDED | EVEN_PARITY | ODD_PARITY | DEC);

type_cpu_access
locals [ Type_cpu_accessContextExt extendedContext ]
: TYPE_CPU_ACCESS  type_cpu_access_identifier LCURL (type_cpu_access_properties)+ RCURL;

type_cpu_access_identifier
locals [ Type_cpu_access_identifierContextExt extendedContext ]
:simple_identifier;

type_cpu_access_properties
locals [ Type_cpu_access_propertiesContextExt extendedContext ]
: (LOGICAL_DIRECT | LOGICAL_INDIRECT | PHYSICAL_DIRECT | PHYSICAL_INDIRECT);

type_field
locals [ Type_fieldContextExt extendedContext ]
: TYPE_FIELD  type_field_identifier LCURL (type_field_properties)+ RCURL;

type_field_identifier
locals [ Type_field_identifierContextExt extendedContext ]
:simple_identifier;

type_field_properties
locals [ Type_field_propertiesContextExt extendedContext ]
: (STATUS | CONFIG | COUNTER | SAT_COUNTER | ATOMIC);

type_write
locals [ Type_writeContextExt extendedContext ]
: TYPE_WRITE type_write_identifier LCURL (type_write_properties)+ RCURL;

type_write_identifier
locals [ Type_write_identifierContextExt extendedContext ]
:simple_identifier;

type_write_properties
locals [ Type_write_propertiesContextExt extendedContext ]
: (WRITE | TRIGGER | INCREMENT |  INTERFACE_ONLY);

type_read
locals [ Type_readContextExt extendedContext ]
: TYPE_READ type_read_identifier LCURL (type_read_properties)+ RCURL;

type_read_identifier
locals [ Type_read_identifierContextExt extendedContext ]
:simple_identifier;

type_read_properties
locals [ Type_read_propertiesContextExt extendedContext ]
: (READ | TRIGGER | CLEAR | PARALLEL | FLOPDOUT | INTERFACE_ONLY);

property_elam
locals [ Property_elamContextExt extendedContext ]
: PROPERTY_ELAM property_elam_identifier LCURL property_elam_properties RCURL;

property_elam_identifier
locals [ Property_elam_identifierContextExt extendedContext ]
: simple_identifier;

property_elam_properties
locals [ Property_elam_propertiesContextExt extendedContext ]
: words;

flop_array
locals [ Flop_arrayContextExt extendedContext ]
: FLOP_ARRAY flop_array_identifier LCURL flop_array_properties RCURL;

flop_array_properties
locals [ Flop_array_propertiesContextExt extendedContext ]
: portCap;
                                         
flop_array_identifier                          
locals [ Flop_array_identifierContextExt extendedContext ]                                        
: simple_identifier;

elam                                     
locals [ ElamContextExt extendedContext ]
: ELAM elam_identifier LCURL (elam_properties)+ RCURL;

elam_properties
locals [ Elam_propertiesContextExt extendedContext ]
: wire;

elam_identifier
locals [ Elam_identifierContextExt extendedContext ]
: simple_identifier;

sim_debug
locals [ Sim_debugContextExt extendedContext ]
: SIM_DEBUG sim_debug_identifier LCURL (sim_debug_properties)+ RCURL;

sim_debug_properties
locals [ Sim_debug_propertiesContextExt extendedContext ]
: ( logger | wire) ;

sim_debug_identifier
locals [ Sim_debug_identifierContextExt extendedContext ]
: simple_identifier;

repeater
locals [ RepeaterContextExt extendedContext ]
: REPEATER repeater_identifier  LCURL (repeater_properties)+  RCURL;

repeater_properties
locals [ Repeater_propertiesContextExt extendedContext ]
:(flop | wire);

flop
locals [ FlopContextExt extendedContext ]
: FLOP  number;

wire 
locals [ WireContextExt extendedContext ]
: WIRE wire_identifier wire_list?;

wire_list
locals [ Wire_listContextExt extendedContext ]
:array;

wire_identifier
locals [ Wire_identifierContextExt extendedContext ]
: simple_identifier;

repeater_identifier
locals [ Repeater_identifierContextExt extendedContext ]
: simple_identifier;

bundle
locals [ BundleContextExt extendedContext ]
: BUNDLE bundle_identifier LCURL  (bundle_properties)+ RCURL;

bundle_properties
locals [ Bundle_propertiesContextExt extendedContext ]
: wire;

sim_print
locals [ Sim_printContextExt extendedContext ]
:  SIM_PRINT  sim_print_identifier  LCURL (sim_print_properties)+ RCURL;

sim_print_properties
locals [ Sim_print_propertiesContextExt extendedContext ]
: (logger | trigger_identifier | wire ) ;

logger
locals [ LoggerContextExt extendedContext ]
:LOG action_id (  PLUS  action_id )* ;

sim_print_identifier
locals [ Sim_print_identifierContextExt extendedContext ]
: simple_identifier ;

trigger_identifier
locals [ Trigger_identifierContextExt extendedContext ]
: TRIGGER  simple_identifier ;

tcam
locals [ TcamContextExt extendedContext ]
:TCAM LCURL (tcam_properties)+ RCURL;

tcam_properties
locals [ Tcam_propertiesContextExt extendedContext ]
:( portCap  | words | bits | key | value ) ;

hashtable
locals [ HashtableContextExt extendedContext ]
: HASHTABLE LCURL  (hash_properties)+ RCURL;

hash_properties
locals [ Hash_propertiesContextExt extendedContext ]
:( portCap | hash_hint | hash_type | words | bits | buckets | key | value ) ;

type_attr
locals [ Type_attrContextExt extendedContext ]
: TYPE  field_action (  PLUS  field_action  )* ;

buckets
locals [ BucketsContextExt extendedContext ]
: BUCKETS  buckets_number;

buckets_number
locals [ Buckets_numberContextExt extendedContext ]
: number;

key
locals [ KeyContextExt extendedContext ]
: KEY key_identifier field*;

key_identifier
locals [ Key_identifierContextExt extendedContext ]
:simple_identifier;

value
locals [ ValueContextExt extendedContext ]
: VALUE value_identifier field*;
 
value_identifier
locals [ Value_identifierContextExt extendedContext ]
: simple_identifier;

hash_hint
locals [ Hash_hintContextExt extendedContext ]
:HINT  hint_zerotime_action (  PLUS  hint_zerotime_action  )* ;

hint_zerotime_action
locals [ Hint_zerotime_actionContextExt extendedContext ]
:hint_zerotime_identifier hint_zerotime_action_part1;

hint_zerotime_action_part1
locals [ Hint_zerotime_action_part1ContextExt extendedContext ]
: (  DOT (  hint_zerotime_identifier));

register
locals [ RegisterContextExt extendedContext ]
: REGISTER  register_identifier  register_list?  LCURL  (register_properties)+ RCURL ;

register_properties
locals [ Register_propertiesContextExt extendedContext ]
: (group  | register_log | start_offset);

register_log
locals [ Register_logContextExt extendedContext ]
: logger;

register_list
locals [ Register_listContextExt extendedContext ]
: array ;

group
locals [ GroupContextExt extendedContext ]
: GROUP  group_identifier  field* ;

field
locals [ FieldContextExt extendedContext ]
: FIELD  field_identifier  field_array?  size?  (field_part1 (field_part2 (field_part3)?)?)? attributes*; 

field_part1
locals [ Field_part1ContextExt extendedContext ]
:  COMMA  align?  ;

field_part2
locals [ Field_part2ContextExt extendedContext ]
:  COMMA  field_enum?   ;

field_part3
locals [ Field_part3ContextExt extendedContext ]
:  COMMA  rst_value?  ;

field_array
locals [ Field_arrayContextExt extendedContext ]
: array ;

align
locals [ AlignContextExt extendedContext ]
: id_or_number;

attributes
locals [ AttributesContextExt extendedContext ]
: description_attr 
| read_attr 
| write_attr
| type_attr  ;

array
locals [ ArrayContextExt extendedContext ]
: LBRACE  max_size  COLON  min_size  RBRACE ;

description_attr
locals [ Description_attrContextExt extendedContext ]
: DESC  STRING ;

read_attr
locals [ Read_attrContextExt extendedContext ]
: READ read_action (  PLUS  read_action  )* ;

write_attr
locals [ Write_attrContextExt extendedContext ]
: WRITE  write_action (  PLUS  write_action  )* ;

rst_value
locals [ Rst_valueContextExt extendedContext ]
: id_or_number ;

id_or_number 
locals [ Id_or_numberContextExt extendedContext ] 
: simple_identifier | number ;

min_size
locals [ Min_sizeContextExt extendedContext ]
: expression ;

max_size
locals [ Max_sizeContextExt extendedContext ]
: expression;

memory
locals [ MemoryContextExt extendedContext ]
:MEMORY  memory_identifier memory_list? LCURL ( memory_properties )+ RCURL;

memogen_cut
locals [Memogen_cutContextExt extendedContext]
: MEMOGEN_CUT memory_identifier memory_list? LCURL ( memory_properties )+ RCURL;

memory_list
locals [ Memory_listContextExt extendedContext ]
: array ;

expression
locals [ ExpressionContextExt extendedContext ]
: number 								#number_only_expression	
| simple_identifier						#id_only_expression
| expression PLUS expression			#addition_expression
| expression MINUS expression			#subtraction_expression
| expression STAR expression			#multiplication_expression
| expression DIVIDE expression			#division_expression
| expression MODULO expression			#modulo_expression
;

memory_properties
locals [ Memory_propertiesContextExt extendedContext ]
: ( portCap  |  words | bits | port_prefix | memory_cpu | memory_ecc  | group | memory_log | banks_size  | start_offset | hint_memogen ) ;

hint_memogen
locals [ Hint_memogenContextExt extendedContext ]
: HINT_MEMOGEN COLON STRING;


start_offset 
locals [ Start_offsetContextExt extendedContext ]
: START_OFFSET id_or_number; 

banks_size
locals [ Banks_sizeContextExt extendedContext]
: BANKS simple_identifier;

port_prefix
locals [ Port_prefixContextExt extendedContext ]
: PORT_PREFIX  read_port_prefix write_port_prefix;

read_port_prefix
locals [ Read_port_prefixContextExt extendedContext ]
: READ port_prefix_list;

write_port_prefix
locals [ Write_port_prefixContextExt extendedContext ]
: WRITE  port_prefix_list;

port_prefix_list
locals [ Port_prefix_listContextExt extendedContext ]
: port_prefix_mux ( COMMA port_prefix_mux)* ;

port_prefix_identifier
locals [ Port_prefix_identifierContextExt extendedContext ]
: simple_identifier;

port_prefix_mux
locals [ Port_prefix_muxContextExt extendedContext ]
: port_prefix_identifier (LPAREN Decimal_number (COMMA Decimal_number)* RPAREN)?;

memory_identifier
locals [ Memory_identifierContextExt extendedContext ]
: simple_identifier ;

memory_log
locals [ Memory_logContextExt extendedContext ]
: logger;

portCap
locals [ PortCapContextExt extendedContext ]
: PORTCAP (pc (OR pc)* pr?) PORT_CAP_NEW_LINE;

pc
locals [ PcContextExt extendedContext ]
:pc_;

pr
locals [ PrContextExt extendedContext ]
: pr_ ;

pc_
locals [ Pc_ContextExt extendedContext ]
: portCap_xm portCap_xs? portCap_r? portCap_rw? portCap_w? portCap_ru? portCap_m? portCap_d? portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |   portCap_xs  portCap_r? portCap_rw? portCap_w? portCap_ru? portCap_m? portCap_d? portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |       portCap_r  portCap_rw? portCap_w? portCap_ru? portCap_m? portCap_d? portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |              portCap_rw  portCap_w? portCap_ru? portCap_m? portCap_d? portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |                          portCap_w  portCap_ru? portCap_m? portCap_d? portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |                     portCap_ru  portCap_m? portCap_d? portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |                     portCap_m  portCap_d? portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |                            portCap_d  portCap_k? portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |                                   portCap_k  portCap_l? portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |                                  portCap_l  portCap_c? portCap_a? portCap_t? portCap_b? portCap_hu?
        |                                 portCap_c  portCap_a? portCap_t? portCap_b? portCap_hu?
        |                                        portCap_a  portCap_t? portCap_b? portCap_hu?
        |                                       portCap_t  portCap_b? portCap_hu?
        |                                              portCap_b  portCap_hu?
        |                                                 portCap_hu
        |   NOOP
        ;

pr_ 
locals [ Pr_ContextExt extendedContext ]
: prt;

prt 
locals [ PrtContextExt extendedContext ]    
: PRT;

portCap_xm
locals [ PortCap_xmContextExt extendedContext ] 
: NUM X M;

portCap_xs
locals [ PortCap_xsContextExt extendedContext ] 
: NUM X S;

portCap_r
locals [ PortCap_rContextExt extendedContext ] 
: NUM R;

portCap_w
locals [ PortCap_wContextExt extendedContext ] 
: NUM W;

portCap_ru
locals [ PortCap_ruContextExt extendedContext ]
: NUM R U;

portCap_rw
locals [ PortCap_rwContextExt extendedContext ]
:  NUM R W ;

portCap_m 
locals [ PortCap_mContextExt extendedContext ]
:  NUM M;

portCap_d 
locals [ PortCap_dContextExt extendedContext ]
: NUM D;

portCap_k 
locals [ PortCap_kContextExt extendedContext ]
: NUM K;

portCap_l 
locals [ PortCap_lContextExt extendedContext ]
: NUM L;

portCap_c 
locals [ PortCap_cContextExt extendedContext ]
: NUM C ;

portCap_a 
locals [ PortCap_aContextExt extendedContext ]
: NUM A;

portCap_t 
locals [ PortCap_tContextExt extendedContext ]
: NUM T ;

portCap_b  
locals [ PortCap_bContextExt extendedContext ]
: NUM B ;

portCap_hu 
locals [ PortCap_huContextExt extendedContext ]
: NUM H U;

words
locals [ WordsContextExt extendedContext ]
: WORDS id_or_number ;

bits
locals [ BitsContextExt extendedContext ]
: BITS id_or_number ;

hash_type
locals [ Hash_typeContextExt extendedContext ]
:TYPE  type_hashtable_action (  PLUS   type_hashtable_action )* ;

type_hashtable_action
locals [ Type_hashtable_actionContextExt extendedContext ]
: type_hashtable_identifier  type_hashtable_action_part1;

type_hashtable_action_part1
locals [ Type_hashtable_action_part1ContextExt extendedContext ]
:  (  DOT (  type_hashtable_properties ));

memory_cpu
locals [ Memory_cpuContextExt extendedContext ]
: CPU  cpu_access_action (  PLUS  cpu_access_action  )* ;

memory_ecc
locals [ Memory_eccContextExt extendedContext ]
: ECC ecc_action  COMMA  ecc_words ;

ecc_words
locals [ Ecc_wordsContextExt extendedContext ]
: id_or_number;

ecc_action
locals [ Ecc_actionContextExt extendedContext ]
: type_ecc_identifier ecc_action_part1;

ecc_action_part1
locals [ Ecc_action_part1ContextExt extendedContext ]
:  (  DOT (  type_ecc_properties ));

read_action
locals [ Read_actionContextExt extendedContext ]
: type_read_identifier read_action_part1;

read_action_part1
locals [ Read_action_part1ContextExt extendedContext ]
:  (  DOT (  type_read_properties ));

write_action
locals [ Write_actionContextExt extendedContext ]
: type_write_identifier write_action_part1;

write_action_part1
locals [ Write_action_part1ContextExt extendedContext ]
:  (  DOT (  type_write_properties ));

field_action
locals [ Field_actionContextExt extendedContext ]
: type_field_identifier field_action_part1;

field_action_part1
locals [ Field_action_part1ContextExt extendedContext ]
:  (  DOT (  type_field_properties ));

cpu_access_action
locals [ Cpu_access_actionContextExt extendedContext ]
: type_cpu_access_identifier cpu_access_action_part1;

cpu_access_action_part1
locals [ Cpu_access_action_part1ContextExt extendedContext ]
:  (  DOT (  type_cpu_access_properties ));

action_id
locals [ Action_idContextExt extendedContext ]
: action_id_identifier  action_id_part1  ;

action_id_part1
locals [ Action_id_part1ContextExt extendedContext ]
:  (  DOT (  action_id_identifier ) )? ;

action_id_identifier
locals [ Action_id_identifierContextExt extendedContext ]
:simple_identifier;

size
locals [ SizeContextExt extendedContext ]
: id_or_number;

field_enum
locals [ Field_enumContextExt extendedContext ]
: MODEE ;

register_identifier
locals [ Register_identifierContextExt extendedContext ]
: simple_identifier ;

group_identifier
locals [ Group_identifierContextExt extendedContext ]
: simple_identifier ;

bundle_identifier
locals [ Bundle_identifierContextExt extendedContext ]
: simple_identifier;

field_identifier
locals [ Field_identifierContextExt extendedContext ]
: simple_identifier ;

simple_identifier
locals [ Simple_identifierContextExt extendedContext ]
: ID ;

number
locals [ NumberContextExt extendedContext ]
: Decimal_number 
|  Octal_number 
|  Binary_number 
|  Hex_number 
|  Real_number ;
