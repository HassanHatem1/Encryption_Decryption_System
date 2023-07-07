module Master #( 
    parameter nk=4,parameter nb=4,parameter nr=10
)(
input  Miso ,		                //1-bit input from  slave    
input [8*4*nb-1:0]from_Real_msg,	//the message in the computer side	
input [(32*nk)-1:0]from_Real_key,   //the key in the computer side
input in_clk,                       //needs to be generated
input rst,                          //reset

input valid_curr_data,              //valid date in the Sipo_Register
input in_valid,                     
output reg out_valid,

output out_clk ,		            //1-bit input from clock from  slave
output reg cs_enc_dec ,             //1-bit chip select output to  slave  
output reg Mosi ,		            //1-bit output to  slave    
output reg [8*4*nb-1:0]Sipo_Register		
); 
  
reg [8*4*nb-1:0]Sipo_in_process;
integer countmsg;
integer countmsgout;

reg [8*4*nb+(32*nk)-1:0]Piso_Register;
reg waitForInput;

localparam idle = 2'b00;
localparam sending = 2'b01;
localparam recieving = 2'b10;
reg [1:0]state=idle;
integer countmsgin;

assign out_clk=in_clk;


always @(posedge in_clk,posedge rst)
begin
    if(rst==1)
        begin
            countmsgin<=8*4*nb-1;
            out_valid<=0;
            cs_enc_dec<=1;
            Piso_Register=0;
            Sipo_in_process=0;
            countmsg<=0;
            countmsgout<=8*4*nb+(32*nk)-1;
            waitForInput=1;
            Sipo_Register=0;
            state=idle;
        end
    else
    begin
        if(state==idle)
            begin
                countmsgin<=8*4*nb-1;
                out_valid<=0;
                cs_enc_dec<=1;
                Piso_Register=0;
                Sipo_in_process=0;
                countmsg<=0;
                countmsgout<=8*4*nb+(32*nk)-1;
                waitForInput=1;
                if(valid_curr_data==1)begin
                    state=sending;
                    Piso_Register={from_Real_msg,from_Real_key};
                end
            end
        else if(state==sending)
            begin
            if(countmsgout >=0)
                begin
                    out_valid<=1;
                    Mosi<=Piso_Register[countmsgout];
                    countmsgout<=countmsgout-1;
                    cs_enc_dec<=0;
                end
            else
                begin
                    out_valid<=0;
                    Mosi<=1'bz;
                    state=recieving;
                end
            end
        else if(state==recieving)
            begin
                if(countmsgin>=0)
                begin
                    if(in_valid==1) begin
                            Sipo_in_process={Sipo_in_process[8*4*nb-2:0], Miso};
                            countmsgin=countmsgin-1;
                    end
                end
                else begin
                        Sipo_Register=Sipo_in_process;
                        cs_enc_dec<=1;
                        state=idle;
                end
            end
    end
end


endmodule