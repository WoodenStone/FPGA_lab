`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 13:55:51
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [24:0] instruction,
    input [2:0] sext_op,
    output reg [31:0] ext_number
    );

    always @(*) begin
        case (sext_op) 
            `I_type_ext_unsigned:   //I-type-shift
                ext_number = {20'b0, instruction[24:13]};
            `I_type_ext:    //I-type-other
                ext_number = {{20{instruction[24]}}, instruction[24:13]};
            `S_type_ext:   //S-type
                ext_number = {{20{instruction[24]}}, instruction[24:18], instruction[4:0]};
            `B_type_ext:   //B-type
                ext_number = {{20{instruction[24]}}, instruction[24], instruction[0], instruction[23:18], instruction[4:1]};
            `U_type_ext:   //U-type
                ext_number = {instruction[24:5], 12'b0};
            `J_type_ext:   //J-type
                ext_number = {{12{instruction[24]}}, instruction[24], instruction[12:5], instruction[13], instruction[23:14]};
            default:
                ext_number = 32'h0;
        endcase
    end
endmodule
