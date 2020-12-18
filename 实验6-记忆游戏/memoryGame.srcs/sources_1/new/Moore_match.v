`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 18:44:20
// Design Name: 
// Module Name: Moore_match
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


module Moore_match(
	input clk,
	input key3,
	input [2:0]remnum,
	input [14:0]q,
	output  detect_o
	);
	
	parameter A0 = 1'd0;
    parameter A1 = 1'd1;
    parameter A2 = 2'd2;
    parameter A3 = 2'd3;
    parameter A4 = 3'd4;
    parameter A5 = 3'd5;
    reg [3:0] current_state = A0;
    reg [3:0] next_state = A0;
    
//    initial begin
//        current_state<=A0;
//    end
    
    always @(posedge clk)
    begin
        current_state <= next_state;
    end 
    
    always @(posedge key3)
    begin
        case(current_state)
        A0: next_state <= (remnum == q[14:12]) ? A1 : A0;
        A1: next_state <= (remnum == q[11:9]) ? A2 : A0;
        A2: next_state <= (remnum == q[8:6]) ? A3 : A0;
        A3: next_state <= (remnum == q[5:3]) ? A4 : A0;
        A4: next_state <= (remnum == q[2:0]) ? A5 : A0;
        A5: next_state <= (remnum == q[14:12]) ? A1 : A0;
       endcase
    end
   /* always @(posedge clk)
    begin
      if(current_state == A5)
        detect_o <= 1;
      else
        detect_o <= 0;
    end*/
    
    assign detect_o=(current_state==A5)?1:0;
	
	
endmodule
