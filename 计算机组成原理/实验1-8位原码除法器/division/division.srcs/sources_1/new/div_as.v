`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 10:26:34
// Design Name: 
// Module Name: div_as
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: �Ӽ����淨
// 
//////////////////////////////////////////////////////////////////////////////////


module div_as (
    input  wire       clk  ,
    input  wire       rst_n,
    input  wire [7:0] x    , //������
    input  wire [7:0] y    ,
    input  wire       start,

    output wire [7:0] z2   , //��
    output wire [7:0] r2   ,//����
    output reg        busy2     
);

reg [7:0] quotient;
reg [2:0] cnt;
reg [7:0] dividend;	//������
reg [7:0] divisor;	//����
reg [14:0] partial_remainder;	//��������
reg ready;

wire res_sign;	//�������λ
assign res_sign = dividend[7]^divisor[7];

wire [7:0] divisor_n;	//[-y*]����
assign divisor_n = {1'b1, ~divisor[6:0] + 1'b1};

wire [14:0] partial_remainder_left;	//������������1λ
assign partial_remainder_left = {partial_remainder[13:0], 1'b0};

wire [14:0] recurrent;	//��������<<1 +[-y*]�� or ��������<<1 +[y*]��
assign recurrent = ~partial_remainder[14] ? {partial_remainder_left[14:0] + {divisor_n, 7'd0}}
					:{partial_remainder_left[14:0] + {1'b0, divisor[6:0], 7'd0}};

assign z2 = {res_sign, quotient[6:0]};

wire quo_sign;
assign quo_sign = ~recurrent[14];

//begin
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ready <= 1'b0;
    end else if (start) begin
        ready <= 1'b1;  
    end else begin
        ready <= 1'b0 ; 
    end
end

//cnt
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'h0;
    end else if (start) begin
        cnt <= 3'h0;
    end else if (busy2) begin
        cnt <= (cnt^3'h6) ? cnt + 1'b1 : cnt ;
    end begin
    end
end

// busy
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        busy2 <= 1'b0;   
    end else if (ready) begin
        busy2 <= 1'b1;  
    end else begin
        busy2 <= (cnt==3'h6) ? 1'b0 :  busy2; 
    end
end

//divisor
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		divisor <= 8'h00;   
    end else if (start) begin
        divisor <= y;
    end else begin

    end
end

//dividend
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dividend <= 8'h00;
        partial_remainder <= 15'h0;
    end else if (start) begin
        dividend <= x;
        partial_remainder <= {8'h0, x[6:0]};
    end else begin 
        if (busy2) begin
            partial_remainder <= recurrent;
            if (cnt == 3'd6 && recurrent[14] == 1'b1) begin
                partial_remainder <= {recurrent[14:0] + {1'b0, divisor[6:0], 7'd0}} ;
            end
        end else begin
        end   
    end
end

//quotient

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        quotient <= 8'b00000000;
    end else if (start) begin
        quotient <=  8'b00000000;
    end else begin
        if (busy2) begin
            quotient <= {quotient[6:0],quo_sign};
        end else begin
        end
    end
end

assign r2 = (partial_remainder[13:7]==7'b0000000) ? {dividend[7], 7'b0} : {dividend[7],partial_remainder[13:7]};

endmodule

