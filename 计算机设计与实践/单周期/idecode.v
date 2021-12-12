`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/30 22:58:03
// Design Name: 
// Module Name: idecode
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


module idecode(
    input clk,
    input [1:0] npc_op,  //ָ��ѡ��
    input [31:0] PC,
    input [31:0] PC_ext,    //����ָ��������������Imm
    input branch,	//B��ָ����ת�ź�
	input [31:0] RD1,	//jalr��ָ��Դ������1
	input rst_n,
    output reg [31:0] NPC,
    output reg [31:0] PC_4
    );

    always @(*) begin
        if (!rst_n) PC_4 = 32'h0;
        else PC_4 = PC + 4;
    end

    always @(*) begin
	    if(PC==32'hfffffffc) begin
		    NPC = 0;
    end else begin
        case (npc_op)
            `PLUS_4:
                NPC = PC + 4;  //ֱ��+4
            `BRANCH_CHOOSE:
				NPC = (branch == 1)? PC + (PC_ext << 1) : PC + 4;	//��ӦB��
            `JUMP_REG:
                NPC = RD1 + PC_ext; //��Ӧjalr
			`JUMP:
				NPC = PC + (PC_ext << 1);//jal
            default:;
        endcase
	end
    end
    
endmodule
