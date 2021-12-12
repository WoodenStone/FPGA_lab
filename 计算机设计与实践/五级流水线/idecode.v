`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/30 22:58:03
// Design Name: 
// Module Name: idecode
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


module idecode(
	input clk,
	input rst_n,
	
	input [31:0] instruction_if,
	input [31:0] instruction_EX,
	input [31:0] PC_if,
	input [1:0] zero,
	input [31:0] imm_EX,
	input [2:0] npc_op_EX,
	input [31:0] forwardA_result_EX,
	
	output reg [31:0] NPC
);

	wire [6:0] opcode = instruction_EX[6:0];
	wire [2:0] funct3 = instruction_EX[14:12];
	wire [6:0] opcode_if  = instruction_if[6:0];
    reg branch;
    

	always@(*) begin
		if (opcode == `B_type) begin
			case (funct3)
			3'b000: begin branch = (zero == `EQUAL)? 1'b1 : 1'b0; end
            3'b001: begin branch = (zero == `EQUAL)? 1'b0 : 1'b1; end
            3'b100: begin branch = (zero == `LESS)? 1'b1 : 1'b0; end
			3'b101: begin branch = ((zero == `EQUAL) || (zero == `GREATER))? 1'b1: 1'b0; end
			default:;
			endcase
		end else branch = 0;
	end

    reg  branch_ff;

    always@(posedge clk or negedge rst_n)begin
        if (~rst_n) branch_ff <= 0;
        else branch_ff <= branch;
    end
	
	reg [31:0] NPC_reg;
    always@(posedge clk)begin
        if (~rst_n) NPC_reg <= 0;
        else NPC_reg <= NPC;
    end


	always@(*) begin
			case (npc_op_EX)
				`BRANCH_CHOOSE: begin   //to aviod jumping continuously for 3cc
				    if (branch == 1) begin
				        if (branch_ff == 1 && opcode_if != `B_type) NPC <= NPC_reg +4 ;
				        else  begin 
				            NPC <=  PC_if + (imm_EX << 1) ; end
				     end
				        else NPC <= PC_if + 4;
				    end
				`JUMP_REG: NPC <=  forwardA_result_EX + imm_EX ;
				`JUMP: begin
				        NPC <= PC_if + (imm_EX << 1); 
				        end
				// `NOP_NPC : NPC <= NPC;
				`PLUS_4: NPC <= PC_if + 4;
				default: ;
			endcase
	end
endmodule
