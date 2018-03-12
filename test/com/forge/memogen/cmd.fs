//read attributes
type_read ra_t{ #read_type ra_t 
  read
  interface_only
  trigger
  clear
  flopdout
}

//write attributes
type_write wa_t{ #write_type wa_t
  write
  interface_only
  trigger
  increment
}

type_field ft_t{ #field_type ft_t
  status
  config
  counter
  atomic
  sat_counter
}

//Same as arb fifo depth in pifo module
register arb_fifo_pkt_threshold {
group pifo_cfg
  field thresh 16,,,16'h4
  desc "this field enables blah"
}

register arb_fifo_pkt_thre[1:0] {
group pifo_cfg
  field thresh 16,,,16'h4
    read ra_t.read
    write wa_t.write
}

memory sram [1:0] { 
  hint_memogen : "-v avago -t 16nm_odb -f 1000 -flop flopin=1:flopmem=0:flopout=1 -fr"
  port_cap 2R1W
  words 1024
  bits 32
 banks NUMVBNK
ecc ecc_t.dec,3
group data
    field fx 1
}

