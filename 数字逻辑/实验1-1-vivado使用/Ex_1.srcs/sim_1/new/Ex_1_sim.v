`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 14:26:54
// Design Name: 
// Module Name: Ex_1_sim
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


`timescale 1ns/1ps      //1ns��ʾ��ʱ��λ��1ps��ʾʱ�侫��  

module Ex_1_sim();  
    reg [7:0] sw = 8'h00;  //input
    wire [7:0] led;        //output
    Ex_1 uut(              // ��һ��ʵ���������Զ���
        .sw(sw),           // �����ź�sw���ӵ�������ģ���sw
        .led(led)
    );
    always  #10 sw =sw+1;  // �ڶ�����Ӽ�����ÿ��10����λʱ�佫sw��1
endmodule

