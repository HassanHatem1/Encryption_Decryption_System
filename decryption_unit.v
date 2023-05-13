module decryption_unit #(
    parameter nk=8,parameter nb=4,parameter nr=14
) (
    input clk,
    input Mosi,
    input rst,
    input cs_enc,
    output data_done,
    output Miso
);

    wire [8*4*nb-1:0]msg;
    wire [(32*nk)-1:0]key;
    wire [8*4*nb-1:0]cipher;
    wire [8*4*nb-1:0]msgout;
    wire [8*4*nb-1:0]from_enc_dec_msg;
    wire [((32*nk))-1:0]to_enc_dec_key;
    
    Subnode #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) Subnode_inst (
        .sdi(Mosi),
        .rst(rst),
        .in_clk(clk),
        .from_enc_dec_msg(from_enc_dec_msg),
        .to_enc_dec_key(to_enc_dec_key),
        .cs(cs_enc),
        .sdo(Miso),
        .to_enc_dec_msg(msg),
        .data_done(data_done)
    );
    decryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) decryption_inst (
        .in_chiper(msg),
        .w(w),
        .out_msg(from_enc_dec_msg)
    );
    keyExpansion #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) keyExpansion_inst (
        .in_key(to_enc_dec_key),
        .w(w)
    );

endmodule