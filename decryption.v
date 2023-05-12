module decryption #(
    parameter nk=8,parameter nb=4,parameter nr=14
) (
    
    input [8*4*nb-1:0]in_chiper,
    input [(32*nb*(nr+1))-1:0]w,
    output [8*4*nb-1:0]out_msg
);

//`include "mypkg.v"

/****/
function  [31:0]invsubbytef;
input [7:0]in;
 begin
        case(in)
              8'h00: invsubbytef=8'h52;
              8'h01: invsubbytef=8'h09;
              8'h02: invsubbytef=8'h6a;
              8'h03: invsubbytef=8'hd5;
              8'h04: invsubbytef=8'h30;
              8'h05: invsubbytef=8'h36;
              8'h06: invsubbytef=8'ha5;
              8'h07: invsubbytef=8'h38;
              8'h08: invsubbytef=8'hbf;
              8'h09: invsubbytef=8'h40;
              8'h0A: invsubbytef=8'ha3;
              8'h0B: invsubbytef=8'h9e;
              8'h0C: invsubbytef=8'h81;
              8'h0D: invsubbytef=8'hf3;
              8'h0E: invsubbytef=8'hd7;
              8'h0F: invsubbytef=8'hfb;
              8'h10: invsubbytef=8'h7c;
              8'h11: invsubbytef=8'he3;
              8'h12: invsubbytef=8'h39;
              8'h13: invsubbytef=8'h82;
              8'h14: invsubbytef=8'h9b;
              8'h15: invsubbytef=8'h2f;
              8'h16: invsubbytef=8'hff;
              8'h17: invsubbytef=8'h87;
              8'h18: invsubbytef=8'h34;
              8'h19: invsubbytef=8'h8e;
              8'h1A: invsubbytef=8'h43;
              8'h1B: invsubbytef=8'h44;
              8'h1C: invsubbytef=8'hc4;
              8'h1D: invsubbytef=8'hde;
              8'h1E: invsubbytef=8'he9;
              8'h1F: invsubbytef=8'hcb;
              8'h20: invsubbytef=8'h54;
              8'h21: invsubbytef=8'h7b;
              8'h22: invsubbytef=8'h94;
              8'h23: invsubbytef=8'h32;
              8'h24: invsubbytef=8'ha6;
              8'h25: invsubbytef=8'hc2;
              8'h26: invsubbytef=8'h23;
              8'h27: invsubbytef=8'h3d;
              8'h28: invsubbytef=8'hee;
              8'h29: invsubbytef=8'h4c;
              8'h2A: invsubbytef=8'h95;
              8'h2B: invsubbytef=8'h0b;
              8'h2C: invsubbytef=8'h42;
              8'h2D: invsubbytef=8'hfa;
              8'h2E: invsubbytef=8'hc3;
              8'h2F: invsubbytef=8'h4e;
              8'h30: invsubbytef=8'h08;
              8'h31: invsubbytef=8'h2e;
              8'h32: invsubbytef=8'ha1;
              8'h33: invsubbytef=8'h66;
              8'h34: invsubbytef=8'h28;
              8'h35: invsubbytef=8'hd9;
              8'h36: invsubbytef=8'h24;
              8'h37: invsubbytef=8'hb2;
              8'h38: invsubbytef=8'h76;
              8'h39: invsubbytef=8'h5b;
              8'h3A: invsubbytef=8'ha2;
              8'h3B: invsubbytef=8'h49;
              8'h3C: invsubbytef=8'h6d;
              8'h3D: invsubbytef=8'h8b;
              8'h3E: invsubbytef=8'hd1;
              8'h3F: invsubbytef=8'h25;
              8'h40: invsubbytef=8'h72;
              8'h41: invsubbytef=8'hf8;
              8'h42: invsubbytef=8'hf6;
              8'h43: invsubbytef=8'h64;
              8'h44: invsubbytef=8'h86;
              8'h45: invsubbytef=8'h68;
              8'h46: invsubbytef=8'h98;
              8'h47: invsubbytef=8'h16;
              8'h48: invsubbytef=8'hd4;
              8'h49: invsubbytef=8'ha4;
              8'h4A: invsubbytef=8'h5c;
              8'h4B: invsubbytef=8'hcc;
              8'h4C: invsubbytef=8'h5d;
              8'h4D: invsubbytef=8'h65;
              8'h4E: invsubbytef=8'hb6;
              8'h4F: invsubbytef=8'h92;
              8'h50: invsubbytef=8'h6c;
              8'h51: invsubbytef=8'h70;
              8'h52: invsubbytef=8'h48;
              8'h53: invsubbytef=8'h50;
              8'h54: invsubbytef=8'hfd;
              8'h55: invsubbytef=8'hed;
              8'h56: invsubbytef=8'hb9;
              8'h57: invsubbytef=8'hda;
              8'h58: invsubbytef=8'h5e;
              8'h59: invsubbytef=8'h15;
              8'h5A: invsubbytef=8'h46;
              8'h5B: invsubbytef=8'h57;
              8'h5C: invsubbytef=8'ha7;
              8'h5D: invsubbytef=8'h8d;
              8'h5E: invsubbytef=8'h9d;
              8'h5F: invsubbytef=8'h84;
              8'h60: invsubbytef=8'h90;
              8'h61: invsubbytef=8'hd8;
              8'h62: invsubbytef=8'hab;
              8'h63: invsubbytef=8'h00;
              8'h64: invsubbytef=8'h8c;
              8'h65: invsubbytef=8'hbc;
              8'h66: invsubbytef=8'hd3;
              8'h67: invsubbytef=8'h0a;
              8'h68: invsubbytef=8'hf7;
              8'h69: invsubbytef=8'he4;
              8'h6A: invsubbytef=8'h58;
              8'h6B: invsubbytef=8'h05;
              8'h6C: invsubbytef=8'hb8;
              8'h6D: invsubbytef=8'hb3;
              8'h6E: invsubbytef=8'h45;
              8'h6F: invsubbytef=8'h06;
              8'h70: invsubbytef=8'hd0;
              8'h71: invsubbytef=8'h2c;
              8'h72: invsubbytef=8'h1e;
              8'h73: invsubbytef=8'h8f;
              8'h74: invsubbytef=8'hca;
              8'h75: invsubbytef=8'h3f;
              8'h76: invsubbytef=8'h0f;
              8'h77: invsubbytef=8'h02;
              8'h78: invsubbytef=8'hc1;
              8'h79: invsubbytef=8'haf;
              8'h7A: invsubbytef=8'hbd;
              8'h7B: invsubbytef=8'h03;
              8'h7C: invsubbytef=8'h01;
              8'h7D: invsubbytef=8'h13;
              8'h7E: invsubbytef=8'h8a;
              8'h7F: invsubbytef=8'h6b;
              8'h80: invsubbytef=8'h3a;
              8'h81: invsubbytef=8'h91;
              8'h82: invsubbytef=8'h11;
              8'h83: invsubbytef=8'h41;
              8'h84: invsubbytef=8'h4f;
              8'h85: invsubbytef=8'h67;
              8'h86: invsubbytef=8'hdc;
              8'h87: invsubbytef=8'hea;
              8'h88: invsubbytef=8'h97;
              8'h89: invsubbytef=8'hf2;
              8'h8A: invsubbytef=8'hcf;
              8'h8B: invsubbytef=8'hce;
              8'h8C: invsubbytef=8'hf0;
              8'h8D: invsubbytef=8'hb4;
              8'h8E: invsubbytef=8'he6;
              8'h8F: invsubbytef=8'h73;
              8'h90: invsubbytef=8'h96;
              8'h91: invsubbytef=8'hac;
              8'h92: invsubbytef=8'h74;
              8'h93: invsubbytef=8'h22;
              8'h94: invsubbytef=8'he7;
              8'h95: invsubbytef=8'had;
              8'h96: invsubbytef=8'h35;
              8'h97: invsubbytef=8'h85;
              8'h98: invsubbytef=8'he2;
              8'h99: invsubbytef=8'hf9;
              8'h9A: invsubbytef=8'h37;
              8'h9B: invsubbytef=8'he8;
              8'h9C: invsubbytef=8'h1c;
              8'h9D: invsubbytef=8'h75;
              8'h9E: invsubbytef=8'hdf;
              8'h9F: invsubbytef=8'h6e;
              8'hA0: invsubbytef=8'h47;
              8'hA1: invsubbytef=8'hf1;
              8'hA2: invsubbytef=8'h1a;
              8'hA3: invsubbytef=8'h71;
              8'hA4: invsubbytef=8'h1d;
              8'hA5: invsubbytef=8'h29;
              8'hA6: invsubbytef=8'hc5;
              8'hA7: invsubbytef=8'h89;
              8'hA8: invsubbytef=8'h6f;
              8'hA9: invsubbytef=8'hb7;
              8'hAA: invsubbytef=8'h62;
              8'hAB: invsubbytef=8'h0e;
              8'hAC: invsubbytef=8'haa;
              8'hAD: invsubbytef=8'h18;
              8'hAE: invsubbytef=8'hbe;
              8'hAF: invsubbytef=8'h1b;
              8'hB0: invsubbytef=8'hfc;
              8'hB1: invsubbytef=8'h56;
              8'hB2: invsubbytef=8'h3e;
              8'hB3: invsubbytef=8'h4b;
              8'hB4: invsubbytef=8'hc6;
              8'hB5: invsubbytef=8'hd2;
              8'hB6: invsubbytef=8'h79;
              8'hB7: invsubbytef=8'h20;
              8'hB8: invsubbytef=8'h9a;
              8'hB9: invsubbytef=8'hdb;
              8'hBA: invsubbytef=8'hc0;
              8'hBB: invsubbytef=8'hfe;
              8'hBC: invsubbytef=8'h78;
              8'hBD: invsubbytef=8'hcd;
              8'hBE: invsubbytef=8'h5a;
              8'hBF: invsubbytef=8'hf4;
              8'hC0: invsubbytef=8'h1f;
              8'hC1: invsubbytef=8'hdd;
              8'hC2: invsubbytef=8'ha8;
              8'hC3: invsubbytef=8'h33;
              8'hC4: invsubbytef=8'h88;
              8'hC5: invsubbytef=8'h07;
              8'hC6: invsubbytef=8'hc7;
              8'hC7: invsubbytef=8'h31;
              8'hC8: invsubbytef=8'hb1;
              8'hC9: invsubbytef=8'h12;
              8'hCA: invsubbytef=8'h10;
              8'hCB: invsubbytef=8'h59;
              8'hCC: invsubbytef=8'h27;
              8'hCD: invsubbytef=8'h80;
              8'hCE: invsubbytef=8'hec;
              8'hCF: invsubbytef=8'h5f;
              8'hD0: invsubbytef=8'h60;
              8'hD1: invsubbytef=8'h51;
              8'hD2: invsubbytef=8'h7f;
              8'hD3: invsubbytef=8'ha9;
              8'hD4: invsubbytef=8'h19;
              8'hD5: invsubbytef=8'hb5;
              8'hD6: invsubbytef=8'h4a;
              8'hD7: invsubbytef=8'h0d;
              8'hD8: invsubbytef=8'h2d;
              8'hD9: invsubbytef=8'he5;
              8'hDA: invsubbytef=8'h7a;
              8'hDB: invsubbytef=8'h9f;
              8'hDC: invsubbytef=8'h93;
              8'hDD: invsubbytef=8'hc9;
              8'hDE: invsubbytef=8'h9c;
              8'hDF: invsubbytef=8'hef;
              8'hE0: invsubbytef=8'ha0;
              8'hE1: invsubbytef=8'he0;
              8'hE2: invsubbytef=8'h3b;
              8'hE3: invsubbytef=8'h4d;
              8'hE4: invsubbytef=8'hae;
              8'hE5: invsubbytef=8'h2a;
              8'hE6: invsubbytef=8'hf5;
              8'hE7: invsubbytef=8'hb0;
              8'hE8: invsubbytef=8'hc8;
              8'hE9: invsubbytef=8'heb;
              8'hEA: invsubbytef=8'hbb;
              8'hEB: invsubbytef=8'h3c;
              8'hEC: invsubbytef=8'h83;
              8'hED: invsubbytef=8'h53;
              8'hEE: invsubbytef=8'h99;
              8'hEF: invsubbytef=8'h61;
              8'hF0: invsubbytef=8'h17;
              8'hF1: invsubbytef=8'h2b;
              8'hF2: invsubbytef=8'h04;
              8'hF3: invsubbytef=8'h7e;
              8'hF4: invsubbytef=8'hba;
              8'hF5: invsubbytef=8'h77;
              8'hF6: invsubbytef=8'hd6;
              8'hF7: invsubbytef=8'h26;
              8'hF8: invsubbytef=8'he1;
              8'hF9: invsubbytef=8'h69;
              8'hFA: invsubbytef=8'h14;
              8'hFB: invsubbytef=8'h63;
              8'hFC: invsubbytef=8'h55;
              8'hFD: invsubbytef=8'h21;
              8'hFE: invsubbytef=8'h0c;
              8'hFF: invsubbytef=8'h7d;
              default: invsubbytef=8'h0;     
        endcase
 end
endfunction

function [7:0]mult;
input [7:0]a;
input [7:0]b;
reg [8:0]tmp;
reg [7:0]res;
integer i;
begin
    tmp={1'b0,a};
    res=0;
    for(i=0;i<8;i=i+1)
    begin
    if(b[i]==1)
    begin
    res=res^tmp[7:0];
    end
    tmp=tmp<<1;
    if(tmp[8]==1)
    begin
        tmp=tmp^9'h11b;
    end
    end
    mult=res;
end
endfunction

/****/

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