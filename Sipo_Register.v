module Sipo_Register #(
    parameter nk=8,parameter nb=4,parameter nr=14
)(
input in_real_msg ,		//1-bit input from Outer World
input in_real_key ,		//1-bit input from Outer World
input in_clk ,		//1-bit input from clock from Outer World
input en ,		//1-bit input from Outer World
input rst ,		//1-bit input from Outer World
input [8*4*nb-1:0]in_slave_msg,		//128-bit input from slave(Enc/dyc)
//input [(32*nb*(nr+1))-1:0]in_slave_key,        //128-bit input from slave(Enc/dyc)
input Miso,			//1-bit output to slave(Enc/dyc) strobe

output reg out_real_msg ,		//1-bit output to Outer World
//output reg out_real_key ,		//1-bit output to Outer World
output reg out_clk,             //1-bit output to slaves 
output reg [8*4*nb-1:0]out_slave_msg,		//generic bit output to slave(Enc/dyc)
output reg [(32*nb*(nr+1))-1:0]out_slave_key,        //generic bit output to slave(Enc/dyc)
output reg mosi

); // End of port list
//------------Code Starts Here-------------------------
integer countmsg;
integer countkey;
integer countmsgout;
reg [8*4*nb-1:0]Sipo_Register;
reg [(32*nb*(nr+1))-1:0]Key_Register;
reg [8*4*nb-1:0]Piso_Register;
reg dataready;
always @(posedge in_clk or posedge rst)
begin
if(rst)
begin
Sipo_Register<=0;
Key_Register<=0;
Piso_Register<=0;
countmsg<=0;
countkey<=0;
mosi<=0;
countmsgout<=8*4*nb-1;
dataready<=0;
end
else
begin
if(en && posedge in_clk && countmsg>=0 && countkey<8*4*nb )
begin
countmsg<=countmsg+1;
Sipo_register<={Sipo_register[8*4*nb-2:0],in_real_msg};
end
else if(en && posedge in_clk && countkey>=8*4*nb && countkey<32*nb*(nr+1))
begin
Key_Register<={Key_Register[(32*nb*(nr+1))-2:0],in_real_key};
countkey<=countkey+1;
end
if(Miso)
begin
Piso_Register<=in_slave_msg;
dataready<=1;
end
end
end

always @(negedge in_clk)
begin
if(countmsg =8*4*nb && countkey=32*nb*(nr+1))
begin
mosi <=1;
out_slave_msg<=Sipo_Register;
out_slave_key<=Key_Register;
end
end

always @(negedge in_clk)
begin
if(countmsgout >0 && dataready)
begin
out_real_msg<=Piso_Register[8*4*nb-1];
Piso_Register<={Piso_Register[8*4*nb-2:0],1'b0};
countmsgout<=countmsgout-1;
end
end
endmodule