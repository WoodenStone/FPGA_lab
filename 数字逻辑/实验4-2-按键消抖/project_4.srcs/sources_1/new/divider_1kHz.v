`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 21:04:54
// Design Name: 
// Module Name: divider_1kHz
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


module divider_1kHz(clk_i,clk_o);
    input clk_i;
    output reg clk_o;
    reg[24:0] cnt;
    initial begin
        clk_o<=1'b0;
        cnt<=24'd0;
    end
    always@(posedge clk_i) begin
 
        if(cnt==24'd50000) begin
            cnt<=24'd0;
            clk_o<=~clk_o;
        end
            else cnt<=cnt+1;
        end
endmodule
