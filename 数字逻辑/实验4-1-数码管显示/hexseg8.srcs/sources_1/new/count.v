`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/11 15:19:40
// Design Name: 
// Module Name: count
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


module count(clk,s0,high,low);
    input clk;
    input  s0;	//¿ª¹Ø
    output reg[3:0] high;
    output reg[3:0] low;
    
    reg [9:0] cnt;
    initial begin
        cnt<=28'd0;
        high<=4'd1;
        low<=4'd0;
    end
    always@(posedge clk)
		begin
			if(s0==1'd1)
				begin 
					high<=4'd1;
					low<=4'd0;
				end
			if(cnt==10'd500) begin
				cnt<=10'd0;
					if(high==4'd0 && low==4'd0) 
						begin
							high<=4'd1;
							low<=4'd0;
						end
					else if(high==4'd1)
						begin 
							low<=4'd9;
							high<=4'd0;
						end
					else low<=low-1;end
				else begin
					cnt<=cnt+1'd1;
				end
			end
endmodule
