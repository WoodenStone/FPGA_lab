`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/07 19:32:10
// Design Name: 
// Module Name: reg8file
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


module reg8file(
    input [2:0] wsel,   //待写地址
    input wen,  //写使能端
    input [2:0] rsel,   //读取地址
    input clk,  //时钟信号
    input clrn, //复位信号
    input [7:0] d,  //待写数据
    output  [7:0] q
    );
    wire [7:0] we_n;
    wire [7:0] r0,r1,r2,r3,r4,r5,r6,r7;
    
    decoder_38 decoder(.data_i(wsel),.en_i(wen),.data_o(we_n));
    reg8 reg_0(.clk(clk),.clrn(clrn),.d(d),.q(r0),.wen(we_n[0]));
    reg8 reg_1(clk,clrn,d,r1,we_n[1]);
    reg8 reg_2(clk,clrn,d,r2,we_n[2]);
    reg8 reg_3(clk,clrn,d,r3,we_n[3]);
    reg8 reg_4(clk,clrn,d,r4,we_n[4]);
    reg8 reg_5(clk,clrn,d,r5,we_n[5]);
    reg8 reg_6(clk,clrn,d,r6,we_n[6]);
    reg8 reg_7(clk,clrn,d,r7,we_n[7]);
    
    
    mux81 mux(r0,r1,r2,r3,r4,r5,r6,r7,rsel,q);

endmodule
