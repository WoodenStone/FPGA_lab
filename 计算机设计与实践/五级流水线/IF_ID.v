
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/10 13:43:32
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input rst_n,
    input clk,

    input [31:0] IF_PC,
	input [31:0] IF_instruction,

    output reg [31:0] instruction_ID,
	output reg [31:0] PC_ID,

    //no control signals registered
    //stall signal
    input stall,
    input stall_j,
    output reg stall_j_ID
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n ) begin
            instruction_ID <= 32'h0;
            PC_ID <= 32'hffff_fffc;
            stall_j_ID <= 0;
        end else if (stall) begin   //for l-u hazard, hold
            instruction_ID <= instruction_ID;
            PC_ID <= PC_ID;
        end else begin
            instruction_ID <= IF_instruction;
            PC_ID <= IF_PC;
            stall_j_ID <= stall_j;
        end
    end
endmodule
