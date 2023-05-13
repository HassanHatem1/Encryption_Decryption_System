module Master #( 
    parameter nk=8,parameter nb=4,parameter nr=14
)(
input  Miso ,		//1-bit input from  slave  
   
input [8*4*nb-1:0]from_Real_msg,	//the message in the computer side	
input [(32*nk)-1:0]from_Real_key,   //the key in the computer side

input mode_select, //0 for encryption, 1 for decryption

input data_done_1,                    //strobe from subnode
input data_done_2,                    //strobe from subnode

input in_clk, //needs to be generated
input rst, //reset

output  out_clk ,		//1-bit input from clock from  slave
output reg cs_enc ,           //1-bit chip select output to  encrypt slave  
output reg cs_dec,           //1-bit chip select output to  decrypt slave
output reg Mosi ,		//1-bit output to  slave  

output reg [8*4*nb-1:0]Sipo_Register		//generic bit output to slave(Enc/dyc)



); // End of port list
//------------Code Starts Here-------------------------

integer countmsg;
integer countmsgout;

reg [8*4*nb+(32*nk)-1:0]Piso_Register;
reg dataready;
reg data_done;
reg cs_enc_dec;
////////

assign out_clk=in_clk;
always @(cs_enc_dec)
begin
    if(mode_select==0)
    begin
        cs_enc<=cs_enc_dec;
        cs_dec<=1;
    end
    else
    begin
        cs_enc<=1;
        cs_dec<=cs_enc_dec;
    end
end
/*
always @(in_clk)
begin
    out_clk<=in_clk;
end
*/
always @(data_done_1,data_done_2)
begin
    if(mode_select==0)
        data_done=data_done_1;
    else
        data_done=data_done_2;
end

always @(from_Real_msg , from_Real_key)
begin
Piso_Register<={from_Real_msg,from_Real_key};
Sipo_Register<=0;
countmsg<=0;
countmsgout<=8*4*nb+(32*nk)-1;//might need change 
dataready<=0;
cs_enc_dec<=0;
end
////////
always @(negedge data_done)
begin
    cs_enc_dec<=1;
end
always @(negedge rst)
begin 
    cs_enc_dec<=0;
end
///////
always @(posedge in_clk, posedge rst)
begin
if(rst)
begin
Sipo_Register<=0;
countmsg<=0;
countmsgout<=8*4*nb+(32*nk)-1;//might need change 
dataready<=0;
cs_enc_dec<=1;
end
else 
if(countmsg<=8*4*nb-1 && data_done==1)
begin
countmsg<=countmsg+1;
Sipo_Register<={Sipo_Register[8*4*nb-2:0], Miso};
end

end

always @(posedge in_clk)
begin
if(countmsgout >=0)
begin
Mosi<=Piso_Register[countmsgout];
countmsgout<=countmsgout-1;
end
if (countmsgout==-1)
begin
dataready<=0;
Mosi<=1'bz;
end
end
////

endmodule