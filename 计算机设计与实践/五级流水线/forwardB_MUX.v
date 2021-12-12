`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/14 15:05:45
// Design Name: 
// Module Name: forwardB_MUX
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


module forwardB_MUX(
	input [31:0] RD2,
	input [31:0] ALU_result,
	input [31:0] ALU_result_MEM,
	input [31:0] ALU_result_WB,
	
	input [1:0] forwardB,
	
	output reg [31:0] forwardB_result
);

	always@(*) begin
		case (forwardB)
			`NO_forward: forwardB_result = RD2;
			`EX_forward: forwardB_result = ALU_result;
			`MEM_forward: forwardB_result = ALU_result_MEM;
			`WB_forward: forwardB_result = ALU_result_WB;
			default: forwardB_result = RD2;
        endcase
	end
	
endmodule
