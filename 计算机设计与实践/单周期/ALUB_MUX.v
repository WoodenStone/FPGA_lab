
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 19:34:28
// Design Name: 
// Module Name: ALUB_MUX
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


module ALUB_MUX(
    input alub_sel,
    input [31:0] RD2,
    input [31:0] imm,
    output [31:0] operandB
    );

    assign operandB = (alub_sel == 1) ? imm : RD2;
    
endmodule
