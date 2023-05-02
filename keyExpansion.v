module keyExpansion #(
    parameter nk=4,parameter nb=4,parameter nr=10
) (
    input [(32*nk)-1:0]in_key,
    output  reg [(32*nb*(nr+1))-1:0]w
);
//16#09cf4f3cabf7158828aed2a62b7e1516
//16#0914dff42d9810a33b6108d71f352c07857d77812b73aef015ca71be603deb10

//vsim work.keyExpansion
    /***/
   
`include "mypkg.v"
    /***/
function [31:0]rotwordf;
input[31:0]in;
begin
    rotwordf={in[23:0],in[31:24]};
end
endfunction
    /***/

   
    
    /**********/
    wire [(32*nk)-1:0]key;
    reg[31:0] tmp;
    reg[31:0] subword;
    reg[31:0] words[0:nb*(nr+1)-1];
    reg[287:0] keys;
    integer i;
   
    lsb_msb_handler #(
        .words_cnt(nk)
    ) lsb_msb_handler_inst (
        .in(in_key),
        .out(key)
    );

    /**********/
    always  @(key)
    begin 
        keys=key;
        words[0]={keys[31:24],keys[23:16],keys[15:8],keys[7:0]};
        words[1]={keys[63:56],keys[55:48],keys[47:40],keys[39:32]};
        words[2]={keys[95:88],keys[87:80],keys[79:72],keys[71:64]};
        words[3]={keys[127:120],keys[119:112],keys[111:104],keys[103:96]};
        words[4]={keys[159:152],keys[151:144],keys[143:136],keys[135:128]};
        words[5]={keys[191:184],keys[183:176],keys[175:168],keys[167:160]};
        words[6]={keys[223:216],keys[215:208],keys[207:200],keys[199:192]};
        words[7]={keys[255:248],keys[247:240],keys[239:232],keys[231:224]};
        words[8]={keys[287:280],keys[279:272],keys[271:264],keys[263:256]};
        i=nk;
        while(i<nb*(nr+1))
        begin 
            tmp=words[i-1];
            if(i%nk ==0)begin
                tmp=rotwordf(tmp);
            end
                subword[7:0]=subbytef(tmp[7:0]);
                subword[15:8]=subbytef(tmp[15:8]);
                subword[23:16]=subbytef(tmp[23:16]);
                subword[31:24]=subbytef(tmp[31:24]);
            if(i%nk ==0) begin
                case(i/nk)
                    1:tmp=subword^32'h01000000;
                    2:tmp=subword^32'h02000000;
                    3:tmp=subword^32'h04000000;
                    4:tmp=subword^32'h08000000;
                    5:tmp=subword^32'h10000000;
                    6:tmp=subword^32'h20000000;
                    7:tmp=subword^32'h40000000;
                    8:tmp=subword^32'h80000000;
                    9:tmp=subword^32'h1b000000;
                    default:tmp=subword^32'h36000000;
                endcase
            end
            else if(nk>6 && i%nk==4)
                tmp=subword;
            words[i]=words[i-nk]^tmp;
            i=i+1;
        end

        if(nk==8)
        w={words[59],words[58],words[57],words[56],words[55],words[54],words[53],words[52],words[51],words[50],words[49],words[48],words[47],words[46],words[45],words[44],words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]};
        else if(nk==6)
        w={words[51],words[50],words[49],words[48],words[47],words[46],words[45],words[44],words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]};
        else if(nk==4)
        w={words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]};
    end
endmodule