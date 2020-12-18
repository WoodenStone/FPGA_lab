`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 18:55:27
// Design Name: 
// Module Name: Moore
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


module Moore(clk,state_o,key0,key1,key2,key4);
    input clk;
    input key0,key1,key2,key4;
    output[2:0] state_o;
    
    parameter s0 = 3'b000;
    parameter s1 = 3'b001;
    parameter s2 = 3'b010;
    parameter s3 = 3'b011;
    parameter s4 = 3'b100;
    
    reg [2:0] curstate=s0;
    reg [2:0] nextstate;

    always@( posedge clk) begin
        nextstate=s0;
        case(curstate)
            s0: begin nextstate=(key0==1'd1)?s1:s0; end
            s1: begin nextstate=(key1==1'd1)?s2:s1; end
            s2: begin nextstate=(key2==1'd1)?s3:s2; end
            s3: begin nextstate=(key4==1'd1)?s4:s3; end
            s4: begin nextstate=(key0==1'd1)?s1:s0; end
            default: begin nextstate=nextstate; end
        endcase
    end
    
    always@(posedge clk)
        begin curstate<=nextstate; end
    
    assign state_o=curstate;
endmodule
