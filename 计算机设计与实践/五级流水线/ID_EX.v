
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/10 13:45:51
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input clk,
    input rst_n,
    //datapath
	input [31:0] ID_PC,
	input [31:0] ID_RD1,	//read_data1 from regfile
	input [31:0] ID_RD2,
	input [31:0] ID_ext_num,
	input [4:0] ID_wR,      //write address of regfile
    input [31:0] ID_instruction,
	input [31:0] ID_operandB,
	input [31:0] dram_data,
	
	output reg [31:0] dram_data_EX,
	//forward
	input [31:0] forwardA_result,
	output reg [31:0] forwardA_result_EX,
 	
	output reg [31:0] RD1_EX,
	output reg [31:0] operandB_EX,
	output reg [31:0] imm_EX,
	output reg [31:0] RD2_EX,
	
    
	//¼ÌÐø´«µÝ
	output reg [31:0] PC_EX,
 	output reg [4:0] wR_EX,
    output reg [31:0] instruction_EX,

    //control signals
    input       ID_we_rf,         
    input [2:0] ID_wd_sel,  
    input [3:0] ID_ALU_mode,
    input [2:0] ID_npc_op,  
    input       ID_dram_we,

    output reg we_rf_EX,         
    output reg [2:0] wd_sel_EX,  
    output reg [3:0] ALU_mode_EX,
    output reg [2:0] npc_op_EX,  
    output reg dram_we_EX,
    
    //stall signal
    input stall,
    input stall_j_ID,
    output reg stall_j_EX
    );

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            RD1_EX      <= 0;
            imm_EX      <= 0;
            RD2_EX      <= 0;
            PC_EX       <= 32'hffff_fffc;
            wR_EX       <= 0;
            we_rf_EX    <= 0;
            wd_sel_EX   <= 0;
            ALU_mode_EX <= 0;
            npc_op_EX   <= 1;
            dram_we_EX  <= 0;
            instruction_EX <= 0;
            operandB_EX <= 0;
            forwardA_result_EX <= 0;
            dram_data_EX<=0;
        end else if (stall ) begin
            we_rf_EX <= 0;
            wd_sel_EX <= 0;
            ALU_mode_EX <= `NOP_ALU;
            npc_op_EX <= ID_npc_op;
            dram_we_EX <= 0;
            stall_j_EX <= stall_j_ID;
			PC_EX       <= ID_PC       ;
			instruction_EX <= (stall_j_ID) ? ID_instruction : instruction_EX;
			imm_EX      <= ID_ext_num  ;
        end else begin
            RD1_EX      <= ID_RD1      ;
            imm_EX      <= ID_ext_num  ;
            RD2_EX      <= ID_RD2      ;
            PC_EX       <= ID_PC       ;
            wR_EX       <= ID_wR       ;
            we_rf_EX    <= ID_we_rf    ;
            wd_sel_EX   <= ID_wd_sel   ;
            ALU_mode_EX <= ID_ALU_mode ;
            npc_op_EX   <= ID_npc_op   ;
            dram_we_EX  <= ID_dram_we  ;
            instruction_EX <= ID_instruction;
            operandB_EX <= ID_operandB;
            forwardA_result_EX <= forwardA_result;
            stall_j_EX <= stall_j_ID;
            dram_data_EX <= dram_data;
        end
    end
endmodule
