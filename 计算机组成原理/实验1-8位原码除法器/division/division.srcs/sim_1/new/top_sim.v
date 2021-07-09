`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 11:24:47
// Design Name: 
// Module Name: top_sim
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


module top_sim();   
reg clk = 1'b1;
reg rst_n = 1'b1;
reg [7:0] x    = 8'b0;
reg [7:0] y    = 8'b0;
reg       start = 1'b0;
wire [7:0] z1   ;
wire [7:0] r1   ;
wire [7:0] z2   ;
wire [7:0] r2   ;
wire       busy ;

top u_top_sim (
    .clk    (clk  ),
    .rst_n  (rst_n),
    .x      (x    ),
    .y      (y    ),
    .start  (start),
    .z1     (z1   ),
    .r1     (r1   ),
    .z2     (z2   ),
    .r2     (r2   ),
    .busy  (busy)
);

always begin
    #5 clk = ~clk;
end

integer i;
integer j;

initial begin
    rst_n = 1'b1;
    x = 8'b00000000;
    y = 8'b00000000;   
    // -1 / 1
    #10 begin
        start = 1'b1;
        x = 8'b10000001;
        y = 8'b00000001;
    end
    #10 start = 1'b0;
    // 100 / 7
    #120 begin 
        start = 1'b1; 
        x = 8'h64;
        y = 8'h07;
       end
    #10 start = 1'b0;
    //  -100 / 7       
    #120 begin
        start = 1'b1;
        x = 8'b11100100;
        y = 8'b00000111;
    end
    #10 start = 1'b0;
    // 复位
    #10 rst_n = 1'b0;
    #10 rst_n = 1'b1;
    // -100 / -7  
    #120 begin
        start = 1'b1;
        x = 8'b11100100;
        y = 8'b10000111;
    end
    #10 start = 1'b0;
    // 100 / -7
    #120 begin
        start = 1'b1;
        x = 8'b01100100;
        y = 8'b10000111;
    end
    #10 start = 1'b0;
    // -127 / 126
    #120 begin
        start = 1'b1;
        x = 8'b11111111;
        y = 8'b01111110;
    end
    #10 start = 1'b0;
    // -1 / -1 
    #120 begin
        start = 1'b1;
        x = 8'b10000001;
        y = 8'b10000001;
    end
    #10 start = 1'b0;
    
    // 所有情况
        for (i = 0; i <= 8'b11111111; i = i + 1) begin
        for (j = 1; j <= i ; j = j + 1) begin
            #100 begin start = 1'b1; x = i; y = j; end
            #10  start = 1'b0;
        end
    end
end
endmodule
