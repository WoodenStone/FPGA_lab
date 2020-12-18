`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 17:28:51
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


module divider_1kHz(
    input clk_i,
    output reg clk_o
    );
    
    reg  [26:0] cnt = 0;
    
    always @(posedge clk_i)
    begin  
      cnt <= (cnt >= 27'd100000) ? 1 : cnt + 1'd1;
      //cnt <= (cnt >= 4'd10) ? 1 : cnt + 1'd1;
      clk_o <= (cnt <= 27'd50000) ? 1 : 0;
      //clk_o <= (cnt <= 3'd5);
    end
endmodule

