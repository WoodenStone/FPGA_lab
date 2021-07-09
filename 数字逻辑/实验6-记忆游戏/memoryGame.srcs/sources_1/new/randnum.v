`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 17:20:05
// Design Name: 
// Module Name: randnum
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


module randnum(
    input clk,
    input en,
    output reg [14:0] q0,
    output reg [14:0] q1,
    output reg [14:0] q2,
    output reg [14:0] q3,
    output reg [14:0] q4
    );
    reg [14:0] q0_store;
    reg [14:0] q1_store;
    reg [14:0] q2_store;
    reg [14:0] q3_store;
    reg [14:0] q4_store;
    reg [14:0] seed=0;
    
    always@(posedge clk) begin
      seed[0] <= seed[14] ^ ~seed[13];
      seed[14:1] <= seed[13:0];
      q0_store <= seed;
      q1_store <= q0_store;
      q2_store <= q1_store;
      q3_store <= q2_store;
      q4_store <= q3_store;
    end
    
    always@(posedge en) begin
        q0<=q0_store;
        q1<=q1_store;
        q2<=q2_store;
        q3<=q3_store;
        q4<=q4_store;
    end
endmodule
