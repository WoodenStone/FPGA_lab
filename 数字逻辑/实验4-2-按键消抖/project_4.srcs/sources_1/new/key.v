`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 17:20:09
// Design Name: 
// Module Name: key
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


module key_fileter #(parameter CNT_MAX=20'd9)(
   input        sys_clk        ,    // 系统时钟100MHz
   input        sys_rst_n    ,    // 全局复位
   input        key_in        ,    // 按键输入信号
   output    reg    key_flag        // 为1时表示消抖后检测到按键被按下，为0表示没有检测到被按下
 );
     reg    [19:0]    cnt;
     // cnt:如果时钟的上升沿检测到外部按键输入的值为低电平时，开始计数
     always @(posedge sys_clk or negedge sys_rst_n)
         if(!sys_rst_n)
             cnt <= 20'b0;
        else if(key_in)
            cnt <= 20'b0;
       else if(cnt==CNT_MAX && key_in)
           cnt <= cnt;
        else
            cnt <= cnt + 1'b1;
   
   // key_flag:当计数满10ms后产生按键有效标志位，且key_flag在9时拉高，维持一个周期的高电平
   always @(posedge sys_clk or negedge sys_rst_n)
        if(!sys_rst_n)
           key_flag <= 1'b0;
      else if(cnt== CNT_MAX-1'b1)
             key_flag <= 1'b1;
         else
             key_flag <= 1'b0;
             
 endmodule