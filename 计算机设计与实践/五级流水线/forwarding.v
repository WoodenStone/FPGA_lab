`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/14 15:03:12
// Design Name: 
// Module Name: forwarding
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


module forwarding(
	input [4:0] rs1_id,
	input [4:0] rs2_id,
	input [4:0] rd_ex,
	input [4:0] rd_mem,
	input [4:0] rd_wb,

	input we_rf_ex,
	input we_rf_mem,
	input we_rf_wb,
	
	input [31:0] instruction_ID, 
	input [31:0] instruction_MEM,
	input [31:0] instruction_WB,
	output reg [1:0] forwardA,
	output reg [1:0] forwardB
);

	wire [6:0] opcode = instruction_ID[6:0];
	wire [6:0] opcode_wb = instruction_WB[6:0];
	wire [6:0] opcode_mem = instruction_MEM[6:0];
	
	// detect at ID stage
	// for rs1 R I S B will use rs1
	// should not forward during stall bc opcode will not change
	always@(*) begin
		if (opcode == `R_type || opcode == `I_type || opcode == `S_type ||opcode == `B_type ||opcode == `I_type_jalr ||opcode == `I_type_lw) begin
			if (we_rf_ex && rd_ex != 0 && rs1_id == rd_ex) forwardA = `EX_forward;
			else if (we_rf_mem && rd_mem != 0 && rs1_id == rd_mem && opcode_mem != `I_type_jalr && opcode_mem != `J_type && opcode_mem!= `B_type) forwardA = `MEM_forward;
			else if (we_rf_wb && rd_wb != 0 && rs1_id == rd_wb && opcode_wb != `I_type_jalr && opcode_wb != `J_type && opcode_wb!= `B_type) forwardA = `WB_forward;
			else forwardA = `NO_forward;
		end
	end

	// for rs2. attention ALUB_MUX.RD2 should be changed into forward result
	// only R S B have rs2
	
	always@(*) begin
		if (opcode == `R_type ||opcode == `B_type) begin
                if (we_rf_ex && rd_ex != 0 && (rs2_id == rd_ex ) ) forwardB = `EX_forward;
                else if (we_rf_mem && rd_mem != 0 && rs2_id == rd_mem && opcode_mem != `J_type && opcode_mem != `I_type_jalr && opcode_mem!= `B_type) forwardB = `MEM_forward;
                else if (we_rf_wb && rd_wb != 0 && rs2_id == rd_wb&& opcode_wb != `J_type && opcode_wb != `I_type_jalr && opcode_wb!= `B_type) forwardB = `WB_forward;
                else forwardB = `NO_forward;
		end
	end
	
	
endmodule
