`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/21 15:09:55
// Design Name: 
// Module Name: Mealy
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


module Mealy(rst_n_i,clk_i,set_i,data_i,detect_o);
    input rst_n_i;
    input clk_i;
    input set_i;
    input [7:0] data_i;
    output reg detect_o;
    
    reg [3:0] curstate;
    reg [3:0] nextstate;
    reg [2:0] count=3'd7;
    reg z=1'b0;
    
    parameter s0 = 4'b0000,
                s1 = 4'b0001,
                s2 = 4'b0010,
                s3 = 4'b0100,
                s4 = 4'b1000;
    initial begin
        curstate<=s0;
        detect_o<=1'b0;
    end
    
    always@(posedge clk_i or posedge set_i or negedge rst_n_i)
    begin
        if(rst_n_i==0) curstate<=s0;
        else begin
            curstate<=nextstate;
            if(set_i==0) begin
                count<=3'd7;
                curstate<=s0;
            end
            else begin
                if(count>3'd0) count<=count-1;
                else count<=3'd0;
            end
        end
    end
    
    always @(posedge z or posedge set_i or posedge rst_n_i)
    begin
        if(rst_n_i==0||set_i==0) detect_o<=1'd0;
        else if((z==1'd1)&&(nextstate==s0)) detect_o<=1'd1;
    end
    
    always@(curstate or count)
    begin
        case(curstate)
        s0: nextstate=(data_i[count]==1)?s0:s1;
        s1: nextstate=(data_i[count]==1)?s2:s1;
        s2: nextstate=(data_i[count]==0)?s3:s0;
        s3: nextstate=(data_i[count]==1)?s4:s1;
        s4: nextstate=(data_i[count]==1)?s0:s3;
        endcase
    end
    
    always@(curstate)
    begin
        case(curstate) 
            s4:z<=(data_i[count]==1)?1'd1:1'd0;
            default z<=1'd0;
        endcase
    end
endmodule
