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
    reg [3:0] hex0;
    reg [3:0] hex1;
    reg [7:0] en=8'd0;
    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] len;
    hexseg8 h_1(.hex0(hex0),.hex1(hex1),.en(en),.s0(s0),.clk(clk),.seg0(seg0),.seg1(seg1),.len(len));
    always begin
        #1 clk=~clk;
    end
   initial begin
        #5 begin en=8'b00000000; hex0=8'hf; hex1=8'hf; end 
        #30 begin en=8'b00000001;hex0=8'hf; hex1=8'hf; end
       #300 begin en=8'b00000010;hex0=8'h1; hex1=8'he; end
        #300 begin en=8'b00000100;hex0=8'h2; hex1=8'hd; end
        #300 begin en=8'b00001000;hex0=8'h3; hex1=8'hc; end
        #300 begin en=8'b00010000;hex0=8'h4; hex1=8'hb; end
        #300 begin en=8'b00100000;hex0=8'h5; hex1=8'ha; end
        #300 begin en=8'b01000000;hex0=8'h6; hex1=8'h9; end
        #300 begin en=8'b10000000;hex0=8'h7; hex1=8'h8; end
        #300 $finish;
    end
endmodule
