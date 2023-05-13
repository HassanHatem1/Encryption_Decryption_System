module Master #( 
    parameter nk=8,parameter nb=4,parameter nr=14
)(
input  Miso ,		                //1-bit input from  slave    
input [8*4*nb-1:0]from_Real_msg,	//the message in the computer side	
input [(32*nk)-1:0]from_Real_key,   //the key in the computer side
input in_clk,                       //needs to be generated
input rst,                          //reset

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


assign out_clk=in_clk;


always @(posedge in_clk,posedge rst)
begin
    if(rst==1)
        begin
            Sipo_in_process=0;
            cs_enc_dec<=1;
        end
    else
    begin
        if(cs_enc_dec==1)
            begin
                cs_enc_dec=0;
                Piso_Register<={from_Real_msg,from_Real_key};
                countmsg<=0;
                countmsgout<=8*4*nb+(32*nk)-1;
                waitForInput=1;
            end
        if(countmsgout >=0)
            begin
                Mosi<=Piso_Register[countmsgout];
                countmsgout<=countmsgout-1;
            end
        else
            if(countmsg<=8*4*nb-1)
                begin
                    if(waitForInput==0)
                        begin
                            countmsg<=countmsg+1;
                            Sipo_in_process={Sipo_in_process[8*4*nb-2:0], Miso};
                        end
                    else
                        waitForInput=0;
            end
    else 
            begin
               Sipo_Register=Sipo_in_process;
               cs_enc_dec<=1;   
            end
    if (countmsgout==-1)
    begin
            Mosi<=1'bz;
    end
    end
end


endmodule