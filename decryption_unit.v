module decryption_unit #(
    parameter nk=8,parameter nb=4,parameter nr=14
) (
    input clk,
    input Mosi,
    input rst,
    input cs_dec,
    input in_valid,
    output out_valid,
    output Miso
);

    wire [8*4*nb-1:0]cipher;
    wire [8*4*nb-1:0]msg;
    wire [(32*nk)-1:0]key; 
    wire [((32*nk))-1:0]to_enc_dec_key;
    wire [(32*nb*(nr+1))-1:0]w_out;
    reg [(32*nb*(nr+1))-1:0]w_in;

    reg in_valid_data;
    wire out_valid_ke;
    wire out_valid_en;
    reg in_valid_enc=0;
    reg in_valid_ke;
    reg processing=0;
    reg valid_curr_data=0;

     Subnode #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) Subnode_inst (
        .rst(rst),
        .sdi(Mosi),
        .in_clk(clk),
        .from_enc_dec_msg(msg),
        .valid_curr_data(valid_curr_data),
        .cs(cs_dec),
        .sdo(Miso),
        .in_valid(in_valid),
        .to_enc_dec_msg(cipher),
        .to_enc_dec_key(key),
        .out_valid(out_valid)
    );

    decryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) decryption_inst (
        .clk(clk),
        .cipher(cipher),
        .w(w_in),
        .in_valid(in_valid_enc),
        .out_valid(out_valid_en),
        .msg(msg)
    );

    keyExpansion #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) keyExpansion_inst (
        .key(key),
        .w(w_out),
        .clk(clk),
        .in_valid(in_valid_ke),
        .out_valid(out_valid_ke)
    );

    always @(posedge clk)
    begin
        in_valid_ke=!in_valid;
        if(in_valid==0&&processing==0&&out_valid_ke==1)
        begin
            processing=1;
        end
        if(processing==1&&out_valid_en==1)
        begin
            processing=0;
            valid_curr_data=1;
        end

        if(out_valid_ke==1)
        begin
             in_valid_enc<=0;
        end
        else
        begin
            w_in<=w_out;
            in_valid_enc<=1;
        end
    end

endmodule