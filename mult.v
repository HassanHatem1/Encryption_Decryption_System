module mult #(parameter sz = 8)
(
    input [sz-1:0] a,
    input [sz-1:0] b,
    output [sz-1:0] c
);
reg [sz:0]tmp;
reg [sz-1:0]res;
integer i;
always @(a,b)
begin
    tmp={1'b0,a};
    res=0;
    for(i=0;i<sz;i=i+1)
    begin
    if(b[i]==1)
    begin
    res=res^tmp[sz-1:0];
    end
    tmp=tmp<<1;
    if(tmp[sz]==1)
    begin
        tmp=tmp^9'h11b;
    end
    end
end

assign c=res;
endmodule