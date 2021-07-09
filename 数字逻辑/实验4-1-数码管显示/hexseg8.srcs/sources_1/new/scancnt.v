`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/14 15:10:11
// Design Name: 
// Module Name: scancnt
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


module scancnt(clk,scancnt);

    input clk;
    output reg [2:0]scancnt; 
    wire clock;
    divider u_1(.clk_i(clk),.clk_o(clock));
    //assign clock=5*clk;
    initial begin
        scancnt<=3'd0;
    end
    always@(posedge clock) begin
        if(scancnt==3'd7) scancnt<=3'd0;
        else scancnt<=scancnt+1'd1;
    end
endmodule
