
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/10 15:21:47
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clk,
    input rst_n,

    //datapath
    input [31:0] MEM_DMEM_rd,
    input [31:0] MEM_ALU_result,
    input [4:0]  MEM_wR,
    input [31:0] MEM_imm,
    input [31:0] MEM_PC,
    input [31:0] MEM_instruction,
    
    output reg [31:0] instruction_WB,
    output reg [31:0] PC_WB,
    output reg [31:0] imm_WB,
    output reg [4:0]  wR_WB,
    output reg [31:0] DMEM_rd_WB,
    output reg [31:0] ALU_result_WB,

    //control signals
    input MEM_we_rf,
    input [2:0] MEM_wd_sel,
    input stall_j_MEM,

    output reg we_rf_WB,
    output reg [2:0] wd_sel_WB,
    output reg stall_j_WB
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wR_WB           <= 0;
            DMEM_rd_WB      <= 0;
            ALU_result_WB   <= 0;
            we_rf_WB        <= 0;
            wd_sel_WB       <= 0;
            imm_WB          <= 0;
            PC_WB       <=32'h0;
            instruction_WB <= 32'h0;
        end else begin
            wR_WB           <= MEM_wR        ;
            DMEM_rd_WB      <= MEM_DMEM_rd   ;
            ALU_result_WB   <= MEM_ALU_result;
            we_rf_WB        <= MEM_we_rf     ;
            wd_sel_WB       <= MEM_wd_sel    ;
            imm_WB          <= MEM_imm       ;
            PC_WB       <= MEM_PC;
            instruction_WB <= MEM_instruction;
            stall_j_WB <= stall_j_MEM;
        end
    end
endmodule
