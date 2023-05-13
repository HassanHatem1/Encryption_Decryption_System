module Subnode #( 
    parameter nk=8,parameter nb=4,parameter nr=14
)(
input sdi ,		                        //1-bit input from Master World subnode data in
input in_clk ,		                    //1-bit input from clock from Master World
input [8*4*nb-1:0]from_enc_dec_msg,		//128-bit input from slave(Enc/dyc)
input cs ,                              //1-bit input from Master World
input rst,

output reg sdo ,		                //1-bit output to Master World subnode data in
output reg [8*4*nb-1:0]to_enc_dec_msg,	//generic bit output to slave(Enc/dyc)
output reg [((32*nk))-1:0]to_enc_dec_key//generic bit output to slave(Enc/dyc)

); 

integer countmsg;
integer countkey;
integer countmsgout;
integer countencdec;
reg [8*4*nb-1:0]Piso_Register;
reg snow;
reg once;

always @(rst)
begin
    once=1;
end
always @(negedge cs)
begin
    to_enc_dec_msg<=0;
    to_enc_dec_key<=0;
    Piso_Register<=0;
    countmsg<=0;
    countkey<=0;
    countmsgout<=8*4*nb-1;
    countencdec<=0;
    snow<=0;
end

always @(negedge in_clk)
begin

    if(!cs && (!snow) && !rst)
    begin
        if(countmsg<=8*4*nb-1)
            begin
                countmsg=countmsg+1;
                to_enc_dec_msg={to_enc_dec_msg[8*4*nb-2:0],sdi};
            end
        else
        if(countmsg==8*4*nb && countkey<=(32*nk)-1)
            begin
                to_enc_dec_key={to_enc_dec_key[((32*nk))-2:0],sdi};
                countkey<=countkey+1;
            end
        else 
        if(countmsg==8*4*nb && countkey==(32*nk))
            begin
                Piso_Register=from_enc_dec_msg;
            end
        if(countmsgout >=0 && !cs && countmsg==8*4*nb && countkey==(32*nk))
            begin
                sdo<=Piso_Register[countmsgout];
                countmsgout<=countmsgout-1;
            end
        else
                sdo=1'bZ;
    end
    else
        begin
            snow=0;
            once=0;
        end
    end

endmodule