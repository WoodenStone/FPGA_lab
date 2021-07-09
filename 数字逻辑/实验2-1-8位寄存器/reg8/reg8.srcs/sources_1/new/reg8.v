`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/04 14:38:13
// Design Name: 
// Module Name: reg8
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


module reg8(clk,clrn,d,q,wen);
    input clk;
    input clrn;
    input [7:0] d;
    input wen;
    output [7:0] q;
    
    dffe r0(clk,clrn,d[0],wen,q[0]);
    dffe r1(clk,clrn,d[1],wen,q[1]);
    dffe r2(clk,clrn,d[2],wen,q[2]);
    dffe r3(clk,clrn,d[3],wen,q[3]);
    dffe r4(clk,clrn,d[4],wen,q[4]);
    dffe r5(clk,clrn,d[5],wen,q[5]);
    dffe r6(clk,clrn,d[6],wen,q[6]);
    dffe r7(clk,clrn,d[7],wen,q[7]);
    
endmodule
