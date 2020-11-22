`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 13:52:45
// Design Name: 
// Module Name: flowLED
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


module flowLED(rst_n_i,clk_i,en_i,led_o);
    input rst_n_i;
    input clk_i;
    input en_i;
    output reg [7:0] led_o; 
    
    wire rst=~rst_n_i;
    reg [2:0]cnt=3'b111;
    always @(posedge clk_i or posedge rst) begin
        if(rst===1'b1) begin
            led_o=8'b0;
            cnt=3'b111; 
        end
        else if(en_i===1'b1) begin 
            cnt=(cnt>=3'b111)?3'b000:cnt+1;
            led_o=8'b0000_0000;
            led_o[cnt]=1'b1;
         end
     end
endmodule
