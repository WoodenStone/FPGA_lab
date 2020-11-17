`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/07 20:49:22
// Design Name: 
// Module Name: reg8file_sim
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


module reg8file_sim(

    );
    reg clk=1'b0;   //ʱ��
    reg clrn=1'b1;  //������
    reg wen=1'b1;   //����д
    reg [2:0]wsel=3'b000;   
    reg [2:0]rsel=3'b000;
    reg [7:0]d=8'haa; //д��data
    wire [7:0] q;   //���
    
    reg8file u1(.wsel(wsel),.wen(wen),.rsel(rsel),.clk(clk),.clrn(clrn),.d(d),.q(q));
    //IMPORTANT! ע��ʱ����������*ͻ��*
    always begin
        #10 clk=~clk;
    end
    //��ʱ���賤һ�������ڷ�������
    initial begin
        //�򴥷���0д��a0������D0
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b000; d=8'ha0; rsel=3'b000;end
        //�򴥷���1д��a1������D0
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b001;d=8'ha1;rsel=3'b000;end
        //�򴥷���2д��a2������D1
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b010;d=8'ha2;rsel=3'b001;end
        //�򴥷���3д��a3������D2
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b011;d=8'ha3;rsel=3'b010;end
        //�򴥷���4д��a4������D3
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b100;d=8'ha4;rsel=3'b011;end
        //�򴥷���5д��a5������D4
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b101;d=8'ha5;rsel=3'b100;end
        //�򴥷���6д��a6������D5
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b110;d=8'ha6;rsel=3'b101;end
       //�򴥷���7д��a7������D6
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b111;d=8'ha7;rsel=3'b110;end
        //����D7
        #40 begin clrn=1'b1;wen=1'b0;rsel=3'b111;end
        //�ر�дʹ�ܣ��򴥷���D7д��b7������D7
        #40 begin wen=1'b1;d=8'hb7;wsel=3'b111;rsel=3'b111;end
        //����
        #40 begin clrn=1'b0;rsel=3'b111;end
        #40 $finish;
    end    
endmodule
