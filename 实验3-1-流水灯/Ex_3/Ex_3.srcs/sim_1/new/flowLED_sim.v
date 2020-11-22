`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 15:29:40
// Design Name: 
// Module Name: flowLED_sim
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


module flowLED_sim();
    reg rst_n_i=0;
    reg clk_i=0;
    reg en_i=1;
    wire [7:0] led_o;
    
    flowLED_top U1(.rst_n_i(rst_n_i),.clk_i(clk_i),.en_i(en_i),.led_o(led_o));
    always begin
        #1 clk_i=~clk_i;
    end
    
    initial begin
        #5 rst_n_i = 1;
        //#2000 en_i = 0;
        #2000 en_i = 1;
    end
endmodule
