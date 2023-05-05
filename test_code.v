module test_code (
    input [3:0]a,
    input [3:0]b,
    output reg [3:0]c
);
function [3:0] addd;
input [3:0] a,b;
begin
  addd = a+b;
end
endfunction
    always @(a,b)
    begin
        c=addd(a,b);
    end
endmodule