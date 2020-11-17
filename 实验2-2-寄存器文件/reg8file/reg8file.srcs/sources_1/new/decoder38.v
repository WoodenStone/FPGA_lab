`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/07 19:09:39
// Design Name: 
// Module Name: decoder38
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

module decoder_38 (
    input       [2:0]   data_i,
    input         en_i,
    output reg  [7:0]   data_o
);

    always @(*) begin
    if(en_i==1'b0)
        case (data_i)
            3'b000: data_o = 8'b1111_1110;
            3'b001: data_o = 8'b1111_1101;
            3'b010: data_o = 8'b1111_1011;
            3'b011: data_o = 8'b1111_0111;
            3'b100: data_o = 8'b1110_1111;
            3'b101: data_o = 8'b1101_1111;
            3'b110: data_o = 8'b1011_1111;
            3'b111: data_o = 8'b0111_1111;
            default:data_o = 8'b1111_1111;
        endcase
       else 
        data_o=8'b1111_1111;
    end
endmodule
