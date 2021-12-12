
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 10:39:55
// Design Name: 
// Module Name: shifter32
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


module shifter32 (
	input [31:0] operand,
	input [5:0] shift_time,
	input [3:0] ALU_mode,
	output reg [31:0] shift_result
);

	reg [31:0] temp;
	
	always@(*) begin
	case (ALU_mode)
		`SRL:
			begin
				temp = shift_time[0] ? {1'b0, operand[31:1]} : operand;
				temp = shift_time[1] ? {2'b0, temp[31:2]} : temp;
				temp = shift_time[2] ? {4'b0, temp[31:4]} : temp;
				temp = shift_time[3] ? {8'b0, temp[31:8]} : temp;
				temp = shift_time[4] ? {16'b0, temp[31:16]} : temp;
				temp = shift_time[5] ? 32'h0 : temp;
			end
		`SLL:
			begin
				temp = shift_time[0] ? {operand[30:0], 1'b0} : operand;
				temp = shift_time[1] ? {temp[29:0], 2'b0} : temp;
				temp = shift_time[2] ? {temp[27:0], 4'b0} : temp;
				temp = shift_time[3] ? {temp[23:0], 8'b0} : temp;
				temp = shift_time[4] ? {temp[15:0], 16'b0} : temp;
				temp = shift_time[5] ? 32'h0 : temp;
			end
		`SRA:
			begin
				temp = shift_time[0] ? {operand[31], operand[31:1]} : operand;
				temp = shift_time[1] ? {{2{operand[31]}}, temp[31:2]} : temp;
				temp = shift_time[2] ? {{4{operand[31]}}, temp[31:4]} : temp;
				temp = shift_time[3] ? {{8{operand[31]}}, temp[31:8]} : temp;
				temp = shift_time[4] ? {{16{operand[31]}}, temp[31:16]} : temp;
				temp = shift_time[5] ? {32{operand[31]}}: temp;
			end
		default: temp = operand;
	endcase
	shift_result = temp;
	end
	
endmodule
