`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/13 20:45:18
// Design Name: 
// Module Name: stall
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:  to solve load-use data hazard
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stall(
	input clk,
	input rst_n,
	input [31:0] instruction_if,
	input [31:0] instruction_ID,
	input [31:0] instruction_EX,
	input [31:0] instruction_MEM,
	input [31:0] instruction_WB,
	input [4:0] rd_ex,
	input [4:0] rd_mem,
	input [4:0] rd_wb, 
	output  stall,
	output stall_j
);

    wire [6:0] opcode_if = instruction_if[6:0];
    wire [6:0] opcode_ex = instruction_EX[6:0];
	wire [6:0] opcode_cur = instruction_ID[6:0];
	wire [6:0] opcode_mem = instruction_MEM[6:0];
	wire [6:0] opcode_wb = instruction_WB[6:0];
	wire [4:0] rd_lw_ex = instruction_EX[11:7];
	wire [4:0] rd_lw_mem = instruction_MEM[11:7];
	wire [4:0] rd_lw_wb = instruction_WB[11:7];
    wire [4:0] rs1_id = instruction_ID[19:15];
    wire [4:0] rs2_id = instruction_ID[24:20];

    reg [5:0] cnt;

    //detect load-use hazard
	always@(*) begin
		if (opcode_cur == `R_type || `S_type || `B_type) begin
			if (opcode_ex == `I_type_lw && rd_lw_ex != 5'h0 && (rs1_id == rd_ex || rs2_id == rd_ex))  cnt = 4;
			else if (opcode_mem == `I_type_lw && rd_lw_mem != 5'h0 && (rs1_id == rd_mem || rs2_id == rd_mem)) cnt = 3;
			else if (opcode_wb == `I_type_lw && rd_lw_wb != 5'h0 && (rs1_id == rd_wb || rs2_id == rd_wb)) cnt = 2;
			else cnt = 0;
		end else if (opcode_cur == `I_type || `I_type_jalr || `I_type_lw) begin
			if (opcode_ex == `I_type_lw && rd_lw_ex != 5'h0 && rs1_id == rd_ex)  cnt = 4;
			else if (opcode_mem == `I_type_lw && rd_lw_mem != 5'h0 && rs1_id == rd_mem) cnt = 3;
			else if (opcode_wb == `I_type_lw && rd_lw_wb != 5'h0 && rs1_id == rd_wb) cnt = 2;
			else cnt = 0;
		end else cnt = 0;
	end
    
	reg [5:0] counter;
	always@(posedge clk or negedge rst_n) begin
        if (!rst_n) counter <= 0;
        else counter <= (counter < cnt)? counter+1  : cnt;
    end  
    
    	
	reg [3:0] cnt_j;
	
	always@(*) begin
	   if (opcode_if == `J_type|| opcode_if == `I_type_jalr|| opcode_if == `B_type ) cnt_j = 2;
	   else cnt_j = 0;
	end
	
	reg [31:0] counter_j;
	always@(posedge clk or negedge rst_n) begin
        if (!rst_n) counter_j <= 0;
        else if(opcode_if == `B_type && opcode_cur == `B_type && opcode_ex == `B_type && counter_j == cnt_j) counter_j <= 0;
        else if (opcode_if == `J_type && opcode_cur == `J_type && opcode_ex == `J_type && counter_j == cnt_j) counter_j <= 0;
        else if (opcode_if == `I_type_jalr && opcode_cur == `I_type_jalr && opcode_ex == `I_type_jalr && counter_j == cnt_j) counter_j <= 0;
        else if (opcode_if == `B_type && counter_j == cnt_j) counter_j <= 0;
		else counter_j <= (counter_j < cnt_j)? counter_j+1  : cnt_j;
    end  
	

    assign stall = rst_n ?(counter < cnt) :0;
    assign stall_j = rst_n ? (counter_j < cnt_j) : 0;

endmodule
