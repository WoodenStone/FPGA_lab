`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/07 19:07:13
// Design Name: 
// Module Name: dffe
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

module dffe(
    input clk,
    input clrn,
    input d,
    input wen,
    output reg q
    );
    
    always @(posedge clk or negedge clrn)
    begin
        if(!clrn)
        begin
            q<=1'b0;
           end
        else if(!wen)
        begin 
            q<=d;
            end
         else
            begin q<=q;
            end
    end
endmodule

