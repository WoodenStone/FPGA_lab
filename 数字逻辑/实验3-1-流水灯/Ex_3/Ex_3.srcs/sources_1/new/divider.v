`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 13:52:20
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


module divider(clk_i,rst_n_i,clk_o);
    input clk_i,rst_n_i;
    output reg clk_o;

    reg[35:0]counter=29'd0;
    wire rst=~rst_n_i;
    always @(posedge clk_i or posedge rst) begin
        if (rst == 1'b1) begin
             counter <=29'd0;
        end else begin
                counter<= (counter>=29'd100000000)?1'd0:(counter+1'd1);
        end
        clk_o=(!rst)&(counter<29'd50000000);
    end
 endmodule
