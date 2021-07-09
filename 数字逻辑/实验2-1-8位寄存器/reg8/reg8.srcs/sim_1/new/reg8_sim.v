`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/04 14:49:31
// Design Name: 
// Module Name: reg8_sim
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


`timescale 1ns/1ps   //1ns表示延时单位，1ps表示时间精度
module reg8_sim(

    );
    reg clk = 1'b0;
    reg clrn = 1'b1;
    reg wen = 1'b1;
    reg [7:0] d = 8'haa;
    wire [7:0] q;
    
    reg8 u1(.clk(clk),.clrn(clrn),.d(d),.wen(wen),.q(q));

    always begin
        #10 clk=~clk;
    end
    initial begin
        #25 begin clrn = 1'b0; wen = 1'b0; end
        #10 begin clrn = 1'b1; wen = 1'b1; end
        #30 begin wen = 1'b0;end
        #15 begin d=8'hc9;end
        
        #30 $finish;
    end
endmodule

