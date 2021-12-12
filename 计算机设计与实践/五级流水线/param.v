//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/30 23:17:25
// Design Name: 
// Module Name: param
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
`ifndef CPU_PARAM
`define CPU_PARAM
//instruction type ////opcode////
`define R_type 7'b0110011
`define I_type 7'b0010011
`define I_type_lw 7'b0000011
`define I_type_jalr 7'b1100111
`define S_type 7'b0100011
`define J_type 7'b1101111
`define B_type 7'b1100011
`define U_type 7'b0110111


//type of immediate ////sext_op////
`define I_type_ext 3'd1
`define S_type_ext 3'd2
`define B_type_ext 3'd3
`define U_type_ext 3'd4
`define J_type_ext 3'd5
`define I_type_ext_unsigned 3'd6

//ALU_mode
`define ADD 4'd1
`define SUB 4'd2
`define AND 4'd3
`define OR 4'd4
`define XOR 4'd5
`define SLL 4'd6
`define SRL 4'd7
`define SRA 4'd8
`define LUI 4'd9
`define NOP_ALU 4'd0

//which to use in the next instruction ///npc_op///
`define PLUS_4 3'd1
`define BRANCH_CHOOSE 3'd2
`define JUMP_REG 3'd3
`define JUMP 3'd4
`define NOP_NPC 3'd0

//result of SUB
`define EQUAL 2'b00
`define GREATER 2'b01
`define LESS 2'b10
`define OTHER 2'b11

//forwarding 
`define NO_forward 2'b00
`define EX_forward 2'b01
`define MEM_forward 2'b10
`define WB_forward 2'b11

`endif