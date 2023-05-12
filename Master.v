module Master #( 
    parameter nk=8,parameter nb=4,parameter nr=14
)(
input  Miso ,		//1-bit input from  slave  
//input in_real_key ,		//1-bit input from  slave  
input Out_clk ,		//1-bit input from clock from  slave  
input [8*4*nb-1:0]from_Real_msg,		
input [(32*nb*(nr+1))-1:0]from_Real_key 
//input [(32*nb*(nr+1))-1:0]from_enc_dec_key,        //128-bit input from slave(Enc/dyc)
//
input in_clk //needs to be generated
//
output reg cs_enc_dec ,           //1-bit output to  slave  
output reg Mosi ,		//1-bit output to  slave  
//output reg out_real_key ,		//1-bit output to  slave  
output reg [8*4*nb-1:0]Out_real_msg,		//generic bit output to slave(Enc/dyc)
       //generic bit output to slave(Enc/dyc)


); // End of port list
//------------Code Starts Here-------------------------

integer countmsg;
integer countmsgout_key;
integer countencdec;
reg [8*4*nb-1:0]Sipo_Register;
reg [8*4*nb-1+32*nb*(nr+1)-1:0]Piso_Register;
reg dataready;
////////
always @(from_Real_msg , from_Real_key )
begin
Sipo_Register<=0;
Piso_Register<=0;
countmsg<=0;
countmsgout<=8*4*nb-1+32*nb*(nr+1)-1;//might need change 
dataready<=0;
countencdec<=0;
end
////////

///////
always @(posedge in_clk )
begin
if(countmsg<=8*4*nb-1)
begin
countmsg<=countmsg+1;
Sipo_register<={Sipo_register[8*4*nb-2:0], Miso};
end
else if(countmsg==8*4*nb)
begin
countencdec<=countencdec+1;
end
if(countencdec==20)
begin
Out_real_msg<=Sipo_Register;
end
end
//////

assign Piso_Register<={from_Real_msg,from_Real_key};

////
always @(posedge in_clk)
begin
if(countmsgout >=0 && dataready)
begin
Mosi<=Piso_Register[countmsgout];
countmsgout<=countmsgout-1;
end
if (countmsgout==-1)
begin
dataready<=0;
end
end
////

endmodule