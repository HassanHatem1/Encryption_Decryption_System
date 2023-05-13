module AES_encryption_decryption #(
    parameter nk=4,parameter nb=4,parameter nr=10
) (
    output reg res
);
/**force msg 16#ccddeeff8899aabb4455667700112233
force key 16#0c0d0e0f08090a0b0405060700010203
*/
    wire [8*4*nb-1:0]msg=128'h00112233445566778899aabbccddeeff;
    wire [(32*nk)-1:0]key=128'h000102030405060708090a0b0c0d0e0f;
    wire [8*4*nb-1:0]msgout;
    wire [(32*nb*(nr+1))-1:0]w;
    wire [8*4*nb-1:0]cipher;
    always @(*)
    begin
    res=(msg==msgout);
    end
    keyExpansion #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) keyExpansion_inst (
        .in_key(key),
        .w(w)
    );
    encryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) encryption_inst (
        .in_msg(msg),
        .w(w),
        .out_cipher(cipher)
    );
    decryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) decryption_inst (
        .in_chiper(cipher),
        .w(w),
        .out_msg(msgout)
    );
endmodule