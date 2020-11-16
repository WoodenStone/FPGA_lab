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


`timescale 1ns/1ps      //1ns表示延时单位，1ps表示时间精度  

module Ex_1_sim();  
    reg [7:0] sw = 8'h00;  //input
    wire [7:0] led;        //output
    Ex_1 uut(              // 第一步实例化被测试对象
        .sw(sw),           // 激励信号sw连接到被测试模块的sw
        .led(led)
    );
    always  #10 sw =sw+1;  // 第二步添加激励，每隔10个单位时间将sw加1
endmodule

