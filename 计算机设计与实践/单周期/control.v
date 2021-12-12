
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/07/01 15:45:46
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
               input [1:0] zero,            //比较结果，决定分支是否跳转
               input [31:0] ALU_result,
               output reg we_rf,            //寄存器读写选择
               output reg [2:0] sext_op,    //根据指令选择立即数
               output reg [3:0] wd_sel,     //选择写回寄存器的数据来源
               output reg alub_sel,         //选择传给ALU的数据
               output reg [3:0] ALU_mode,   //ALU操作模式
               output reg [1:0] npc_op,     //choose next pc
               output reg branch,           //jump or not
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
                wd_sel   <= `ALU_C;
                alub_sel <= 1'b0;
                npc_op   <= `PLUS_4;
                branch <= 1'b0;
                dram_we <= 1'b0;
                case (funct3)
                    3'b000: begin
                        ALU_mode <= funct7[5] ? `SUB : `ADD;
                        wd_sel   <= `ALU_C;
                    end
                    3'b111: begin
                        ALU_mode <= `AND;
                        wd_sel   <= `ALU_C;
                    end
                    3'b110: begin 
                        ALU_mode <= `OR;                     //OR
                        wd_sel   <= `ALU_C;
                    end
                    3'b100: begin
                        ALU_mode <= `XOR;                    //XOR
                        wd_sel   <= `ALU_C;
                    end
                    3'b001: begin
                        ALU_mode <= `SLL;                    //SLL
                        wd_sel   <= `ALU_C;
                    end
                    3'b101: begin 
                        ALU_mode <= funct7[5] ? `SRA : `SRL; //SRL or SRA
                        wd_sel   <= `ALU_C;
                    end
                    3'b010: begin   //slt
                        ALU_mode <= `BINARY_signed;
                        wd_sel <= `ALU_C;
                    end
                    3'b011: begin   //sltu
                        ALU_mode <= `BINARY_unsigned;
                        wd_sel <= `ALU_C;
                    end
                    default: ;
                
                endcase
            end
            `I_type:
            begin
                we_rf <= 1'b1;
                alub_sel <= 1'b1;
                wd_sel <= `ALU_C;
                npc_op   <= `PLUS_4;
                branch <= 1'b0;
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
                    3'b010: begin   //slti
                            ALU_mode <= `BINARY_signed;
                            sext_op <= `I_type_ext;
                            end
                    3'b011: begin
                            ALU_mode <= `BINARY_unsigned;
                            sext_op <= `I_type_ext;
                            end
                    default: ;
                endcase
            end
            `I_type_jalr:
            begin
                sext_op <= `I_type_ext;
                we_rf <= 1'b1;
                alub_sel <= 1'b1;
                wd_sel <= `PC_addr;
                ALU_mode <= `ADD;
                npc_op   <= `JUMP_REG;
                branch <= 1'b0;
                dram_we <= 1'b0;
            end
            `I_type_lw:
            begin
                sext_op <= `I_type_ext;
                we_rf <= 1'b1;
                alub_sel <= 1'b1;
                ALU_mode <= `ADD;
                npc_op   <= `PLUS_4;
                branch <= 1'b0;
                dram_we <= 1'b0;
                case (funct3)
                    3'b010: wd_sel <= `DMEM_rd;
                    3'b000: wd_sel <= `DMEM_rd_byte;
                    3'b001: wd_sel <= `DMEM_rd_half;
                    3'b100: wd_sel <= `DMEM_rd_byte_u;
                    3'b101: wd_sel <= `DMEM_rd_half_u;
                    default: wd_sel <= `DMEM_rd;
                endcase
            end
            `S_type:
            begin
                sext_op <= `S_type_ext;
                we_rf <= 1'b0;
                alub_sel <= 1'b1;
                wd_sel <= `OTHERS;
                ALU_mode <= `ADD;
                npc_op   <= `PLUS_4;
                branch <= 1'b0;
                dram_we <= 1'b1;
            end
            `B_type:
            begin
                sext_op <= `B_type_ext;
                we_rf <= 1'b0;
                alub_sel <= 1'b0;
                wd_sel <= `OTHERS;
                npc_op   <= `BRANCH_CHOOSE;
                dram_we <= 1'b0;
                case (funct3)
                    3'b000: begin branch <= (zero == `EQUAL)? 1'b1 : 1'b0; ALU_mode <= `SUB; end
                    3'b001: begin branch <= (zero == `EQUAL)? 1'b0 : 1'b1; ALU_mode <= `SUB; end
                    3'b100: begin branch <= (zero == `LESS)? 1'b1 : 1'b0; ALU_mode <= `SUB; end
                    3'b101: begin branch <= ((zero == `EQUAL) || (zero == `GREATER))? 1'b1: 1'b0; ALU_mode <= `SUB; end
                    3'b110: begin ALU_mode <= `BINARY_unsigned; branch <= (ALU_result == 1) ? 1'b1 : 1'b0; end
                    3'b111: begin ALU_mode <= `BINARY_unsigned; branch <= (ALU_result == 0) ? 1'b1 : 1'b0; end
                    default: branch <= 1'b0;
                endcase
            end
            `J_type:
            begin
                sext_op <= `J_type_ext;
                we_rf <= 1'b1;
                alub_sel <= alub_sel;
                wd_sel <= `PC_addr;
                ALU_mode <= `ADD;
                npc_op   <= `JUMP;
                branch <= 1'b0;
                dram_we <= 1'b0;
            end
            `U_type:
            begin
                sext_op <= `U_type_ext;
                we_rf <= 1'b1;
                alub_sel <= alub_sel;
                wd_sel <= `U_ext_num;
                ALU_mode <= ALU_mode;
                npc_op   <= `PLUS_4;
                branch <= 1'b0;
                dram_we <= 1'b0;
            end
            `U_type_auipc:
            begin
                sext_op <= `U_type_ext;
                we_rf <= 1'b1;
                alub_sel <= alub_sel;
                wd_sel <= `U_pc;
                ALU_mode <= ALU_mode;
                npc_op   <= `PLUS_4;
                branch <= 1'b0;
                dram_we <= 1'b0;
            end
            default:;
        endcase
    end
endmodule
