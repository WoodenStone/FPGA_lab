`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 15:23:54
// Design Name: 
// Module Name: decoder_38_sim
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

`timescale 1ns/1ps          // 1ns��ʾ��ʱ��λ, 1ps��ʾʱ�侫��

module decoder_38_sim ();

    // ����˿�
    reg [2:0] data_in;
    reg [2:0] en;

    // ����˿�
    wire [7:0] data_out;

    // ����Լ���ʵ�����ʵ����
    decoder_38 U_dec38_0 (
        .data_i     (data_in),
        .en_i       (en),
        .data_o     (data_out)
    );

    initial begin
// �������뼤���ź�
        #5 begin en = 3'b100; data_in = 3'b000; end
        #5 begin en = 3'b100; data_in = 3'b001; end
        #5 begin en = 3'b100; data_in = 3'b010; end
        #5 begin en = 3'b100; data_in = 3'b011; end
        #5 begin en = 3'b100; data_in = 3'b100; end
        #5 begin en = 3'b100; data_in = 3'b101; end
        #5 begin en = 3'b100; data_in = 3'b110; end
        #5 begin en = 3'b100; data_in = 3'b111; end
        // ʹ�ܶ���Ч
        #5 begin en = 3'b101; data_in = 3'b000; end
        // ��������
        #5 $stop;
    end

endmodule

