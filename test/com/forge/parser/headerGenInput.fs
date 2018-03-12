
register arb_fifo_pkt_threshold {
group pifo_cfg
  field thresh 16,,,16'hF0
    read ra_t.read+ra_t.trigger+ra_t.clear
    write wa_t.write+wa_t.trigger
}

register proc_pkt_threshold [2:0] {
group pifo_cfg
  field thresh 30
    read ra_t.read
    write wa_t.write
  field thr 3,,,16'h0FF
    read ra_t.read
    write wa_t.write
}

register dummyReg {
group pifo_cfg
  field thresh 39,,,16'hF0
    read ra_t.read
    write wa_t.write
}

register dummy_reg1 [5:0] {
group pifo_cfg
  field thresh 65,,,16'h0FF
    read ra_t.read
    write wa_t.write
}

