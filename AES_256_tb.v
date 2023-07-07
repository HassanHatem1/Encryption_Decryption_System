`timescale 1ns / 1ps

module  AES_256_tb();

//**********************************************************************//
localparam period = 4;

parameter nk = 8;
reg clk,rst;

wire cs_encrypt;
wire cs_decrypt;
wire Miso1;
wire Mosi1;
wire Miso2;
wire Mosi2;
wire out_clk;
wire out_clk2;
reg [127:0]from_Real_msgin;
reg [255:0]from_Real_keyin_256;
wire [127:0]Sipo_Registerin;
reg [127:0]to_dec;
wire [127:0]to_Real_msgout;
wire out_valid_eu;
wire in_valid_eu;
wire out_valid_dec;
wire in_valid_dec;
wire v_dec;

reg valid_dec_data=0;

integer success = 0;
integer fail = 0;

always #(period/2) clk=~clk;

initial begin
  clk = 1;
 
  rst = 1;
  #(10*period) rst = 0;

//*****************************************************************//
  from_Real_msgin = 128'h00112233445566778899aabbccddeeff;
  from_Real_keyin_256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    
  #(10000*period);
  $display("Test Case 1");
  if (Sipo_Registerin == 128'h8ea2b7ca516745bfeafc49904b496089)
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h8ea2b7ca516745bfeafc49904b496089,Sipo_Registerin);
      $display("Encryption successful");
    end
  else
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h8ea2b7ca516745bfeafc49904b496089,Sipo_Registerin);
      $display("Encryption failed");
    end
  

  #(10000*period);
    
  if (to_Real_msgout == 128'h00112233445566778899aabbccddeeff)
    begin
      success = success + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'h00112233445566778899aabbccddeeff,to_Real_msgout);
      $display("Decryption successful");
    end
  else
    begin
      fail = fail + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'h00112233445566778899aabbccddeeff,to_Real_msgout);
      $display("Decryption failed");
    end  

//*****************************************************************//
//Test Case 2
#(10*period);

  from_Real_msgin = 128'hfcf72a0bff39eefeff73f162b3d8e8d3;
  from_Real_keyin_256 = 256'hfcc8e72aa0493c3fc37afdf0f5316e89d8f118f8aa7909a2c1d2966e9c096454;
    
  #(10000*period);
  $display("Test Case 2");
  if (Sipo_Registerin == 128'h15f31d48a0b00824c49ca22564b9fa4d)
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h15f31d48a0b00824c49ca22564b9fa4d,Sipo_Registerin);
      $display("Encryption successful");
    end
  else
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h15f31d48a0b00824c49ca22564b9fa4d,Sipo_Registerin);
      $display("Encryption failed");
    end
  
    
  #(10000*period);
    
  if (to_Real_msgout == 128'hfcf72a0bff39eefeff73f162b3d8e8d3)
    begin
      success = success + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'hfcf72a0bff39eefeff73f162b3d8e8d3,to_Real_msgout);
      $display("Decryption successful");
    end
  else
    begin
      fail = fail + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'hfcf72a0bff39eefeff73f162b3d8e8d3,to_Real_msgout);
      $display("Decryption failed");
    end  
  
//*****************************************************************//
//Test Case 3
#(10*period);

from_Real_msgin = 128'ha1900a43bed5ef6ec612027dfea3d046;
from_Real_keyin_256 = 256'h924245ef8e6ac788c5ff0064946b6b9bcae98271a0db5cecb46effb6909b40b2;
    
  #(10000*period);
  $display("Test Case 3");
  if (Sipo_Registerin == 128'hee04ae61eb6cce35f9e135e90ff4193c)
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'hee04ae61eb6cce35f9e135e90ff4193c,Sipo_Registerin);
      $display("Encryption successful");
    end
  else
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'hee04ae61eb6cce35f9e135e90ff4193c,Sipo_Registerin);
      $display("Encryption failed");
    end
  
    
  #(10000*period);
    
  if (to_Real_msgout == 128'ha1900a43bed5ef6ec612027dfea3d046)
    begin
      success = success + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'ha1900a43bed5ef6ec612027dfea3d046,to_Real_msgout);
      $display("Decryption successful");
    end
  else
    begin
      fail = fail + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'ha1900a43bed5ef6ec612027dfea3d046,to_Real_msgout);
      $display("Decryption failed");
    end  
    
  $display("Total success Count= %d out of %d cases ",success,3);
  $display("Total fail Count= %d out of %d cases",fail,3);
end
//**********************************************************************//
//*********************256 bit key and message**************************//
Master #(
        .nk(8),
        .nb(4),
        .nr(14)
    ) Master_inst3 (
        .Miso(Miso1),
        .rst(rst),
        .out_clk(out_clk2),
        .from_Real_msg(from_Real_msgin),
        .from_Real_key(from_Real_keyin_256),
        .valid_curr_data(1'b1),
        .in_valid(out_valid_eu),
        .out_valid(in_valid_eu),
        .in_clk(clk),
        .cs_enc_dec(cs_encrypt),
        .Mosi(Mosi1),
        .Sipo_Register(Sipo_Registerin)
    );
    encryption_unit #(
        .nk(8),
        .nb(4),
        .nr(14)
    ) encryption_unit_inst3 (
        .clk(clk),
        .Mosi(Mosi1),
        .rst(rst),
        .cs_enc(cs_encrypt),
        .Miso(Miso1),
        .in_valid(in_valid_eu),
        .out_valid(out_valid_eu)
    );
    
   Master #(
        .nk(8),
        .nb(4),
        .nr(14)
    ) Master_inst2 (
        .Miso(Miso2),
        .rst(rst),
        .out_clk(out_clk2),
        .from_Real_msg(to_dec),
        .from_Real_key(from_Real_keyin_256),
        .valid_curr_data(valid_dec_data),
        .in_valid(out_valid_dec),
        .out_valid(v_dec),
        .in_clk(clk),
        .cs_enc_dec(cs_decrypt),
        .Mosi(Mosi2),
        .Sipo_Register(to_Real_msgout)
    );
    decryption_unit #(
        .nk(8),
        .nb(4),
        .nr(14)
    ) decryption_unit_inst2 (
        .clk(clk),
        .Mosi(Mosi2),
        .rst(rst),
        .cs_dec(cs_decrypt),
        .Miso(Miso2),
        .in_valid(v_dec),
        .out_valid(out_valid_dec)
    );
    
    always @(negedge clk)
    begin
        if(cs_encrypt==1 && rst==0)
        begin 
                valid_dec_data<=1;
                to_dec<=Sipo_Registerin;
        end
    end
endmodule