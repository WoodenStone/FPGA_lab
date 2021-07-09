module cordic
(
    input  wire        clk      ,
    input  wire        rst_n    ,
    input  wire        reg_wr   ,
    input  wire        reg_rd   ,
    input  wire [3:0]  reg_byte ,
    input  wire [3:0]  reg_addr ,
    input  wire [31:0] reg_wdata,
    output reg  [31:0] reg_rdata
);

reg        start  ;
reg        finish ;
reg        func   ;
reg [31:0] phase  ;
reg [31:0] result ;
reg [5:0]  cnt    ;
reg        vld    ;

wire cnt_end = vld & (cnt == 6'h11);

wire vld_d = start ? 1'b1 : cnt_end ? 1'b0 : vld;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)       cnt <= 6'h0;
    else if (cnt_end) cnt <= 6'h0;
    else if (vld)     cnt <= cnt + 6'h1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) vld <= 1'b0;
    else        vld <= vld_d;
end

reg signed [31:0] sin;
reg signed [31:0] cos;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)               result <= 32'h0;
    else if (start)           result <= 32'h0;
    else if (cnt_end & func)  result <= cos;
    else if (cnt_end & ~func) result <= sin;
end

wire start_wr  = reg_wr & (reg_addr == 4'h0);
wire phase_wr = reg_wr & (reg_addr == 4'h1);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                      start <= 1'b0;
    else if (start_wr & reg_byte[0]) start <= reg_wdata[0];
    else                             start <= 1'b0;
end
  
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                      func <= 1'b0;
    else if (start_wr & reg_byte[1]) func <= reg_wdata[8];
end

wire start_d = start_wr & reg_byte[0] & reg_wdata[0];

wire finish_inv_d = start_wr & reg_byte[1] & reg_wdata[8];

wire finish_clr = start_d & finish_inv_d;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                      finish <= 1'b0;
    else if (start_wr & reg_byte[2]) finish <= reg_wdata[16];
    else if (finish_clr)             finish <= 1'b0;
    else if (vld & cnt_end)          finish <= 1'b1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                      phase[7:0] <= 8'h00;
    else if (phase_wr & reg_byte[0]) phase[7:0] <= reg_wdata[7:0];
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                      phase[15:8] <= 8'h00;
    else if (phase_wr & reg_byte[1]) phase[15:8] <= reg_wdata[15:8];
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                      phase[23:16] <= 8'h00;
    else if (phase_wr & reg_byte[2]) phase[23:16] <= reg_wdata[23:16];
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                      phase[31:24] <= 8'h00;
    else if (phase_wr & reg_byte[3]) phase[31:24] <= reg_wdata[31:24];
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) reg_rdata <= 32'h0;
    else if (reg_rd) begin
	case (reg_addr) 
            4'h0 : reg_rdata <= {15'h0,finish,7'h0,func,7'h0,start};
	    4'h1 : reg_rdata <= phase;
	    4'h2 : reg_rdata <= result;
	    default : reg_rdata <= 32'h0;
	endcase
    end
end

`define rot0  32'd2949120       //45度*2^16
`define rot1  32'd1740992       //26.5651度*2^16
`define rot2  32'd919872        //14.0362度*2^16
`define rot3  32'd466944        //7.1250度*2^16
`define rot4  32'd234368        //3.5763度*2^16
`define rot5  32'd117312        //1.7899度*2^16
`define rot6  32'd58688         //0.8952度*2^16
`define rot7  32'd29312         //0.4476度*2^16
`define rot8  32'd14656         //0.2238度*2^16
`define rot9  32'd7360          //0.1119度*2^16
`define rot10 32'd3648          //0.0560度*2^16
`define rot11 32'd1856          //0.0280度*2^16
`define rot12 32'd896           //0.0140度*2^16
`define rot13 32'd448           //0.0070度*2^16
`define rot14 32'd256           //0.0035度*2^16
`define rot15 32'd128           //0.0018度*2^16

parameter Pipeline = 16;
parameter K = 32'h09b74;    //K=0.607253*2^16,32'h09b74,

reg signed [31:0] error;
reg signed [31:0] x0=0,y0=0,z0=0;
reg signed [31:0] x1=0,y1=0,z1=0;
reg signed [31:0] x2=0,y2=0,z2=0;
reg signed [31:0] x3=0,y3=0,z3=0;
reg signed [31:0] x4=0,y4=0,z4=0;
reg signed [31:0] x5=0,y5=0,z5=0;
reg signed [31:0] x6=0,y6=0,z6=0;
reg signed [31:0] x7=0,y7=0,z7=0;
reg signed [31:0] x8=0,y8=0,z8=0;
reg signed [31:0] x9=0,y9=0,z9=0;
reg signed [31:0] x10=0,y10=0,z10=0;
reg signed [31:0] x11=0,y11=0,z11=0;
reg signed [31:0] x12=0,y12=0,z12=0;
reg signed [31:0] x13=0,y13=0,z13=0;
reg signed [31:0] x14=0,y14=0,z14=0;
reg signed [31:0] x15=0,y15=0,z15=0;
reg signed [31:0] x16=0,y16=0,z16=0;
reg        [ 1:0] Quadrant [Pipeline:0];

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x0 <= 1'b0;                         
        y0 <= 1'b0;
        z0 <= 1'b0;
    end
    else if (start)
    begin
        x0 <= K;
        y0 <= 32'd0;
        z0 <= phase[15:0] << 16;
    end
    else
    begin
        x0 <= 32'h0;                         
        y0 <= 32'h0;
        z0 <= 32'h0;
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x1 <= 1'b0;                         
        y1 <= 1'b0;
        z1 <= 1'b0;
    end
    else if(z0[31])
    begin
      x1 <= x0 + y0;
      y1 <= y0 - x0;
      z1 <= z0 + `rot0;
    end
    else
    begin
      x1 <= x0 - y0;
      y1 <= y0 + x0;
      z1 <= z0 - `rot0;
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x2 <= 1'b0;                         
        y2 <= 1'b0;
        z2 <= 1'b0;
    end
    else if(z1[31])
   begin
        x2 <= x1 + (y1 >>> 1);
        y2 <= y1 - (x1 >>> 1);
        z2 <= z1 + `rot1;
   end
   else
   begin
       x2 <= x1 - (y1 >>> 1);
       y2 <= y1 + (x1 >>> 1);
       z2 <= z1 - `rot1;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x3 <= 1'b0;                         
        y3 <= 1'b0;
        z3 <= 1'b0;
    end
    else if(z2[31])
   begin
       x3 <= x2 + (y2 >>> 2);
       y3 <= y2 - (x2 >>> 2);
       z3 <= z2 + `rot2;
   end
   else
   begin
       x3 <= x2 - (y2 >>> 2);
       y3 <= y2 + (x2 >>> 2);
       z3 <= z2 - `rot2;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x4 <= 1'b0;                         
        y4 <= 1'b0;
        z4 <= 1'b0;
    end
    else if(z3[31])
   begin
       x4 <= x3 + (y3 >>> 3);
       y4 <= y3 - (x3 >>> 3);
       z4 <= z3 + `rot3;
   end
   else
   begin
       x4 <= x3 - (y3 >>> 3);
       y4 <= y3 + (x3 >>> 3);
       z4 <= z3 - `rot3;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x5 <= 1'b0;                         
        y5 <= 1'b0;
        z5 <= 1'b0;
    end
    else if(z4[31])
   begin
       x5 <= x4 + (y4 >>> 4);
       y5 <= y4 - (x4 >>> 4);
       z5 <= z4 + `rot4;
   end
   else
   begin
       x5 <= x4 - (y4 >>> 4);
       y5 <= y4 + (x4 >>> 4);
       z5 <= z4 - `rot4;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x6 <= 1'b0;                         
        y6 <= 1'b0;
        z6 <= 1'b0;
    end
    else if(z5[31])
   begin
       x6 <= x5 + (y5 >>> 5);
       y6 <= y5 - (x5 >>> 5);
       z6 <= z5 + `rot5;
   end
   else
   begin
       x6 <= x5 - (y5 >>> 5);
       y6 <= y5 + (x5 >>> 5);
       z6 <= z5 - `rot5;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x7 <= 1'b0;                         
        y7 <= 1'b0;
        z7 <= 1'b0;
    end
    else if(z6[31])
   begin
       x7 <= x6 + (y6 >>> 6);
       y7 <= y6 - (x6 >>> 6);
       z7 <= z6 + `rot6;
   end
   else
   begin
       x7 <= x6 - (y6 >>> 6);
       y7 <= y6 + (x6 >>> 6);
       z7 <= z6 - `rot6;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x8 <= 1'b0;                         
        y8 <= 1'b0;
        z8 <= 1'b0;
    end
    else if(z7[31])
   begin
       x8 <= x7 + (y7 >>> 7);
       y8 <= y7 - (x7 >>> 7);
       z8 <= z7 + `rot7;
   end
   else
   begin
       x8 <= x7 - (y7 >>> 7);
       y8 <= y7 + (x7 >>> 7);
       z8 <= z7 - `rot7;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x9 <= 1'b0;                         
        y9 <= 1'b0;
        z9 <= 1'b0;
    end
    else if(z8[31])
   begin
       x9 <= x8 + (y8 >>> 8);
       y9 <= y8 - (x8 >>> 8);
       z9 <= z8 + `rot8;
   end
   else
   begin
       x9 <= x8 - (y8 >>> 8);
       y9 <= y8 + (x8 >>> 8);
       z9 <= z8 - `rot8;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x10 <= 1'b0;                        
        y10 <= 1'b0;
        z10 <= 1'b0;
    end
    else if(z9[31])
   begin
       x10 <= x9 + (y9 >>> 9);
       y10 <= y9 - (x9 >>> 9);
       z10 <= z9 + `rot9;
   end
   else
   begin
       x10 <= x9 - (y9 >>> 9);
       y10 <= y9 + (x9 >>> 9);
       z10 <= z9 - `rot9;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x11 <= 1'b0;                        
        y11 <= 1'b0;
        z11 <= 1'b0;
    end
    else if(z10[31])
   begin
       x11 <= x10 + (y10 >>> 10);
       y11 <= y10 - (x10 >>> 10);
       z11 <= z10 + `rot10;
   end
   else
   begin
       x11 <= x10 - (y10 >>> 10);
       y11 <= y10 + (x10 >>> 10);
       z11 <= z10 - `rot10;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x12 <= 1'b0;                        
        y12 <= 1'b0;
        z12 <= 1'b0;
    end
    else if(z11[31])
   begin
       x12 <= x11 + (y11 >>> 11);
       y12 <= y11 - (x11 >>> 11);
       z12 <= z11 + `rot11;
   end
   else
   begin
       x12 <= x11 - (y11 >>> 11);
       y12 <= y11 + (x11 >>> 11);
       z12 <= z11 - `rot11;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x13 <= 1'b0;                        
        y13 <= 1'b0;
        z13 <= 1'b0;
    end
    else if(z12[31])
   begin
       x13 <= x12 + (y12 >>> 12);
       y13 <= y12 - (x12 >>> 12);
       z13 <= z12 + `rot12;
   end
   else
   begin
       x13 <= x12 - (y12 >>> 12);
       y13 <= y12 + (x12 >>> 12);
       z13 <= z12 - `rot12;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x14 <= 1'b0;                        
        y14 <= 1'b0;
        z14 <= 1'b0;
    end
    else if(z13[31])
   begin
       x14 <= x13 + (y13 >>> 13);
       y14 <= y13 - (x13 >>> 13);
       z14 <= z13 + `rot13;
   end
   else
   begin
       x14 <= x13 - (y13 >>> 13);
       y14 <= y13 + (x13 >>> 13);
       z14 <= z13 - `rot13;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x15 <= 1'b0;                        
        y15 <= 1'b0;
        z15 <= 1'b0;
    end
    else if(z14[31])
   begin
       x15 <= x14 + (y14 >>> 14);
       y15 <= y14 - (x14 >>> 14);
       z15 <= z14 + `rot14;
   end
   else
   begin
       x15 <= x14 - (y14 >>> 14);
       y15 <= y14 + (x14 >>> 14);
       z15 <= z14 - `rot14;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x16 <= 1'b0;                        
        y16 <= 1'b0;
        z16 <= 1'b0;
    end
    else if(z15[31])
   begin
       x16 <= x15 + (y15 >>> 15);
       y16 <= y15 - (x15 >>> 15);
       z16 <= z15 + `rot15;
   end
   else
   begin
       x16 <= x15 - (y15 >>> 15);
       y16 <= y15 + (x15 >>> 15);
       z16 <= z15 - `rot15;
   end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        Quadrant[0] <= 1'b0;
        Quadrant[1] <= 1'b0;
        Quadrant[2] <= 1'b0;
        Quadrant[3] <= 1'b0;
        Quadrant[4] <= 1'b0;
        Quadrant[5] <= 1'b0;
        Quadrant[6] <= 1'b0;
        Quadrant[7] <= 1'b0;
        Quadrant[8] <= 1'b0;
        Quadrant[9] <= 1'b0;
        Quadrant[10] <= 1'b0;
        Quadrant[11] <= 1'b0;
        Quadrant[12] <= 1'b0;
        Quadrant[13] <= 1'b0;
        Quadrant[14] <= 1'b0;
        Quadrant[15] <= 1'b0;
        Quadrant[16] <= 1'b0;
    end
    else
    begin
        Quadrant[0] <= phase[17:16];
        Quadrant[1] <= Quadrant[0];
        Quadrant[2] <= Quadrant[1];
        Quadrant[3] <= Quadrant[2];
        Quadrant[4] <= Quadrant[3];
        Quadrant[5] <= Quadrant[4];
        Quadrant[6] <= Quadrant[5];
        Quadrant[7] <= Quadrant[6];
        Quadrant[8] <= Quadrant[7];
        Quadrant[9] <= Quadrant[8];
        Quadrant[10] <= Quadrant[9];
        Quadrant[11] <= Quadrant[10];
        Quadrant[12] <= Quadrant[11];
        Quadrant[13] <= Quadrant[12];
        Quadrant[14] <= Quadrant[13];
        Quadrant[15] <= Quadrant[14];
        Quadrant[16] <= Quadrant[15];
    end
end

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        cos <= 1'b0;
        sin <= 1'b0;
        error <= 1'b0;
    end
    else
    begin
        error <= z16;
        case(Quadrant[16])
            2'b00: //if the phase is in first Quadrant,the sin(X)=sin(A),cos(X)=cos(A)
                begin
                    cos <= x16;
                    sin <= y16;
                end
            2'b01: //if the phase is in second Quadrant,the sin(X)=sin(A+90)=cosA,cos(X)=cos(A+90)=-sinA
                begin
                    cos <= ~(y16) + 1'b1;//-sin
                    sin <= x16;//cos
                end
            2'b10: //if the phase is in third Quadrant,the sin(X)=sin(A+180)=-sinA,cos(X)=cos(A+180)=-cosA
                begin
                    cos <= ~(x16) + 1'b1;//-cos
                    sin <= ~(y16) + 1'b1;//-sin
                end
            2'b11: //if the phase is in forth Quadrant,the sin(X)=sin(A+270)=-cosA,cos(X)=cos(A+270)=sinA
                begin
                    cos <= y16;//sin
                    sin <= ~(x16) + 1'b1;//-cos
                end
        endcase
    end
end

endmodule

