This directory contains various priority encoders. Here is what each file means.

priority_encode.v           (Recursive)
    A generic priority encoder with associated data in and out. (Non-Id
    based). Written recursively in log structure steps.
    It also has a global_enable flag, which can overwrite the decode bits.

priority_encode_id.v        (Recursive)
    An ID based priority encoder which calls above module.
    
priority_encode_rec_old.v   (Recursive)
    A toned down version of above one, without global_enable.

priority_encode_dsbu.v      (Combinatorial)
    A log structure combinatorial encoder. From DSBU team.

priority_encode_rec.v       (Recursive)
    This one uses log structued bits as well. Also, it uses a trick on valid
    and encode bits to further optimize the gates.

priority_encode_flopped.v   (Flopped)
    A wrapped around various encoders. 
    Used for synthesis perpose.
    
priority_encode_simple.v    (Looped)
    This is the simple priority encoder. Just a loop on bits.
    A comparison point against others.


    ==================
        PERFORMANCE
    ==================

priority_encode_simple is the worst, for obvious reasons.
Without bountry optimization (which is default in our regress scripts),
combinatorial (dsbu) encoder wins.
Here is table for various sizes. 
(Time is in pico seconds) (Not Flopped) 

Size    DSBU    Rec_Old Simple  Log
2048    350     440     600     350
1024    310     390     540     320
512     280     350     460
256     240     310     360
128     210     280     290
64      170     240     230
32      130     210     160

If boundry optimizations (cross module hirarchy) are enabled, then all other
perform almost the same. Priority_encode_rec optimizes further, by slight margin.

Here is table again, Flopped, with boundry optimizations.

Size    DSBU    Rec     Log     simple
2048    480     460
1024    470     450     460     690
512     420     410
256     380     380
128     350     340
64      310     310
32      280     280


