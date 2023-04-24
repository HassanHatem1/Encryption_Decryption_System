module subWord(
    input [31:0]in,
    output [31:0]out
);
subByte sub1(in[7:0],out[7:0]);
subByte sub2(in[15:8],out[15:8]);
subByte sub3(in[23:16],out[23:16]);
subByte sub4(in[31:24],out[31:24]);
endmodule