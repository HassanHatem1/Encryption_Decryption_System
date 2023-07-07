module Subnode #( 
    parameter nk=8,parameter nb=4,parameter nr=14
)(
input rst,
input sdi ,		                        //1-bit input from Master World subnode data in
input in_clk ,		                    //1-bit input from clock from Master World
input [8*4*nb-1:0]from_enc_dec_msg,		//128-bit input from slave(Enc/dyc)
input cs,                              //1-bit input from Master World

input valid_curr_data,
input in_valid,
output reg out_valid,

output reg sdo ,		                //1-bit output to Master World subnode data in
output reg [8*4*nb-1:0]to_enc_dec_msg,	//generic bit output to slave(Enc/dyc)
output reg [((32*nk))-1:0]to_enc_dec_key//generic bit output to slave(Enc/dyc)

); 

integer countmsg;
integer countkey;
integer countmsgout;
reg [8*4*nb-1:0]Piso_Register;

localparam idle = 2'b00;
localparam recieving = 2'b01;
localparam sending = 2'b10;
reg [1:0]state=idle;


always @(negedge in_clk)
begin
    if(rst==1)
    begin
        state=idle;
        Piso_Register=0;
    end
    if(!cs) 
        begin
            if(state==idle) begin
                if(in_valid==1) begin
                state=recieving;
                end
                else
                begin
                    out_valid<=0;
                    countmsg<=0;
                    countkey<=0;
                    countmsgout<=8*4*nb-1;
                end
            end

            if(state==recieving) begin
                if(in_valid==1) begin
                    if(countmsg<=8*4*nb-1)
                        begin
                            countmsg<=countmsg+1;
                            to_enc_dec_msg={to_enc_dec_msg[8*4*nb-2:0],sdi};
                        end
                    else
                        begin
                            to_enc_dec_key={to_enc_dec_key[((32*nk))-2:0],sdi};
                        
                        end
                end
                    else
                        begin
                            state=sending;
                        end
            end
            else if(state==sending)
            begin
                if(valid_curr_data==1) begin
                    Piso_Register=from_enc_dec_msg;
                    out_valid<=1;
                    if(countmsgout >=0)
                        begin
                            sdo<=Piso_Register[countmsgout];
                            countmsgout<=countmsgout-1;
                        end
                    else
                        begin
                            sdo=1'bZ;
                            state=idle;
                            out_valid<=0;
                        end
                end
        end  
    end
else
        begin
            to_enc_dec_msg<=0;
            to_enc_dec_key<=0;
            Piso_Register<=0;
            countmsg<=0;
            countkey<=0;
            countmsgout<=8*4*nb-1;
            state=idle;
            out_valid<=0;
        end  
end


endmodule