`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/14 15:05:45
// Design Name: 
// Module Name: forwardA_MUX
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

module forwardA_MUX(
	input [31:0] RD1,
	input [31:0] ALU_result,
	input [31:0] ALU_result_MEM,
	input [31:0] ALU_result_WB,
	
	input [1:0] forwardA,
	
	output reg [31:0] forwardA_result
);
	
	always@(*) begin
		case (forwardA)
			`NO_forward: forwardA_result = RD1;
			`EX_forward: forwardA_result = ALU_result;
			`MEM_forward: forwardA_result = ALU_result_MEM;
			`WB_forward: forwardA_result = ALU_result_WB;
			default: forwardA_result = RD1;
	endcase
	end
endmodule