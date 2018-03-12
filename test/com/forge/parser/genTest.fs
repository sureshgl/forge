register blah_reg[1:0] { // words 7, array size 2
  group one
    field fl1 200
}

register blah_reg1 { // words 7, array size 2
  group one
    field fl1 200
}

type_read ra_t{ #read_type ra_t
  read
  interface_only
  trigger
  clear
  parallel # parallel out of all bits
  flopdout
}

type_write wa_t{ #write_type wa_t
  write
  interface_only
  trigger
  increment
}


memory blah_mem{ // words 2, array size 2
hint  est_h.no_subpacking+est_h.pot_words
 cpu ca_t.logical_indirect+ca_t.physical_indirect
  ecc ecc_t.dec,3
  port_cap 2R1W
  words 17
  bits 34
ecc ecc_t.dec,3
group data
    field fx 1
    read ra_t.read+ra_t.interface_only
    write wa_t.write+wa_t.interface_only
    field en 32
    read ra_t.read+ra_t.interface_only
    write wa_t.write+wa_t.interface_only
}

memory blah_mem2{ // words 2, array size 2
hint  est_h.no_subpacking+est_h.pot_words
 cpu ca_t.logical_indirect+ca_t.physical_indirect
  ecc ecc_t.dec,3
  port_cap 2R1W
  words 17
  bits 34
ecc ecc_t.dec,3
group data
    field en 32
}
