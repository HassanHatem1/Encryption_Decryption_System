module encryption #(
    parameter nk=4,parameter nb=4,parameter nr=10
) (
    input clk,
    input [8*4*nb-1:0]msg,
    input [(32*nb*(nr+1))-1:0]w,
    input in_valid,
    output reg out_valid,
    output reg [8*4*nb-1:0]cipher
);



reg[31:0] words[0:nb*(nr+1)-1];
reg[31:0] state[0:nb-1];
reg[31:0] tmp[0:nb-1];
reg[31:0] constmtrx[0:nb-1];
integer round=1;
reg ftime=1;


always @(posedge clk)
begin
    out_valid=1'b0;
    /***Intializing words array**********/
   if (in_valid==1'b1) begin
        if(nk==8)
        {words[59],words[58],words[57],words[56],words[55],words[54],words[53],words[52],words[51],words[50],words[49],words[48],words[47],words[46],words[45],words[44],words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]}=w;
        else if(nk==6)
        {words[51],words[50],words[49],words[48],words[47],words[46],words[45],words[44],words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]}=w;
        else if(nk==4)
        {words[43],words[42],words[41],words[40],words[39],words[38],words[37],words[36],words[35],words[34],words[33],words[32],words[31],words[30],words[29],words[28],words[27],words[26],words[25],words[24],words[23],words[22],words[21],words[20],words[19],words[18],words[17],words[16],words[15],words[14],words[13],words[12],words[11],words[10],words[9],words[8],words[7],words[6],words[5],words[4],words[3],words[2],words[1],words[0]}=w;
    /***End Intializing words array**********/
        if(ftime==1) begin
            state[0]=msg[127:96];
            state[1]=msg[95:64];
            state[2]=msg[63:32];
            state[3]=msg[31:0];
            /**********Intializaing mix coloumn array************/
            constmtrx[0]=32'h02030101;
            constmtrx[1]=32'h01020301;
            constmtrx[2]=32'h01010203;
            constmtrx[3]=32'h03010102;
            /**********end of Intialization************/
            state[0]=state[0]^words[0];
            state[1]=state[1]^words[1];
            state[2]=state[2]^words[2];
            state[3]=state[3]^words[3];
            /**********end of adding round key************/
            ftime=0;
        end

    if(round<=nr)
    begin
        state[0][7:0]=subbytef(state[0][7:0]);
        state[0][15:8]=subbytef(state[0][15:8]);
        state[0][23:16]=subbytef(state[0][23:16]);
        state[0][31:24]=subbytef(state[0][31:24]);
        state[1][7:0]=subbytef(state[1][7:0]);
        state[1][15:8]=subbytef(state[1][15:8]);
        state[1][23:16]=subbytef(state[1][23:16]);
        state[1][31:24]=subbytef(state[1][31:24]);
        state[2][7:0]=subbytef(state[2][7:0]);
        state[2][15:8]=subbytef(state[2][15:8]);
        state[2][23:16]=subbytef(state[2][23:16]);
        state[2][31:24]=subbytef(state[2][31:24]);
        state[3][7:0]=subbytef(state[3][7:0]);
        state[3][15:8]=subbytef(state[3][15:8]);
        state[3][23:16]=subbytef(state[3][23:16]);
        state[3][31:24]=subbytef(state[3][31:24]);
        /*****shift operation**************/
        {state[0][23:16],state[1][23:16],state[2][23:16],state[3][23:16]}={state[1][23:16],state[2][23:16],state[3][23:16],state[0][23:16]};
        {state[0][15:8],state[1][15:8],state[2][15:8],state[3][15:8]}={state[2][15:8],state[3][15:8],state[0][15:8],state[1][15:8]};
        {state[0][7:0],state[1][7:0],state[2][7:0],state[3][7:0]}={state[3][7:0],state[0][7:0],state[1][7:0],state[2][7:0]};
        /**********end of shift************/

     /*****mix operation**************/
     if(round!=nr) begin
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
    /**********end of mix************/
    /*****************add round key***********/
    state[0]=state[0]^words[round*nb];
    state[1]=state[1]^words[round*nb+1];
    state[2]=state[2]^words[round*nb+2];
    state[3]=state[3]^words[round*nb+3];
    /**********end of add round key************/
    round=round+1;
    end
    else
    begin
        round=1;
        ftime=1;
        out_valid=1'b1;
        cipher={state[0],state[1],state[2],state[3]};
    end
    end
    else
    begin
        round=1;
        ftime=1;
    end
end

/**********beginning of functions*********/
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

function  [7:0]subbytef;
input [7:0]in;
 begin
        case(in)
        8'h00: subbytef=8'h63;
        8'h01: subbytef=8'h7c;
        8'h02: subbytef=8'h77;
        8'h03: subbytef=8'h7b;
        8'h04: subbytef=8'hf2;
        8'h05: subbytef=8'h6b;
        8'h06: subbytef=8'h6f;
        8'h07: subbytef=8'hc5;
        8'h08: subbytef=8'h30;
        8'h09: subbytef=8'h01;
        8'h0A: subbytef=8'h67;
        8'h0B: subbytef=8'h2b;
        8'h0C: subbytef=8'hfe;
        8'h0D: subbytef=8'hd7;
        8'h0E: subbytef=8'hab;
        8'h0F: subbytef=8'h76;
        8'h10: subbytef=8'hca;
        8'h11: subbytef=8'h82;
        8'h12: subbytef=8'hc9;
        8'h13: subbytef=8'h7d;
        8'h14: subbytef=8'hfa;
        8'h15: subbytef=8'h59;
        8'h16: subbytef=8'h47;
        8'h17: subbytef=8'hf0;
        8'h18: subbytef=8'had;
        8'h19: subbytef=8'hd4;
        8'h1A: subbytef=8'ha2;
        8'h1B: subbytef=8'haf;
        8'h1C: subbytef=8'h9c;
        8'h1D: subbytef=8'ha4;
        8'h1E: subbytef=8'h72;
        8'h1F: subbytef=8'hc0;
        8'h20: subbytef=8'hb7;
        8'h21: subbytef=8'hfd;
        8'h22: subbytef=8'h93;
        8'h23: subbytef=8'h26;
        8'h24: subbytef=8'h36;
        8'h25: subbytef=8'h3f;
        8'h26: subbytef=8'hf7;
        8'h27: subbytef=8'hcc;
        8'h28: subbytef=8'h34;
        8'h29: subbytef=8'ha5;
        8'h2A: subbytef=8'he5;
        8'h2B: subbytef=8'hf1;
        8'h2C: subbytef=8'h71;
        8'h2D: subbytef=8'hd8;
        8'h2E: subbytef=8'h31;
        8'h2F: subbytef=8'h15;
        8'h30: subbytef=8'h04;
        8'h31: subbytef=8'hc7;
        8'h32: subbytef=8'h23;
        8'h33: subbytef=8'hc3;
        8'h34: subbytef=8'h18;
        8'h35: subbytef=8'h96;
        8'h36: subbytef=8'h05;
        8'h37: subbytef=8'h9a;
        8'h38: subbytef=8'h07;
        8'h39: subbytef=8'h12;
        8'h3A: subbytef=8'h80;
        8'h3B: subbytef=8'he2;
        8'h3C: subbytef=8'heb;
        8'h3D: subbytef=8'h27;
        8'h3E: subbytef=8'hb2;
        8'h3F: subbytef=8'h75;
        8'h40: subbytef=8'h09;
        8'h41: subbytef=8'h83;
        8'h42: subbytef=8'h2c;
        8'h43: subbytef=8'h1a;
        8'h44: subbytef=8'h1b;
        8'h45: subbytef=8'h6e;
        8'h46: subbytef=8'h5a;
        8'h47: subbytef=8'ha0;
        8'h48: subbytef=8'h52;
        8'h49: subbytef=8'h3b;
        8'h4A: subbytef=8'hd6;
        8'h4B: subbytef=8'hb3;
        8'h4C: subbytef=8'h29;
        8'h4D: subbytef=8'he3;
        8'h4E: subbytef=8'h2f;
        8'h4F: subbytef=8'h84;
        8'h50: subbytef=8'h53;
        8'h51: subbytef=8'hd1;
        8'h52: subbytef=8'h00;
        8'h53: subbytef=8'hed;
        8'h54: subbytef=8'h20;
        8'h55: subbytef=8'hfc;
        8'h56: subbytef=8'hb1;
        8'h57: subbytef=8'h5b;
        8'h58: subbytef=8'h6a;
        8'h59: subbytef=8'hcb;
        8'h5A: subbytef=8'hbe;
        8'h5B: subbytef=8'h39;
        8'h5C: subbytef=8'h4a;
        8'h5D: subbytef=8'h4c;
        8'h5E: subbytef=8'h58;
        8'h5F: subbytef=8'hcf;
        8'h60: subbytef=8'hd0;
        8'h61: subbytef=8'hef;
        8'h62: subbytef=8'haa;
        8'h63: subbytef=8'hfb;
        8'h64: subbytef=8'h43;
        8'h65: subbytef=8'h4d;
        8'h66: subbytef=8'h33;
        8'h67: subbytef=8'h85;
        8'h68: subbytef=8'h45;
        8'h69: subbytef=8'hf9;
        8'h6A: subbytef=8'h02;
        8'h6B: subbytef=8'h7f;
        8'h6C: subbytef=8'h50;
        8'h6D: subbytef=8'h3c;
        8'h6E: subbytef=8'h9f;
        8'h6F: subbytef=8'ha8;
        8'h70: subbytef=8'h51;
        8'h71: subbytef=8'ha3;
        8'h72: subbytef=8'h40;
        8'h73: subbytef=8'h8f;
        8'h74: subbytef=8'h92;
        8'h75: subbytef=8'h9d;
        8'h76: subbytef=8'h38;
        8'h77: subbytef=8'hf5;
        8'h78: subbytef=8'hbc;
        8'h79: subbytef=8'hb6;
        8'h7A: subbytef=8'hda;
        8'h7B: subbytef=8'h21;
        8'h7C: subbytef=8'h10;
        8'h7D: subbytef=8'hff;
        8'h7E: subbytef=8'hf3;
        8'h7F: subbytef=8'hd2;
        8'h80: subbytef=8'hcd;
        8'h81: subbytef=8'h0c;
        8'h82: subbytef=8'h13;
        8'h83: subbytef=8'hec;
        8'h84: subbytef=8'h5f;
        8'h85: subbytef=8'h97;
        8'h86: subbytef=8'h44;
        8'h87: subbytef=8'h17;
        8'h88: subbytef=8'hc4;
        8'h89: subbytef=8'ha7;
        8'h8A: subbytef=8'h7e;
        8'h8B: subbytef=8'h3d;
        8'h8C: subbytef=8'h64;
        8'h8D: subbytef=8'h5d;
        8'h8E: subbytef=8'h19;
        8'h8F: subbytef=8'h73;
        8'h90: subbytef=8'h60;
        8'h91: subbytef=8'h81;
        8'h92: subbytef=8'h4f;
        8'h93: subbytef=8'hdc;
        8'h94: subbytef=8'h22;
        8'h95: subbytef=8'h2a;
        8'h96: subbytef=8'h90;
        8'h97: subbytef=8'h88;
        8'h98: subbytef=8'h46;
        8'h99: subbytef=8'hee;
        8'h9A: subbytef=8'hb8;
        8'h9B: subbytef=8'h14;
        8'h9C: subbytef=8'hde;
        8'h9D: subbytef=8'h5e;
        8'h9E: subbytef=8'h0b;
        8'h9F: subbytef=8'hdb;
        8'hA0: subbytef=8'he0;
        8'hA1: subbytef=8'h32;
        8'hA2: subbytef=8'h3a;
        8'hA3: subbytef=8'h0a;
        8'hA4: subbytef=8'h49;
        8'hA5: subbytef=8'h06;
        8'hA6: subbytef=8'h24;
        8'hA7: subbytef=8'h5c;
        8'hA8: subbytef=8'hc2;
        8'hA9: subbytef=8'hd3;
        8'hAA: subbytef=8'hac;
        8'hAB: subbytef=8'h62;
        8'hAC: subbytef=8'h91;
        8'hAD: subbytef=8'h95;
        8'hAE: subbytef=8'he4;
        8'hAF: subbytef=8'h79;
        8'hB0: subbytef=8'he7;
        8'hB1: subbytef=8'hc8;
        8'hB2: subbytef=8'h37;
        8'hB3: subbytef=8'h6d;
        8'hB4: subbytef=8'h8d;
        8'hB5: subbytef=8'hd5;
        8'hB6: subbytef=8'h4e;
        8'hB7: subbytef=8'ha9;
        8'hB8: subbytef=8'h6c;
        8'hB9: subbytef=8'h56;
        8'hBA: subbytef=8'hf4;
        8'hBB: subbytef=8'hea;
        8'hBC: subbytef=8'h65;
        8'hBD: subbytef=8'h7a;
        8'hBE: subbytef=8'hae;
        8'hBF: subbytef=8'h08;
        8'hC0: subbytef=8'hba;
        8'hC1: subbytef=8'h78;
        8'hC2: subbytef=8'h25;
        8'hC3: subbytef=8'h2e;
        8'hC4: subbytef=8'h1c;
        8'hC5: subbytef=8'ha6;
        8'hC6: subbytef=8'hb4;
        8'hC7: subbytef=8'hc6;
        8'hC8: subbytef=8'he8;
        8'hC9: subbytef=8'hdd;
        8'hCA: subbytef=8'h74;
        8'hCB: subbytef=8'h1f;
        8'hCC: subbytef=8'h4b;
        8'hCD: subbytef=8'hbd;
        8'hCE: subbytef=8'h8b;
        8'hCF: subbytef=8'h8a;
        8'hD0: subbytef=8'h70;
        8'hD1: subbytef=8'h3e;
        8'hD2: subbytef=8'hb5;
        8'hD3: subbytef=8'h66;
        8'hD4: subbytef=8'h48;
        8'hD5: subbytef=8'h03;
        8'hD6: subbytef=8'hf6;
        8'hD7: subbytef=8'h0e;
        8'hD8: subbytef=8'h61;
        8'hD9: subbytef=8'h35;
        8'hDA: subbytef=8'h57;
        8'hDB: subbytef=8'hb9;
        8'hDC: subbytef=8'h86;
        8'hDD: subbytef=8'hc1;
        8'hDE: subbytef=8'h1d;
        8'hDF: subbytef=8'h9e;
        8'hE0: subbytef=8'he1;
        8'hE1: subbytef=8'hf8;
        8'hE2: subbytef=8'h98;
        8'hE3: subbytef=8'h11;
        8'hE4: subbytef=8'h69;
        8'hE5: subbytef=8'hd9;
        8'hE6: subbytef=8'h8e;
        8'hE7: subbytef=8'h94;
        8'hE8: subbytef=8'h9b;
        8'hE9: subbytef=8'h1e;
        8'hEA: subbytef=8'h87;
        8'hEB: subbytef=8'he9;
        8'hEC: subbytef=8'hce;
        8'hED: subbytef=8'h55;
        8'hEE: subbytef=8'h28;
        8'hEF: subbytef=8'hdf;
        8'hF0: subbytef=8'h8c;
        8'hF1: subbytef=8'ha1;
        8'hF2: subbytef=8'h89;
        8'hF3: subbytef=8'h0d;
        8'hF4: subbytef=8'hbf;
        8'hF5: subbytef=8'he6;
        8'hF6: subbytef=8'h42;
        8'hF7: subbytef=8'h68;
        8'hF8: subbytef=8'h41;
        8'hF9: subbytef=8'h99;
        8'hFA: subbytef=8'h2d;
        8'hFB: subbytef=8'h0f;
        8'hFC: subbytef=8'hb0;
        8'hFD: subbytef=8'h54;
        8'hFE: subbytef=8'hbb;
        8'hFF: subbytef=8'h16;
        default: subbytef=8'h0;     
        endcase
 end
endfunction
/**********end of functions*********/
endmodule