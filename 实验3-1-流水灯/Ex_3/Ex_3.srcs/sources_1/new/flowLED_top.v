`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 13:51:17
// Design Name: 
// Module Name: flowLED_top
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


module flowLED_top(rst_n_i,clk_i,en_i,led_o);
    input rst_n_i,clk_i,en_i;
    output [7:0]led_o;
    wire clk_o;
    
    divider div(.clk_i(clk_i),.rst_n_i(rst_n_i),.clk_o(clk_o));
    flowLED LED(.rst_n_i(rst_n_i),.clk_i(clk_o),.en_i(en_i),.led_o(led_o));
    
endmodule
