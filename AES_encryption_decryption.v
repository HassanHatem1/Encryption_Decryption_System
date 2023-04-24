module AES_encryption_decryption #(
    parameter nk=8,parameter nb=4,parameter nr=14
) (
    input [8*4*nb-1:0]msg,
    input [(32*nk)-1:0]key,
    output [8*4*nb-1:0]cipher,
    output [8*4*nb-1:0]msgout
);
/**force msg 16#ccddeeff8899aabb4455667700112233
force key 16#0c0d0e0f08090a0b0405060700010203
*/
    wire [(32*nb*(nr+1))-1:0]w;
    keyExpansion #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) keyExpansion_inst (
        .key(key),
        .w(w)
    );
    encryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) encryption_inst (
        .msg(msg),
        .w(w),
        .cipher(cipher)
    );
    decryption #(
        .nk(nk),
        .nb(nb),
        .nr(nr)
    ) decryption_inst (
        .chiper(cipher),
        .w(w),
        .msg(msgout)
    );
endmodule