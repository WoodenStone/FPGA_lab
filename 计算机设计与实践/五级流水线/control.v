
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/10 13:38:51
// Design Name: 
// Module Name: control
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


module control(
    input [31:0] instruction,
    input stall_j,
    output reg we_rf,            //寄存器读写选择
    output reg [2:0] sext_op,    //根据指令选择立即数
    output reg [2:0] wd_sel,     //选择写回寄存器的数据来源
    output reg alub_sel,         //选择传给ALU的数据
    output reg [3:0] ALU_mode,   //ALU操作模式
    output reg [2:0] npc_op,     //choose next pc
    output reg dram_we           //enable writing dram or not 
    );

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction [31:25];


    always @(*) begin
        case (opcode)
            `R_type:
            begin
                we_rf    <= 1'b1;
                sext_op  <= 3'd0;
                wd_sel   <= 3'd1;
                alub_sel <= 1'b0;
                npc_op   <= `PLUS_4;
                dram_we <= 1'b0;
                case (funct3)
                    3'b000: ALU_mode <= funct7[5] ? `SUB : `ADD; //ADD or SUB
                    3'b111: ALU_mode <= `AND;                    //AND
                    3'b110: ALU_mode <= `OR;                     //OR
                    3'b100: ALU_mode <= `XOR;                    //XOR
                    3'b001: ALU_mode <= `SLL;                    //SLL
                    3'b101: ALU_mode <= funct7[5] ? `SRA : `SRL; //SRL or SRA
                    default: ;
                endcase
            end
            `I_type:
            begin
                we_rf <= 1'b1;
                alub_sel <= 1'b1;
                wd_sel <= 3'd1;
                npc_op   <= `PLUS_4;
                dram_we <= 1'b0;
                case (funct3)
                    3'b000: begin ALU_mode <= `ADD; sext_op <= `I_type_ext; end  //ADDI
                    3'b111: begin ALU_mode <= `AND; sext_op <= `I_type_ext; end  //ANDI
                    3'b110: begin ALU_mode <= `OR;  sext_op <= `I_type_ext; end  //ORI
                    3'b100: begin ALU_mode <= `XOR; sext_op <= `I_type_ext; end  //XORI
                    3'b001: begin 
                            ALU_mode <= `SLL;                      //SLLI
                            sext_op <= `I_type_ext_unsigned;
                            end
                    3'b101: begin 
                            ALU_mode <= funct7[5] ? `SRA : `SRL;   //SRLI or SRAI
                            sext_op <= `I_type_ext_unsigned;
                            end
                    default: ;
                endcase
            end
            `I_type_jalr:
            begin
                sext_op <= `I_type_ext;
                we_rf <= 1'b1;
                alub_sel <= 1'b1;
                wd_sel <= 3'd4;
                ALU_mode <= `ADD;
                npc_op   <=  stall_j ? `JUMP_REG : `PLUS_4;
                dram_we <= 1'b0;
            end
            `I_type_lw:
            begin
                sext_op <= `I_type_ext;
                we_rf <= 1'b1;
                alub_sel <= 1'b1;
                wd_sel <= 3'd2;
                ALU_mode <= `ADD;
                npc_op   <= `PLUS_4;
                dram_we <= 1'b0;
            end
            `S_type:
            begin
                sext_op <= `S_type_ext;
                we_rf <= 1'b0;
                alub_sel <= 1'b1;
                wd_sel <= 3'd3;
                ALU_mode <= `ADD;
                npc_op   <= `PLUS_4;
                dram_we <= 1'b1;
            end
            `B_type:
            begin
                sext_op <= `B_type_ext;
                we_rf <= 1'b0;
                alub_sel <= 1'b0;
                wd_sel <= 3'd0;
                ALU_mode <= `SUB;
                npc_op   <= `BRANCH_CHOOSE;
                dram_we <= 1'b0;
            end
            `J_type:
            begin
                sext_op <= `J_type_ext;
                we_rf <= 1'b1;
                alub_sel <= alub_sel;
                wd_sel <= 3'd4;
                ALU_mode <= `ADD;
                npc_op   <= (stall_j) ? `JUMP :`PLUS_4;
                dram_we <= 1'b0;
            end
            `U_type:
            begin
                sext_op <= `U_type_ext;
                we_rf <= 1'b1;
                alub_sel <= 1'b1;
                wd_sel <= 3'd1;
                ALU_mode <= `LUI;
                npc_op   <= `PLUS_4;
                dram_we <= 1'b0;
            end
            7'b0000000:
            begin
                npc_op <= `PLUS_4;
                we_rf <= 0;
            end
            default: ;
        endcase
    end


endmodule