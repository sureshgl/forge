# ... language specific

# , is separator
# + is for providing multiple values per separator

read_type ra_t
  read
  trigger
  clear
  parallel # parallel out of all bits
  flopdout

write_type wa_t
  write
  trigger
  increment

field_type ft_t
  status
  config
  counter
  sat_counter

cpu_access_type ca_t
  logical_direct
  logical_indirect
  physical_direct
  physical_indirect

ecc_type ecc_t
  secded
  even_parity
  odd_parity
  dec

slave_type sl_t
  decoded
  ring
  host # AXI, PCIE etc.,,,?

elam_type el_t
  word_size 96
  decoded
  slave # this is the capturing memory?

hashtable_type ht_t
  cuckoo
  dleft

log_type log_t
  TRACE   T
  DEBUG   D
  INFO    I
  WARNING W
  ERROR   E
  FATAL   F

flop_hint hint_t
  flop_array

estimator_hint hint_t
  latency
  cell_count_limit
  no_subpacking
  pot_words
  pot_banks

# ... project specific

enum ctrl_e 1
  # <name> <int-val>,<mnemonic>,<description>
  en  0,"EN","enable"
  dis 1,"DIS","disable"

enum mode_e 2
  burst  0,"BU","burst"
  single 1,,"single"
  double 1
  pipe   *

field_set pooja_set
  field aen 1,,ctrl_e
  field ben 2,8

field_set suresh_set
  field ken 1,4
  field gen[3:0] 2,4

# ... subsystem downwards
slave
  type sl_t.decoded
  data_width 96
  offset 0x003000

# ... anywhere else - mostly in modules and subsystems
# parameter <local|hier> <name> <int-val>
parameter local ALN4   4
parameter hier  WORD  32

register dg_stat[1:0]
  group ipv4
    # size 32 #optional
    # field name[<max>:<min>] # single bit quantity
    # field name[<max>:<min>] ,<align> # single bit alinged to align bit
    # field name[<max>:<min>] <size>
    # field name[<max>:<min>] <size>,<align>
    # field name[<max>:<min>] <size>,<align>,<enum>
    field fl1 1
      desc "this field enables blah"
      read  ra_t.read+ra_t.trigger
      write wa_t.trigger
    field nms[5:0] 2,ALN4 # array of 6 fields, align 4
    field xen 1
    field cnt 16
    field burst_en 2,,mode_e
  group ipv6
    field fl1 0
    field nms 2 
    field xen 4
    field cnt 16

memory sm_mem
  port_cap 2r1w
  size 1024x45
  hint hint_t.no_subpacking+hint_t.pot_words
  cpu ca_t.logical_indirect+ca_t.physical_indirect
  ecc ecc_t.ded,3 # ded type ECC, 3 words
  group data
    field fx 0  32
    field en 32 96
    field pooja_set[1:0]
    field suresh_set

flop_array fl_arr
   port_cap 2T3R4W # two TCAM, 3 read, 4 write

hashtable
  port_cap 2l1r1w # 2 lookup, 1R, 1W
  type ht_t.dleft
  size 1024x45
  buckets 4
  key
    lif 10
    spr 4
  value
    data 32

tcam
  port_cap 2l1r1w # 2 lookup, 1R, 1W
  hint 

# learntable?



elam sm_elam_1
   cdout
   cadr

sim_debug sm_dbg_1
  log log_t.DEBUG
  # <signal-name>
  # <signal-name> <align>
  # <signal-name> <align>,<enum>
  cdout ,ctrl_e
  cadr

sim_print sm_pr_1
  log log_t.INFO
  # <signal-name>
  # <signal-name> <align>
  # <signal-name> <align>,<enum>
  cdout ,ctrl_e
  cadr 8
  my_array[1:0] # only 1:0 of the my_array signal


# emitters:
#   verilog - reg, mem, types of slaves etc., params and defines
#   text - table of registers and fields/formatted nicely
#   html - with adr, tables, fields ... clickable links
#   C++ - classes, defines, macros
#   address map - rolled up address map
#   mem list - text file of logical size
#   total estimated memory sizing and power sheet, logical/physical diff

