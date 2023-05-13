module Subnode #( 
    parameter nk=8,parameter nb=4,parameter nr=14
)(
input sdi ,		//1-bit input from Master World subnode data in
//input in_real_key ,		//1-bit input from Master World
input in_clk ,		//1-bit input from clock from Master World
input [8*4*nb-1:0]from_enc_dec_msg,		//128-bit input from slave(Enc/dyc)
//input [((32*nk))-1:0]from_enc_dec_key,        //128-bit input from slave(Enc/dyc)
input cs ,           //1-bit input from Master World
input rst,
output reg sdo ,		//1-bit output to Master World subnode data out
//output reg out_real_key ,		//1-bit output to Master World
output reg [8*4*nb-1:0]to_enc_dec_msg,		//generic bit output to slave(Enc/dyc)
output reg [((32*nk))-1:0]to_enc_dec_key,        //generic bit output to slave(Enc/dyc)
output reg data_done             //1-bit output to slaves

); // End of port list
//------------Code Starts Here-------------------------
integer countmsg;
integer countkey;
integer countmsgout;
integer countencdec;
reg [8*4*nb-1:0]Sipo_Register;
reg [((32*nk))-1:0]Key_Register;
reg [8*4*nb-1:0]Piso_Register;
reg dataready;
reg snow;
reg once;
always @(rst)
begin
    once=1;
end
always @(negedge cs)
begin
Sipo_Register<=0;
Key_Register<=0;
Piso_Register<=0;
countmsg<=0;
countkey<=0;
countmsgout<=8*4*nb-1;
data_done<=0;
dataready<=0;
countencdec<=0;
snow<=1;
end

always @(negedge in_clk )
begin

if(!cs && (once || !snow))
begin
if(countmsg<=8*4*nb-1)
begin
countmsg<=countmsg+1;
Sipo_Register={Sipo_Register[8*4*nb-2:0],sdi};
end
else if(countmsg==8*4*nb && countkey<=(32*nk)-1)
begin
Key_Register={Key_Register[((32*nk))-2:0],sdi};
countkey<=countkey+1;
end
else if(countmsg==8*4*nb && countkey==(32*nk) && !dataready)
begin
countencdec<=countencdec+1;
end
if(countencdec==20)
begin
Piso_Register<=from_enc_dec_msg;
dataready<=1;
countencdec<=0;
end
end
else
begin
    snow<=0;
    once<=0;
end
end

always @(negedge in_clk)
begin
if(countmsg ==8*4*nb && countkey==(32*nk) &&!cs)
begin
to_enc_dec_msg<=Sipo_Register;
to_enc_dec_key<=Key_Register;
end
end

always @(negedge in_clk)
begin
if(countmsgout >=0 && dataready && !cs)
begin
data_done<=1;
sdo<=Piso_Register[countmsgout];
countmsgout<=countmsgout-1;
end
if (countmsgout==-1 && !cs)
begin
data_done<=0;
dataready<=0;
sdo=0;
end
end


endmodule