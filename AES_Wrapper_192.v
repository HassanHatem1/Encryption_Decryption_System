module AES_Wrapper_192  (
    output led,
    input clk,
    input rst
);
wire cs_encrypt;
wire cs_decrypt;
wire Miso1;
wire Mosi1;
wire Miso2;
wire Mosi2;
wire out_clk;
wire out_clk2;
reg [8*4*4-1:0]from_Real_msgin=128'h00112233445566778899aabbccddeeff;
reg [(32*6)-1:0]from_Real_keyin=192'h000102030405060708090a0b0c0d0e0f1011121314151617;
wire [8*4*4-1:0]Sipo_Registerin;
reg [8*4*4-1:0]to_dec;
wire [8*4*4-1:0]to_Real_msgout;
wire out_valid_eu;
wire in_valid_eu;

wire out_valid_dec;
wire in_valid_dec;

reg valid_dec_data=0;
assign led=(to_Real_msgout==from_Real_msgin)?1'b1:1'b0;
//wire [8*4*4-1:0]cipher=0;
Master #(
        .nk(6),
        .nb(4),
        .nr(12)
    ) Master_inst1 (
        .Miso(Miso1),
        .rst(rst),
        .out_clk(out_clk),
        .from_Real_msg(from_Real_msgin),
        .from_Real_key(from_Real_keyin),
        .valid_curr_data(1'b1),
        .in_valid(out_valid_eu),
        .out_valid(in_valid_eu),
        .in_clk(clk),
        .cs_enc_dec(cs_encrypt),
        .Mosi(Mosi1),
        .Sipo_Register(Sipo_Registerin)
    );
    encryption_unit #(
        .nk(6),
        .nb(4),
        .nr(12)
    ) encryption_unit_inst1 (
        .clk(clk),
        .Mosi(Mosi1),
        .rst(rst),
        .cs_enc(cs_encrypt),
        .Miso(Miso1),
        .in_valid(in_valid_eu),
        .out_valid(out_valid_eu)
    );
    wire ttt;
    
   Master #(
        .nk(6),
        .nb(4),
        .nr(12)
    ) Master_inst2 (
        .Miso(Miso2),
        .rst(rst),
        .out_clk(out_clk2),
        .from_Real_msg(to_dec),
        .from_Real_key(from_Real_keyin),
        .valid_curr_data(valid_dec_data),
        .in_valid(out_valid_dec),
        .out_valid(ttt),
        .in_clk(clk),
        .cs_enc_dec(cs_decrypt),
        .Mosi(Mosi2),
        .Sipo_Register(to_Real_msgout)
    );
    decryption_unit #(
        .nk(6),
        .nb(4),
        .nr(12)
    ) decryption_unit_inst2 (
        .clk(clk),
        .Mosi(Mosi2),
        .rst(rst),
        .cs_dec(cs_decrypt),
        .Miso(Miso2),
        .in_valid(ttt),
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