/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
class CyclicRandomGenerator #(int MIN = 0, int MAX = 1024, int ITER = 1);
  int arr[];
  int ci = 0;
  
  function new ();
    arr = new[(MAX-MIN)*ITER];
    for(int i=MIN; i<MAX; i++) 
      for (int j=1; j <=ITER; j++) 
        arr[ITER*(i-MIN)+j-1] = i;
    shuffle();
  endfunction
  
  function void shuffle();
    for(int i = 0; i<arr.size()-1; i++) begin
      int n = $urandom_range(arr.size()-1, i);
      int temp = arr[i];
      arr[i] = arr[n];
      arr[n] = temp;
    end		
    ci = 0;
  endfunction
  
  function int next();
    if(ci == arr.size())
      shuffle();
    next = arr[ci];
    ci++;
  endfunction

endclass
