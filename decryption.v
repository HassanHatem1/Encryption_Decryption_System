module decryption #(
    parameter nk=8,parameter nb=4,parameter nr=14
) (
    
    input [8*4*nb-1:0]in_chiper,
    input [(32*nb*(nr+1))-1:0]w,
    output [8*4*nb-1:0]out_msg
);

`include "mypkg.v"



wire [8*4*nb-1:0]chiper;
reg [8*4*nb-1:0]msg;
reg[31:0] words[0:nb*(nr+1)-1];
reg[31:0] state[0:nb-1];
reg[31:0] tmp[0:nb-1];
reg[31:0] constmtrx[0:nb-1];
integer round;
    

lsb_msb_handler #(
    .words_cnt(nb)
) lsb_msb_handler_inst (
    .in(in_chiper),
    .out(chiper)
);

lsb_msb_handler #(
    .words_cnt(nb)
) lsb_msb_handler_inst1 (
    .in(msg),
    .out(out_msg)
);

always @(*)
begin
    /***Intializing words array**********/
    if(nk==8)
        {words[59],words[58],words[57],words[56],words[55],words[54],words[53],words[52],words[51],words[50],words[49],words[48],words[47],words[46],words[45],words[44],words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]}=w;
        else if(nk==6)
        {words[51],words[50],words[49],words[48],words[47],words[46],words[45],words[44],words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]}=w;
        else if(nk==4)
        {words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]}=w;
    /***End Intializing words array**********/
    state[0]=chiper[31:0];
    state[1]=chiper[63:32];
    state[2]=chiper[95:64];
    state[3]=chiper[127:96];
    /**********Intializaing mix coloumn array************/
    constmtrx[0]=32'h0e0b0d09;
    constmtrx[1]=32'h090e0b0d;
    constmtrx[2]=32'h0d090e0b;
    constmtrx[3]=32'h0b0d090e;
    /**********end of Intialization************/
    state[0]=state[0]^words[nr*nb];
    state[1]=state[1]^words[nr*nb+1];
    state[2]=state[2]^words[nr*nb+2];
    state[3]=state[3]^words[nr*nb+3];
    /**********end of adding round key************/
    for(round=nr-1;round>=0;round=round-1)
    begin
    
    /*****invshift operation**************/
    {state[0][23:16],state[1][23:16],state[2][23:16],state[3][23:16]}={state[3][23:16],state[0][23:16],state[1][23:16],state[2][23:16]};
    {state[0][15:8],state[1][15:8],state[2][15:8],state[3][15:8]}={state[2][15:8],state[3][15:8],state[0][15:8],state[1][15:8]};
    {state[0][7:0],state[1][7:0],state[2][7:0],state[3][7:0]}={state[1][7:0],state[2][7:0],state[3][7:0],state[0][7:0]};
    /**********end of invshift************/
    /****invsubstitute operation*********/
    state[0][7:0]=invsubbytef(state[0][7:0]);
    state[0][15:8]=invsubbytef(state[0][15:8]);
    state[0][23:16]=invsubbytef(state[0][23:16]);
    state[0][31:24]=invsubbytef(state[0][31:24]);
    state[1][7:0]=invsubbytef(state[1][7:0]);
    state[1][15:8]=invsubbytef(state[1][15:8]);
    state[1][23:16]=invsubbytef(state[1][23:16]);
    state[1][31:24]=invsubbytef(state[1][31:24]);
    state[2][7:0]=invsubbytef(state[2][7:0]);
    state[2][15:8]=invsubbytef(state[2][15:8]);
    state[2][23:16]=invsubbytef(state[2][23:16]);
    state[2][31:24]=invsubbytef(state[2][31:24]);
    state[3][7:0]=invsubbytef(state[3][7:0]);
    state[3][15:8]=invsubbytef(state[3][15:8]);
    state[3][23:16]=invsubbytef(state[3][23:16]);
    state[3][31:24]=invsubbytef(state[3][31:24]);
    /**********end of invsubstitute******/
    
    /*****************add round key***********/
    state[0]=state[0]^words[round*nb];
    state[1]=state[1]^words[round*nb+1];
    state[2]=state[2]^words[round*nb+2];
    state[3]=state[3]^words[round*nb+3];
    /**********end of add round key************/

     /*****invmix operation**************/
     if(round!=0) begin
    tmp[0][31:24]=mult(constmtrx[0][31:24],state[0][31:24])^mult(constmtrx[0][23:16],state[0][23:16])^mult(constmtrx[0][15:8],state[0][15:8])^mult(constmtrx[0][7:0],state[0][7:0]);
    tmp[0][23:16]=mult(constmtrx[1][31:24],state[0][31:24])^mult(constmtrx[1][23:16],state[0][23:16])^mult(constmtrx[1][15:8],state[0][15:8])^mult(constmtrx[1][7:0],state[0][7:0]);
    tmp[0][15:8]=mult(constmtrx[2][31:24],state[0][31:24])^mult(constmtrx[2][23:16],state[0][23:16])^mult(constmtrx[2][15:8],state[0][15:8])^mult(constmtrx[2][7:0],state[0][7:0]);
    tmp[0][7:0]=mult(constmtrx[3][31:24],state[0][31:24])^mult(constmtrx[3][23:16],state[0][23:16])^mult(constmtrx[3][15:8],state[0][15:8])^mult(constmtrx[3][7:0],state[0][7:0]);
    tmp[1][31:24]=mult(constmtrx[0][31:24],state[1][31:24])^mult(constmtrx[0][23:16],state[1][23:16])^mult(constmtrx[0][15:8],state[1][15:8])^mult(constmtrx[0][7:0],state[1][7:0]);
    tmp[1][23:16]=mult(constmtrx[1][31:24],state[1][31:24])^mult(constmtrx[1][23:16],state[1][23:16])^mult(constmtrx[1][15:8],state[1][15:8])^mult(constmtrx[1][7:0],state[1][7:0]);
    tmp[1][15:8]=mult(constmtrx[2][31:24],state[1][31:24])^mult(constmtrx[2][23:16],state[1][23:16])^mult(constmtrx[2][15:8],state[1][15:8])^mult(constmtrx[2][7:0],state[1][7:0]);
    tmp[1][7:0]=mult(constmtrx[3][31:24],state[1][31:24])^mult(constmtrx[3][23:16],state[1][23:16])^mult(constmtrx[3][15:8],state[1][15:8])^mult(constmtrx[3][7:0],state[1][7:0]);
    tmp[2][31:24]=mult(constmtrx[0][31:24],state[2][31:24])^mult(constmtrx[0][23:16],state[2][23:16])^mult(constmtrx[0][15:8],state[2][15:8])^mult(constmtrx[0][7:0],state[2][7:0]);
    tmp[2][23:16]=mult(constmtrx[1][31:24],state[2][31:24])^mult(constmtrx[1][23:16],state[2][23:16])^mult(constmtrx[1][15:8],state[2][15:8])^mult(constmtrx[1][7:0],state[2][7:0]);
    tmp[2][15:8]=mult(constmtrx[2][31:24],state[2][31:24])^mult(constmtrx[2][23:16],state[2][23:16])^mult(constmtrx[2][15:8],state[2][15:8])^mult(constmtrx[2][7:0],state[2][7:0]);
    tmp[2][7:0]=mult(constmtrx[3][31:24],state[2][31:24])^mult(constmtrx[3][23:16],state[2][23:16])^mult(constmtrx[3][15:8],state[2][15:8])^mult(constmtrx[3][7:0],state[2][7:0]);
    tmp[3][31:24]=mult(constmtrx[0][31:24],state[3][31:24])^mult(constmtrx[0][23:16],state[3][23:16])^mult(constmtrx[0][15:8],state[3][15:8])^mult(constmtrx[0][7:0],state[3][7:0]);
    tmp[3][23:16]=mult(constmtrx[1][31:24],state[3][31:24])^mult(constmtrx[1][23:16],state[3][23:16])^mult(constmtrx[1][15:8],state[3][15:8])^mult(constmtrx[1][7:0],state[3][7:0]);
    tmp[3][15:8]=mult(constmtrx[2][31:24],state[3][31:24])^mult(constmtrx[2][23:16],state[3][23:16])^mult(constmtrx[2][15:8],state[3][15:8])^mult(constmtrx[2][7:0],state[3][7:0]);
    tmp[3][7:0]=mult(constmtrx[3][31:24],state[3][31:24])^mult(constmtrx[3][23:16],state[3][23:16])^mult(constmtrx[3][15:8],state[3][15:8])^mult(constmtrx[3][7:0],state[3][7:0]);
    state[0]=tmp[0];
    state[1]=tmp[1];
    state[2]=tmp[2];
    state[3]=tmp[3];
     end
    /**********end of invmix************/
    end
    msg={state[3],state[2],state[1],state[0]};

end
endmodule