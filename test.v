module test();
   parameter num = 100; // Number of messages and keys to generate

   reg [31:0] mes [3:0]; // for 128 bit message
   reg [31:0] k1 [3:0]; // for 128 bit key
   reg [31:0] k2 [5:0]; // for 192 bit key
   reg [31:0] k3 [7:0]; // for 256 bit key
   reg [127:0] messages [num-1:0];
   reg [127:0] keys_128 [num-1:0];
   reg [191:0] keys_192 [num-1:0];
   reg [255:0] keys_256 [num-1:0];

   integer  rnd,i,j;
   
   initial begin
      for (i=0; i<num; i=i+1)
      begin
      for (j=0; j<4; j=j+1)
      begin
         mes[j]=$urandom;
         if (mes[j] < 2147483648) 
            mes[j] = mes[j] + 2147483648;
         k1[j]=$urandom;
         if (k1[j] < 2147483648) 
            k1[j] = k1[j] + 2147483648;
      end
      messages[i] = {mes[3],mes[2],mes[1],mes[0]};
      keys_128[i] = {k1[3],k1[2],k1[1],k1[0]};
      $display("Messages: %0h" ,messages[i]); 
      $display("Keys_128: %0h" ,keys_128[i]); 
      for (j=0; j<6; j=j+1)
      begin
         k2[j]=$urandom;
         if (k2[j] < 2147483648) 
            k2[j] = k2[j] + 2147483648;
      end
      keys_192[i] = {k2[5],k2[4],k2[3],k2[2],k2[1],k2[0]};
      $display("Keys_192: %0h",keys_192[i]);

      for (j=0; j<8; j=j+1)
      begin
         k3[j]=$urandom;
         if (k3[j] < 2147483648) 
            k3[j] = k3[j] + 2147483648;
      end
      keys_256[i] = {k3[7],k3[6],k3[5],k3[4],k3[3],k3[2],k3[1],k3[0]};
      $display("Keys_256: %0h",keys_256[i]);
      end 
      $finish;
   end
endmodule