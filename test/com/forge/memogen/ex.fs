
hint_estimator est_h {#hint estimator est_hint_t
  latency
  cell_count_limit
  no_subpacking
  pot_words
  pot_banks
  flop_array
}

memory blah_mem{ // words 2, array size 2
hint  est_h.flop_array
 cpu ca_t.logical_indirect+ca_t.physical_indirect
  ecc ecc_t.dec,3
  port_cap 1R1W
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