`timescale 1ns / 1ps

module  AES_128_tb();

//**********************************************************************//
localparam period = 4;

parameter nk = 4;

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
reg [127:0]from_Real_keyin_128;
wire [127:0]Sipo_Registerin;
reg [127:0]to_dec;
wire [127:0]to_Real_msgout;
wire out_valid_eu;
wire in_valid_eu;
wire v_dec;
wire out_valid_dec;
wire in_valid_dec;

reg valid_dec_data=0;

integer success = 0;
integer fail = 0;

always #(period/2) clk=~clk;

initial begin
  clk = 1;
 
  rst = 1;
  #(10*period) rst = 0;

  //*****************************************************************//
  //Test Case 1
  from_Real_msgin = 128'h00112233445566778899aabbccddeeff;
  from_Real_keyin_128 = 128'h000102030405060708090a0b0c0d0e0f;
    
  #(1000*period);
  $display("Test Case 1:");
  if (Sipo_Registerin == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h69c4e0d86a7b0430d8cdb78070b4c55a,Sipo_Registerin);
      $display("Encryption successful");
    end
  else
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h69c4e0d86a7b0430d8cdb78070b4c55a,Sipo_Registerin);
      $display("Encryption failed");
    end
  
    
  #(1000*period);
  
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

  
  from_Real_msgin = 128'hc9ec0c24fad05d6fec9516ebee689c53;
  from_Real_keyin_128 = 128'he5b3bff1eb0c99fcee48f846b250aea0;
    
  #(5000*period);
  $display("Test Case 2:");
  if (Sipo_Registerin == 128'he8f9b645e48a3dd7a5d6c49fb8a65e7a)
    begin
       $display("Encryption Expected output: %h Actual output: %h",128'he8f9b645e48a3dd7a5d6c49fb8a65e7a,Sipo_Registerin);
       $display("Encryption successful");
    end
  else
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'he8f9b645e48a3dd7a5d6c49fb8a65e7a,Sipo_Registerin);
      $display("Encryption failed");
    end
  
    
  #(1000*period);
   
  if (to_Real_msgout == 128'hc9ec0c24fad05d6fec9516ebee689c53)
    begin
      success = success + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'hc9ec0c24fad05d6fec9516ebee689c53,to_Real_msgout);
      $display("Decryption successful");
    end
  else
    begin
      fail = fail + 1;
      $display("Decryption Expected output: %h Actual output: %h",128'hc9ec0c24fad05d6fec9516ebee689c53,to_Real_msgout);
      $display("Decryption failed");
    end  

  //*****************************************************************//
  //Test Case 3
  #(10*period);

  from_Real_msgin = 128'ha1900a43bed5ef6ec612027dfea3d046;
  from_Real_keyin_128 = 128'hf1490189f64b279ea698616fbee53bc3;

  #(5000*period);
  $display("Test Case 3:");
  if (Sipo_Registerin == 128'h797aae20aa15a2024ab56e70fc457cfc)
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h797aae20aa15a2024ab56e70fc457cfc,Sipo_Registerin);
      $display("Encryption successful");
    end
  else
    begin
      $display("Encryption Expected output: %h Actual output: %h",128'h797aae20aa15a2024ab56e70fc457cfc,Sipo_Registerin);
      $display("Encryption failed");
    end

  #(1000*period);

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
//*********************128 bit key and message**************************//
Master #(
        .nk(4),
        .nb(4),
        .nr(10)
    ) Master_inst1 (
        .Miso(Miso1),
        .rst(rst),
        .out_clk(out_clk),
        .from_Real_msg(from_Real_msgin),
        .from_Real_key(from_Real_keyin_128),
        .valid_curr_data(1'b1),
        .in_valid(out_valid_eu),
        .out_valid(in_valid_eu),
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
        .Miso(Miso1),
        .in_valid(in_valid_eu),
        .out_valid(out_valid_eu)
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
        .from_Real_key(from_Real_keyin_128),
        .valid_curr_data(valid_dec_data),
        .in_valid(out_valid_dec),
        .out_valid(v_dec),
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