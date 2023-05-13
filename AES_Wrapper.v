module AES_Wrapper  (
    output led1,
    output led2,
    output led3,
    input clk
);
wire cs_encrypt;
wire cs_decrypt;
wire Miso1;
wire Mosi1;
wire Miso2;
wire Mosi2;
wire rst;
wire out_clk;
wire out_clk2;
wire [8*4*4-1:0]from_Real_msgin=128'h00112233445566778899aabbccddeeff;
wire [(32*4)-1:0]from_Real_keyin=128'h000102030405060708090a0b0c0d0e0f;
wire [8*4*4-1:0]Sipo_Registerin;
reg [8*4*4-1:0]to_dec;
wire [8*4*4-1:0]to_Real_msgout;
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