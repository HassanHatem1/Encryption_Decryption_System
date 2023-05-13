module AES_Wrapper  (
    output led1,
    output led2,
    output led3,
    input clk
);
wire cs_encrypt;
wire Miso1;
wire Mosi1;
wire rst;
wire [8*4*4-1:0]from_Real_msgin=128'h00112233445566778899aabbccddeeff;
wire [(32*4)-1:0]from_Real_keyin=128'h000102030405060708090a0b0c0d0e0f;
wire [8*4*4-1:0]Sipo_Registerin;
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

endmodule