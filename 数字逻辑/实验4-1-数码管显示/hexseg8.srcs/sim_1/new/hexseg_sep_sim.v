`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/12 10:20:02
// Design Name: 
// Module Name: hexseg_sep_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module divider_sep_sim(
    );
    reg clk=1'd0;
    reg s0=1'd0;
    reg rst=1'd0;

    reg [3:0] hex0;
    reg [3:0] hex1;
    reg [7:0] en=8'd0;
    wire key_flag;
    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] len;
    hexseg8 h_1(.hex0(hex0),.hex1(hex1),.en(en),.s0(s0),.clk(clk),.rst(rst),.seg0(seg0),.seg1(seg1),.len(len));
  //module hexseg8(hex0,hex1,en,s0,rst,clk,seg0,seg1,len);
    always begin
        #1 clk=~clk;
    end
   initial begin
        #5 begin en[0]=1;hex0=8'h0; hex1=8'hf; end
        #20 begin en[0]=1;hex0=8'h1; hex1=8'he; end
        #20 begin en[0]=1;hex0=8'h2; hex1=8'hd; end
        #20 begin en[0]=1;hex0=8'h3; hex1=8'hc; end
        #20 begin en[0]=1;hex0=8'h4; hex1=8'hb; end
        #20 begin en[0]=1;hex0=8'h5; hex1=8'ha; end
        #20 begin en[0]=1;hex0=8'h6; hex1=8'h9; end
        #20 begin en[0]=1;hex0=8'h7; hex1=8'h8; end
        #20 begin en[0]=1; hex0=8'h8; hex1=8'h7; end
        #20 begin en[0]=1;hex0=8'h9; hex1=8'h6; end
        #20 begin en[0]=1;hex0=8'ha; hex1=8'h5; end
        #20 begin en[0]=1;hex0=8'hb; hex1=8'h4; end
        #20 begin en[0]=1;hex0=8'hc; hex1=8'h3; end
        #20 begin en[0]=1;hex0=8'hd; hex1=8'h2; end
        #20 begin en[0]=1;hex0=8'he; hex1=8'h1; end
        #20 begin en[0]=1;hex0=8'hf; hex1=8'h0; end
        #20 begin en[0]=0;hex0=8'h6;hex1=8'h6;end
        #20 $finish;
    end
endmodule
