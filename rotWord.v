module rotWord (
    input [31:0]in,
    output reg[31:0]out
);
    always@* out={in[23:0],in[31:24]};
endmodule