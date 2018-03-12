//read attributes
type_read ra_t{ #read_type ra_t
    read
    interface_only
    trigger
    clear
    parallel # parallel out of all bits
    flopdout
}

//write attributes
type_write wa_t{ #write_type wa_t
    write
    interface_only
    trigger
    increment
}

//Same as arb fifo depth in pifo module
register arb_fifo_pkt_threshold {
    group pifo_cfg
    field thresh 16,,,16'hF0
    read ra_t.read+ra_t.trigger+ra_t.clear
    write wa_t.write+wa_t.trigger
}
//RST is not working
//This is same as NUMCONS in HW
register proc_pkt_threshold [2:0] {
    group pifo_cfg
    field thresh 33,,,16'h0FF
    read ra_t.read
    write wa_t.write
}

register dummyReg {
    group pifo_cfg
    field thresh 39,,,16'hF0
    read ra_t.read
    write wa_t.write
}

register dummy_reg [5:0] {
    group pifo_cfg
    field thresh 65,,,16'h0FF
    read ra_t.read
    write wa_t.write
}

//FIELD  <fieldName>  [1:0]  size,align,field_enum, rst_value attributes*;
//align: start of field will be multiple of align.

memory mem_1 {
    port_cap 1r1w
    words 32
    bits 16
    port_prefix
    read t1
    write t1
    group pifo_cfg
    field fl1 11
    read ra_t.read
    write wa_t.write
    desc "Description TBD"
    
}

memory mem_2[2:0] {
    port_cap 1r1w
    words 32
    bits 64
    port_prefix
    read t2
    write t2
    group pifo_cfg
    field fl1 13
    read ra_t.read
    write wa_t.write
    desc "Description TBD"
    
}

memory mem_3 {
    port_cap 1r1w
    words 128
    bits 64
    port_prefix
    read t3
    write t3
    group pifo_cfg
    field fl1 14
    read ra_t.read+ra_t.interface_only
    write wa_t.write+wa_t.interface_only
    desc "Description TBD"
    
}
