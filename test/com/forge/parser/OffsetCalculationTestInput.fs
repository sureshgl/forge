register dg_stat[1:0]{
  group ipv6 
    field dg_stat_fl1 1,2
    field dg_stat_nms 2,5
    field dg_stat_xen 4
    field dg_stat_cnt 16,,mode_e,1'b0
 desc "this field enables blah"
read  ra_t.read+ra_t.trigger
 write wa_t.trigger
}

register dx_stat{
  group ipv6 
    field dx_stat_fl1 10
 desc "this field enables blah"
read  ra_t.read+ra_t.trigger
 write wa_t.trigger
}


memory sm_mem{
  port_cap 2R1W
  words 1024
  bits 32
  group data
    field sm_mem_f1 1
    field sm_mem_f2 32
}

memory sx_mem{
  port_cap 2R1W
  words 1024
  bits 32
  group data
    field sx_mem_f1 1
    field sx_mem_f1 32
}

hashtable{
 hint zt_h.zt_des_1s1su_1r1ru
  type ht_t.dleft
  words 1024
  port_cap 2R1W
  bits 45
  buckets 4
  key srcadr
    field hashtable_lif 10,6
    field hashtable_spr 4
  value l2ptr
     field hashtable_cnt  32
     field hashtable_lif  26,2
     field hashtable_spr 7,15
}

tcam{
  port_cap 2R1W # 2 lookup, 1R, 1W
  words 1024
  bits 32
  key ipv4
    field tcam_lif 10,6
    field tcam_spr 4,1
    field tcam_abc 7,15
  value ipv7
    field tcam_lif 32
    field tcam_spr 26,2
 
}