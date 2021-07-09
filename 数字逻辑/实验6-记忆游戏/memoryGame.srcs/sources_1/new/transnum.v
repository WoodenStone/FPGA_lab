`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 18:45:07
// Design Name: 
// Module Name: transnum
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


//每4位将数字转换为数码管输出

module transnum(num,clk,led);
    input [3:0] num;
    input clk;
    output reg [7:0] led;
    
    always@(posedge clk) begin
        case(num)
               4'd0: begin led<=8'b11111100; end
               4'd1: begin led<=8'b01100000; end
               4'd2: begin led<=8'b11011010; end
               4'd3: begin led<=8'b11110010; end
               4'd4: begin led<=8'b01100110; end
               4'd5: begin led<=8'b10110110; end
               4'd6: begin led<=8'b10111110; end
               4'd7: begin led<=8'b11100000; end
			   4'd8: begin led<=8'b00000000; end	//no display
			   4'd9: begin led<=8'b10001110; end	//display F
			   4'd10: begin led<=8'b00000010; end	//display -
               //default: begin led<=8'b00000000; end
        endcase
    end
endmodule