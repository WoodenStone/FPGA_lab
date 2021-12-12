`include "param.v"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 09:57:42
// Design Name: 
// Module Name: ALU
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


module ALU(
	input [31:0] operandA,
	input [31:0] operandB,
	input [3:0] ALU_mode,
	
	output reg [1:0] zero,	//branch comparison result
	output reg [31:0] ALU_result
    );
	
	wire [31:0] shift_result;
	
	shifter32 U_shifter (
		.operand	(operandA),
		.shift_time	(operandB[5:0]),
		.ALU_mode	(ALU_mode),
		.shift_result	(shift_result)
	);
	
	always@(*) begin
		case (ALU_mode)
			`ADD:
				ALU_result = operandA + operandB;
			`SUB:
				ALU_result = operandA - operandB;
			`AND:
				ALU_result = operandA & operandB;
			`OR:
				ALU_result = operandA | operandB;
			`XOR:
				ALU_result = operandA ^ operandB;
			`SLL, `SRL, `SRA:
				ALU_result = shift_result;
			`LUI: ALU_result = operandB;
			`NOP_ALU:
			    ALU_result = 32'h0;
			default: ;
		endcase
	end
	
	always@(*) begin
		if (ALU_result == 32'h0) zero = `EQUAL;
		else if (ALU_result[31] == 0) zero = `GREATER;
		else if (ALU_result[31] == 1) zero = `LESS;
		else zero = `OTHER;
	end
	
endmodule
