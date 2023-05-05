module lsb_msb_handler #(
    parameter words_cnt=4
) (
    input [words_cnt*4*8-1:0]in,
    output reg [words_cnt*4*8-1:0]out
);
    integer word;
    integer i;
    always @(in)
    begin
        for(word=1;word<=words_cnt;word=word+1)
        begin
            for(i=0;i<32;i=i+1)
            begin
                out[word*32-i-1]=in[words_cnt*32-(i+(word-1)*32)-1];
            end
        end
    end
endmodule