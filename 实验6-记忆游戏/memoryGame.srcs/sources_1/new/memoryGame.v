`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 16:01:42
// Design Name: 
// Module Name: memoryGame
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


/*module memoryGame(
	input clk,
	input [7:0]sw,
	input key0,key1,key2,key3,key4,
	output [3:0] DK1_en,
	output [3:0] DK0_en,
	output [7:0] DN0_K,
	output [7:0] DN1_K
	);
	wire [2:0]state;
	
	Moore u_1(.clk(clk),.state_o(state),.key0(key0),.key1(key1),.key2(key2),.key4(key4));
	dignt_ctrl u_2(.clk(clk),.state(state),.key3(key3),.key0(key0),.sw(sw),.DN0_en(DN0_en),.DN1_en(DN1_en),.DN0_K(DN0_K),.DN1_K(DN1_K));
endmodule
*/