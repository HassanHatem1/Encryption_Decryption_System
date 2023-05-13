module AES_SPI_Test #(
    parameter nk=8,parameter nb=4,parameter nr=14
) (
    input clk
);
reg rst=1;
wire [8*4*nb-1:0]msg;
wire [(32*nk)-1:0]key;
wire [8*4*nb-1:0]cipher;
wire [8*4*nb-1:0]msgout;
integer counter=32'd1000;
/**force msg 16#ccddeeff8899aabb4455667700112233
force key 16#0c0d0e0f08090a0b0405060700010203
*/
    wire [(32*nb*(nr+1))-1:0]w;
    wire Miso;
    wire out_clk;
    reg [8*4*nb-1:0]from_Real_msgin;
    wire [(32*nk)-1:0]from_Real_keyin;
    wire data_done_1;
    wire data_done_2;
    wire cs_enc_dec;
    wire Mosi;
    wire [8*4*nb-1:0]Sipo_Registerin;
    wire [8*4*nb-1:0]from_enc_dec_msg;
    wire [((32*nk))-1:0]to_enc_dec_key;
    wire [((32*nk))-1:0]to_enc_dec_key1;
    wire cs_enc;
    wire cs_dec;
    reg mode_select=0;

    Master #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) Master_inst (
        .Miso(Miso),
        .rst(rst),
        .out_clk(out_clk),
        .from_Real_msg(from_Real_msgin),
        .from_Real_key(from_Real_keyin),
        .data_done_1(data_done_1),
        .data_done_2(data_done_2),
        .in_clk(clk),
        .cs_enc(cs_enc),
        .cs_dec(cs_dec),
        .Mosi(Mosi),
        .Sipo_Register(Sipo_Registerin),
        .mode_select(mode_select)
    );
    Subnode #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) Subnode_inst_encryption (
        .sdi(Mosi),
        .rst(rst),
        .in_clk(out_clk),
        .from_enc_dec_msg(from_enc_dec_msg),
        .to_enc_dec_key(to_enc_dec_key),
        .cs(cs_enc),
        .sdo(Miso),
        .to_enc_dec_msg(msg),
        .data_done(data_done_1)
    );
    encryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) encryption_inst (
        .in_msg(msg),
        .w(w),
        .out_cipher(from_enc_dec_msg)
    );
    keyExpansion #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) keyExpansion_inst (
        .in_key(to_enc_dec_key),
        .w(w)
    );
    
    always @(posedge clk)
    begin
        if(counter==32'd999)
            rst=0;
        if(counter>0)
            counter=counter-1;
        else
        begin
            mode_select=1;
            from_Real_msgin=cipher;
        end        
    end
            
    Subnode #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) Subnode_inst_decryption (
        .sdi(Mosi),
        .rst(rst),
        .in_clk(out_clk),
        .from_enc_dec_msg(msgout),
        .to_enc_dec_key(to_enc_dec_key1),
        .cs(cs_dec),
        .sdo(Miso),
        .to_enc_dec_msg(chiper),
        .data_done(data_done_2)
    );/*
    decryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) decryption_inst (
        .in_chiper(cipher),
        .w(w),
        .out_msg(msgout)
    );*/
endmodule