`timescale 1ns / 1ps

module aes_tb();

  reg rst;

  // Inputs
  reg [127:0] msg;
  reg [127:0] w;
  reg [127:0] key;
  reg [127:0] encrypt_msg;
  
  // Outputs
  wire [127:0] cipher;
  
  encryption aes_inst(
    //.clk(clk),
    //.rst(rst),
    .msg(msg),
    .w(w),
    .key(key),
    .cipher(cipher)
  );
  decryption aes_inst2(
    //.clk(clk),
    //.rst(rst),
    .msg(cipher),
    .w(w),
    .key(key),
    .cipher(msg)
  );
  
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