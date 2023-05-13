module AES_Wrapper  (
    output led1,
    output led2,
    output led3
);
wire data_done1;
wire data_done2;
Master #(
        .nk(4)),
        .nb(6),
        .nr(8)
    ) Master_inst1 (
        .Miso(Miso),
        .rst(rst),
        .out_clk(out_clk),
        .from_Real_msg(from_Real_msgin),
        .from_Real_key(from_Real_keyin),
        .data_done(data_done),
        .in_clk(clk),
        .cs_enc_dec(cs_enc_dec),
        .Mosi(Mosi),
        .Sipo_Register(Sipo_Registerin)
    );
    encryption_unit #(
        .nk(4),
        .nb(6),
        .nr(8)
    ) encryption_unit_inst1 (
        .clk(clk),
        .Mosi(Mosi),
        .rst(rst),
        .cs_enc(cs_enc_dec),
        .data_done(data_done),
        .Miso(Miso)
    );

endmodule