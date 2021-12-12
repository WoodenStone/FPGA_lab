`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 22:27:20
// Design Name: 
// Module Name: WD_MUX
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


module WD_MUX(
    input clk,
    input rst_n,

    input [3:0] wd_sel,
    input [31:0] U_ext_num,
    input [31:0] ALU_result,
    input [31:0] DMEM_rd,
    input [31:0] PC_addr,
    output reg [31:0] WD
    );

    
    always @(*) begin
        if(!rst_n) WD = 32'h0;
        else begin
        case (wd_sel)
            `ALU_C: WD = ALU_result;
            `DMEM_rd:  WD = DMEM_rd;
            `U_ext_num: WD = U_ext_num;
            `PC_addr: WD = PC_addr + 4;
            `DMEM_rd_half: 
                begin
                    if (ALU_result[1:0] == 2'b00) WD = {{16{DMEM_rd[15]}}, DMEM_rd[15:0]};   //整除4则取低半字，否则取高半字
                    else WD = {{16{DMEM_rd[31]}}, DMEM_rd[31:16]};
                end
            `DMEM_rd_byte: begin
                case (ALU_result[1:0])
                    2'b00: WD = {{24{DMEM_rd[7]}}, DMEM_rd[7:0]};
                    2'b01: WD = {{24{DMEM_rd[15]}}, DMEM_rd[15:8]};
                    2'b10: WD = {{24{DMEM_rd[23]}}, DMEM_rd[23:16]};
                    2'b11: WD = {{24{DMEM_rd[31]}}, DMEM_rd[31:24]};
                    default: ;
                endcase
            end
            `DMEM_rd_half_u: 
                begin
                    if (ALU_result[1:0] == 2'b00) WD = {16'h0, DMEM_rd[15:0]};   //整除4则取低半字，否则取高半字
                    else WD = {16'h0, DMEM_rd[31:16]};
                end
            `DMEM_rd_byte_u: begin
                case (ALU_result[1:0])
                    2'b00: WD = {24'h0, DMEM_rd[7:0]};
                    2'b01: WD = {24'h0, DMEM_rd[15:8]};
                    2'b10: WD = {24'h0, DMEM_rd[23:16]};
                    2'b11: WD = {24'h0, DMEM_rd[31:24]};
                    default: ;
                endcase
            end
            `U_pc: WD = U_ext_num + PC_addr;
            default: WD = 32'h0;
        endcase
        end
    end
endmodule
