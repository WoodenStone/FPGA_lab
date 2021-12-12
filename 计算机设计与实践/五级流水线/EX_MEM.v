
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/10 14:22:10
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input clk,
    input rst_n,
    //datapath
    input [31:0] EX_ALU_result,
    input [4:0]  EX_wR,
    input [31:0] EX_PC,
    input [31:0] EX_imm,
    input [31:0] EX_instruction,
    input [31:0] EX_dram_data,
    output reg [31:0] dram_data_MEM,
    output reg [31:0] imm_MEM,
    output reg [31:0] ALU_result_MEM,
    output reg [4:0]  wR_MEM,
    output reg [31:0] PC_MEM,
    output reg [31:0] instruction_MEM,
    //control signals
    input       EX_we_rf,         
    input [2:0] EX_wd_sel,  
    input       EX_dram_we,

    output reg we_rf_MEM,         
    output reg [2:0] wd_sel_MEM,  
    output reg dram_we_MEM,
    
    input stall_j_EX,
    output reg stall_j_MEM
    );



    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ALU_result_MEM  <= 0;
            wR_MEM          <= 0;
            we_rf_MEM       <= 0;
            wd_sel_MEM      <= 0;
            dram_we_MEM     <= 0;
            imm_MEM         <= 0;
            PC_MEM          <= 32'h0;
            instruction_MEM <= 32'h0;
            dram_data_MEM<=0;
        end else begin
            ALU_result_MEM  <= EX_ALU_result ;
            wR_MEM          <= EX_wR         ;
            we_rf_MEM       <= EX_we_rf      ;
            wd_sel_MEM      <= EX_wd_sel     ;
            dram_we_MEM     <= EX_dram_we    ;
            imm_MEM         <= EX_imm        ;
            PC_MEM          <= EX_PC         ;
            instruction_MEM <= EX_instruction;
            stall_j_MEM <= stall_j_EX;
            dram_data_MEM<=EX_dram_data;
        end
    end

endmodule
