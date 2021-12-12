
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 10:13:35
// Design Name: 
// Module Name: forwarding_sl
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


module forwarding_sl(
    input [31:0] instruction_ID,
    input [4:0] rd_ex,
	input [4:0] rd_mem,
	input [4:0] rd_wb,
    input [31:0] RD2_id,
    input [31:0] ALU_result_ex,
    input [31:0] ALU_result_MEM,
    input [31:0] ALU_result_WB,
    output reg [31:0] dram_data
    );
    
    wire [6:0] opcode_id = instruction_ID[6:0];
    wire [6:0] rs2_id = instruction_ID[24:20];
    
    // for S type, forwarding result is used as write data of DRAM
    always@(*) begin
        if (opcode_id == `S_type && rs2_id != 0 ) begin
                if (rs2_id == rd_ex && rd_ex != 0) dram_data = ALU_result_ex;
                else if (rs2_id == rd_mem && rd_mem != 0) dram_data = ALU_result_MEM;
                else if (rs2_id == rd_wb && rd_wb != 0) dram_data = ALU_result_WB;
                else dram_data = RD2_id;
        end
        else dram_data = RD2_id;
    end
    
endmodule
