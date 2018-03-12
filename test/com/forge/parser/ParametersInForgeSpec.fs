register drmt_reg_1 { // words 5, array size 0
  group one
    field fl1 150
}

register drmt_reg_2[PARAM1:0] { // words 1, array size 3
  group one
    field fl1 30
}

register drmt_reg_3[2:0]{ // words 2, array size 3
  start_offset 'h100
  group one
    field fl1 PARAM3
}

register drmt_reg_4[PARAM2:0] { // words 4, array size 3
  group one
    field fl1 120
}


memory memory1 { // words 2, array size 2
 start_offset 'h600
 hint  est_h.no_subpacking+est_h.pot_words
  cpu ca_t.logical_indirect+ca_t.physical_indirect
   ecc ecc_t.dec,3
   port_cap 2R1W
   words PARAM4
   bits 16
  banks NUMVBNK
  port_prefix
   read t1,t2(1,0)
   write t1(1),t2(0,1)
 port_prefix
   read t1,t2
   write t1
 ecc ecc_t.dec,3
 group data
     field fx 1
     field en 32
}  

memory sm_mem1[1:0]{ // words 2, array size 2
hint  est_h.no_subpacking+est_h.pot_words
 cpu ca_t.logical_indirect+ca_t.physical_indirect
  ecc ecc_t.dec,3
  port_cap 2R1W
  words 32 //Words should be only POT -- Sharad
  bits 34
 banks NUMVBNK
 port_prefix
  read t1,t2(1,0)
  write t1(1),t2(0,1)
port_prefix
  read t1,t2
  write t1
ecc ecc_t.dec,3
group data
    field fx 1
    field en 32
}

memory sm_mem2 { // words 2, array size 2
start_offset 'h800
 hint  est_h.no_subpacking+est_h.pot_words
  cpu ca_t.logical_indirect+ca_t.physical_indirect
   ecc ecc_t.dec,3
   port_cap 2R1W
   words 128
   bits 64
  banks NUMVBNK
  port_prefix
   read t1,t2(1,0)
   write t1(1),t2(0,1)
 port_prefix
 read t1,t2(1,0)
  write t1(1),t2(0,1)
port_prefix
  read t1,t2
  write t1
ecc ecc_t.dec,3
group data
    field fx 1
    field en 32
 
}

