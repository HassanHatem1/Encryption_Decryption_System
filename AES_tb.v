`timescale 1ns / 1ps

module aes_tb();

//**********************************************************************//
// Generate random messages and keys

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
//**********************************************************************//
  reg rst;

  // Inputs
  reg [127:0] msg;
  reg [127:0] w;
  reg [127:0] key;
  reg [127:0] encrypt_msg;
  
  // Outputs
  wire [127:0] cipher;

  // Initialize clock and reset
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
    
    rst = 1;
    #10 rst = 0;
  end
  
  // Test vectors
  initial begin
    msg = 128'h6bc1bee22e409f96e93d7e117393172a;
    key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    
    #100;
    
    // Expected cipher
    assert(cipher === 128'h3ad77bb40d7a3660a89ecaf32466ef97) else $error("Test failed: encryption mismatch");
    
    //msg = cipher;
    key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    
    // Wait for 100 ns for the decryption to complete
    #100;
    
    // Expected msg
    assert(msg === 128'h6bc1bee22e409f96e93d7e117393172a) else $error("Test failed: decryption mismatch");
    
    $display("Test successful");
    $finish;
  end

endmodule