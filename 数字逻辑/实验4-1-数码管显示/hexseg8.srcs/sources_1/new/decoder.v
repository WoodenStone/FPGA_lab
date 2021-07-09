`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/11 14:29:45
// Design Name: 
// Module Name: decoder
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


module decoder(num,clk,led);
    input [3:0] num;
    input clk;
    output reg [7:0] led;
    
    always@(posedge clk) begin
        case(num)
               4'h0: begin led<=8'b11111100; end
               4'h1: begin led<=8'b01100000; end
               4'h2: begin led<=8'b11011010; end
               4'h3: begin led<=8'b11110010; end
               4'h4: begin led<=8'b01100110; end
               4'h5: begin led<=8'b10110110; end
               4'h6: begin led<=8'b10111110; end
               4'h7: begin led<=8'b11100000; end
               4'h8: begin led<=8'b11111110; end
               4'h9: begin led<=8'b11110110; end
               4'ha: begin led<=8'b11101110; end
               4'hb: begin led<=8'b00111110; end
               4'hc: begin led<=8'b00011010; end
               4'hd: begin led<=8'b01111010; end
               4'he: begin led<=8'b10011110; end
               4'hf: begin led<=8'b10001110; end
               default: begin led<=8'b00000000; end
        endcase
    end
endmodule
