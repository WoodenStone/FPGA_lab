`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 20:12:39
// Design Name: 
// Module Name: gcounter_sim
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


module gcounter_sim();
    reg clk_i=1'b0;
    reg rst_n_i=1'b0;
    reg en_i=1'b1;
    wire [3:0] gray_o;
    
    gcounter U1(.clk_i(clk_i),.rst_n_i(rst_n_i),.en_i(en_i),.gray_o(gray_o));
    always begin
        #5 clk_i=~clk_i;
    end
    
    initial begin
        #10 begin rst_n_i=1'b1;  en_i=1'b1;end
        #50 rst_n_i = 1'b0; //清零 
        #20 begin rst_n_i=1'b1; en_i=1'b1; end
        #30 en_i=1'b0; //使能无效
        #10 $finish;
        end
endmodule
