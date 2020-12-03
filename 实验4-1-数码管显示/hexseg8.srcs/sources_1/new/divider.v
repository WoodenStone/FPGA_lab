`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/11 13:56:09
// Design Name: 
// Module Name: divider
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


module divider(clk_i,clk_o);
    input clk_i;
    output reg clk_o;
    reg[16:0] cnt;
    initial begin
        clk_o<=1'b0;
        cnt<=17'd0;
    end
    always@(posedge clk_i) begin
    //降低分频计数数值便于观察现象
    if(cnt==17'd5) begin
       // if(cnt==17'd50000) begin
            cnt<=17'd0;
            clk_o<=~clk_o;
        end
            else cnt<=cnt+1;
        end
endmodule
