 hint_zerotime zt_h {
zt_des_1s1su_1r1ru
}

type_hashtable ht_t{ #hashtable_type ht_t
  cuckoo
  dleft
}
 
 hashtable{
 hint zt_h.zt_des_1s1su_1r1ru
  type ht_t.dleft
  words 1024
  port_cap 2R1W
  bits 12
  buckets 4
  key srcadr
    field lif 10,6
    field spr 4
  value l2ptr
     field cnt  32
     field lif  26,2
     field spr 7,15
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

 hashtable{
 hint zt_h.zt_des_2s1su_1r1ru+zt_h.zt_des_1r1su_1r1ru
  type ht_t.dleft
  words 2048
  port_cap 2R1W
  bits 45
  buckets 4
  key srcadr
    field lif 10,6
    field spr 4
  value l2ptr
     field cnt  32
     field lif  26,2
     field spr 7,15
}

 hashtable{
 hint zt_h.zt_des_2r1su_1r1ru
  type ht_t.dleft
  words 4096
  port_cap 2R1W
  bits 55
  buckets 4
  key srcadr
    field lif 10,6
    field spr 4
  value l2ptr
     field cnt  32
     field lif  26,2
     field spr 7,15
}
