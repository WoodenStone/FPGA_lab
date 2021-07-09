`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/07 19:22:13
// Design Name: 
// Module Name: mux81
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


module mux81(r0,r1,r2,r3,r4,r5,r6,r7,rsel,q);
    input [7:0]r0,r1,r2,r3,r4,r5,r6,r7;
    input [2:0]rsel;
    output reg [7:0]q;
    
    always@(*)
    begin
    case(rsel)
        3'b000:q=r0;
        3'b001:q=r1;
        3'b010:q=r2;
        3'b011:q=r3;
        3'b100:q=r4;
        3'b101:q=r5;
        3'b110:q=r6;
        3'b111:q=r7;
        default:q=8'bxxxx_xxxx;
        endcase 
       end
endmodule
