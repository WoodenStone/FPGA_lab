`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/12 09:48:04
// Design Name: 
// Module Name: hexseg8
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


module hexseg8(hex0,hex1,en,s0,rst,clk,seg0,seg1,len);
        input [3:0] hex0;
        input [3:0] hex1;
        input [7:0] en;
        input s0;
        input clk;
        input rst;
        
        //output reg key_flag;
        output reg [7:0] seg0=8'd0;
        output reg [7:0] seg1=8'd0;
        output reg [7:0] len=8'd0;
        
        wire key_flag;
        wire clock;
        wire [7:0] en_o;
        wire [7:0] hex_l;
        wire [7:0] hex_h;
        wire [3:0] cnt_h;
        wire [3:0] cnt_l;
        wire [7:0] cntled_h;
        wire [7:0] cntled_l;
        wire [2:0] scancnt;
        divider u_1(.clk_i(clk),.clk_o(clock));
        decoder u_3(.num(hex0),.clk(clk),.led(hex_l));
        decoder u_4(.num(hex1),.clk(clk),.led(hex_h));
        //使用clk仿真便于观察现象
        count u_5(.clk(clock),.s0(key_flag),.high(cnt_h),.low(cnt_l));
        //count u_5(.clk(clk),.s0(s0),.high(cnt_h),.low(cnt_l));
        decoder u_6(.num(cnt_h),.clk(clk),.led(cntled_h));
        decoder u_7(.num(cnt_l),.clk(clk),.led(cntled_l));
        scancnt u_8(.clk(clk),.scancnt(scancnt));
        key_filter #(.CNT_MAX (20'd9))
       key_filter ( .sys_clk(clock), .sys_rst_n(rst),.key_in(s0), .key_flag(key_flag));
        
        
        always@(posedge clk) begin
            case(scancnt)
                3'b111:begin
                    if(en[7]==1) begin seg1<=cntled_h;len<=8'b10000000; end
                    else begin seg1<=8'd0;len[7]<=1'd0; end
                    seg0<=8'd0; end
                 3'b110:begin
                    if(en[6]==1) begin seg1<=cntled_l;len<=8'b01000000;  end
                    else begin seg1<=8'd0;len[6]<=1'd0;end
                    seg0<=8'd0; end
                 3'b101:begin
                    if(en[5]==1) begin seg1<=hex_h;len<=8'b00100000; end
                    else begin seg1<=8'd0; len[5]<=1'd0; end
                    seg0<=8'd0; end
                 3'b100:begin
                    if(en[4]==1) begin seg1<=hex_l;len<=8'b00010000; end
                    else begin seg1<=8'd0; len[4]<=1'd0; end
                    seg0<=8'd0; end
                  3'b011:begin
                    if(en[3]==1) begin seg0<=8'b11111100;len<=8'b00001000; end
                    else begin seg0<=8'd0;len[3]<=1'd0; end
                    seg1<=8'd0; end
                 3'b010:begin
                    if(en[2]==1) begin seg0<=8'b10111111;len<=8'b00000100; end
                    else begin seg0<=8'd0; len[2]<=1'd0; end
                    seg1<=8'd0; end
                  3'b001:begin
                    if(en[1]==1) begin seg0<=8'b11011010;len<=8'b00000010;end
                    else begin seg0<=8'd0;len[1]<=1'd0; end
                    seg1<=8'd0; end
                 3'b000:begin
                    if(en[0]==1) begin seg0<=8'b11111111;len<=8'b00000001;  end
                    else begin seg0<=8'd0; len[0]<=1'd0; end
                    seg1<=8'd0; end
                default: begin seg0<=8'd0; seg1<=8'd0; len<=8'b00000000;end
                endcase
                 // len<=en;
        end
       /*always@(posedge clk) begin
            case(en)
                8'b00000000: begin seg0<=8'd0; seg1<=8'd0; len<=8'd0; end
                8'b10000000: begin
                    if(en[7]==1) begin seg1<=cntled_h; len<=8'b10000000; end
                    else begin seg1<=8'd0; len[7]<=1'd0; end
                    seg0<=8'd0; end
                8'b01000000: begin
                    if(en[6]==1) begin seg1<=cntled_l; len<=8'b01000000; end
                    else begin seg1<=8'd0; len[6]<=1'd0; end
                    seg0<=8'd0; end
                8'b00100000: begin
                    if(en[5]==1) begin seg1<=hex_h; len<=8'b00100000; end
                    else begin seg1<=8'd0; len[5]<=1'd0; end
                    seg0<=8'd0; end
                8'b00010000: begin
                    if(en[4]==1) begin seg1<=hex_l; len<=8'b00010000; end
                    else begin seg1<=8'd0; len[4]<=1'd0; end
                    seg0<=8'd0; end
                8'b00001000: begin
                    if(en[3]==1) begin seg0<=8'b11111100; len<=8'b00001000; end
                    else begin seg0<=8'd0; len[3]<=1'd0; end
                    seg1<=8'd0; end
                8'b00000100: begin
                    if(en[2]==1) begin seg0<=8'b10111111; len<=8'b00000100;end
                    else begin seg0<=8'd0; len[2]<=1'd0; end
                    seg1<=8'd0; end
                8'b00000010: begin
                    if(en[1]==1) begin seg0<=8'b11011010; len<=8'b00000010; end
                    else begin seg0<=8'd0; len[1]<=1'd0; end
                    seg1<=8'd0; end
                8'b00000001: begin
                    if(en[0]==1) begin seg0<=8'b11111111; len<=8'b00000001; end
                    else begin seg0<=8'd0; len[0]<=1'd0; end
                    seg1<=8'd0; end
                default: begin seg0<=8'd0; seg1<=8'd0; len<=8'd0; end
                endcase
        end*/
        
endmodule
