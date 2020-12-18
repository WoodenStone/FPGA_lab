`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 13:55:48
// Design Name: 
// Module Name: key_filter
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


module key_filter(input clk, input key, output reg result = 0);
 reg [3:0] count = 0;
 always @(posedge clk)
    begin
        if(count >= 4'd10 && result == 0)
            begin
                result <= 1;
            end
        if(key == 0)
            begin 
                count <= 0;
                result <= 0;
            end
        else if(count < 4'd10)
            begin
                count <= count + 1;
            end
    end
endmodule
