`timescale 1ns / 1ps

module  AES_tb();

//**********************************************************************//
// Generate random messages and keys
localparam period = 4;

parameter num = 6; // Number of messages and keys to generate

reg [31:0] mes [3:0]; // for 128 bit message
reg [31:0] k1 [3:0]; // for 128 bit key
reg [31:0] k2 [5:0]; // for 192 bit key
reg [31:0] k3 [7:0]; // for 256 bit key
reg [127:0] messages [num-1:0];
reg [127:0] keys_128 [num-1:0];
reg [191:0] keys_192 [num-1:0];
reg [255:0] keys_256 [num-1:0];

integer i,j;

parameter nk = 8;
reg clk,rst;
wire cs_encrypt;
wire cs_decrypt;
wire Miso1;
wire Mosi1;
wire Miso2;
wire Mosi2;
//wire rst;
wire out_clk;
wire out_clk2;
reg [127:0]from_Real_msgin;
reg [(32*4)-1:0]from_Real_keyin;
wire [127:0]Sipo_Registerin;
reg [127:0]to_dec;
wire [127:0]to_Real_msgout;

integer success = 0;
integer fail = 0;

always #(period/2) clk=~clk;

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

  clk = 1;
 
  rst = 1;
  #(10*period) rst = 0;

    for (i=0; i<num; i=i+1)
    begin
      from_Real_msgin = messages[i];
      from_Real_keyin = keys_128[i];
      #(1600*period)
      $display("case: %d generated output: %0h actual output: %0h\n",i+1,to_Real_msgout,messages[i]);
      if (to_Real_msgout == messages[i])
        begin
          success = success + 1;
          $display("Encryption successful");
          $display("Success Count=   ",success);
        end
      else 
        begin
          fail = fail + 1;
          $display("Error in encryption");
          $display("Fail Count=   ",fail);
        end
      /*from_Real_keyin = keys_192[i];
      #100;
      from_Real_keyin = keys_256[i];
      #100;*/
    end

   end
//**********************************************************************//

Master #(
        .nk(4),
        .nb(4),
        .nr(10)
    ) Master_inst1 (
        .Miso(Miso1),
        .rst(rst),
        .out_clk(out_clk),
        .from_Real_msg(from_Real_msgin),
        .from_Real_key(from_Real_keyin),
        .in_clk(clk),
        .cs_enc_dec(cs_encrypt),
        .Mosi(Mosi1),
        .Sipo_Register(Sipo_Registerin)
    );
    encryption_unit #(
        .nk(4),
        .nb(4),
        .nr(10)
    ) encryption_unit_inst1 (
        .clk(clk),
        .Mosi(Mosi1),
        .rst(rst),
        .cs_enc(cs_encrypt),
        .Miso(Miso1)
    );

    
    Master #(
        .nk(4),
        .nb(4),
        .nr(10)
    ) Master_inst2 (
        .Miso(Miso2),
        .rst(rst),
        .out_clk(out_clk2),
        .from_Real_msg(to_dec),
        .from_Real_key(from_Real_keyin),
        .in_clk(clk),
        .cs_enc_dec(cs_decrypt),
        .Mosi(Mosi2),
        .Sipo_Register(to_Real_msgout)
    );
    decryption_unit #(
        .nk(4),
        .nb(4),
        .nr(10)
    ) decryption_unit_inst2 (
        .clk(clk),
        .Mosi(Mosi2),
        .rst(rst),
        .cs_dec(cs_decrypt),
        .Miso(Miso2)
    );
    always @(posedge clk)
    begin
        if(cs_encrypt==1)
            to_dec<=Sipo_Registerin;
    end

endmodule