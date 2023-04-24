module add #(parameter sz = 8)
(
    input [sz-1:0] a,
    input [sz-1:0] b,
    output [sz-1:0] c
);
assign c=a^b;
endmodule