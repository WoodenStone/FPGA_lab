`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/14 18:51:31
// Design Name: 
// Module Name: division
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


module division(
    input  wire       clk  ,
    input  wire       rst_n,
    input  wire [7:0] x    ,
    input  wire [7:0] y    ,
    input  wire       start,

    output wire        led0_en,
    output wire        led1_en,
    output wire        led2_en,
    output wire        led3_en,
    output wire        led4_en,
    output wire        led5_en,
    output wire        led6_en,
    output wire        led7_en,
    output wire        led_ca ,
    output wire        led_cb ,
    output wire        led_cc ,
    output wire        led_cd ,
    output wire        led_ce ,
    output wire        led_cf ,
    output wire        led_cg ,
    output wire        led_dp
    );
    
    wire [7:0] z1   ;
    wire [7:0] r1   ;
    wire [7:0] z2   ;
    wire [7:0] r2   ;
    wire busy       ;
    
    top top_U (
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
    
    display display_U (
    .clk (clk),
    .rst_n (rst_n),
    .busy   (busy),
    .z1    (z1) ,
    .r1     (r1),
    .z2     (z2),
    .r2     (r2),
    .led0_en(led0_en),
    .led1_en(led1_en),
    .led2_en(led2_en),
    .led3_en(led3_en),
    .led4_en(led4_en),
    .led5_en(led5_en),
    .led6_en(led6_en),
    .led7_en(led7_en),
    .led_ca(led_ca),
    .led_cb(led_cb),
    .led_cc(led_cc),
    .led_cd(led_cd),
    .led_ce(led_ce),
    .led_cf (led_cf) ,
    .led_cg(led_cg),
    .led_dp(led_dp)
    );
endmodule
