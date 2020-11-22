`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 19:49:10
// Design Name: 
// Module Name: gcounter
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


module gcounter(clk_i,rst_n_i,en_i,gray_o);
    input clk_i,rst_n_i,en_i;
    output [3:0]gray_o;
    reg [3:0]bin;
    wire [3:0]gray_o;

    always@(posedge clk_i or posedge rst_n_i) begin
        if(!rst_n_i) begin bin<=1'd0; end
            else if(en_i) begin  
                bin<=bin+1'd1;
                end
    end
    assign gray_o[3]=bin[3];
    assign gray_o[2]=bin[3]^bin[2];
    assign gray_o[1]=bin[2]^bin[1];
    assign gray_o[0]=bin[1]^bin[0];
endmodule
