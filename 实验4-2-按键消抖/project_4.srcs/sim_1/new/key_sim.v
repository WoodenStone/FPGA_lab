`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/13 17:21:17
// Design Name: 
// Module Name: key_sim
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


module tb_key_filter();
   // I/O port
     reg            sys_clk;
    reg            sys_rst_n;
    reg            key_in;
     wire        key_flag;
     wire        clock;
     
     reg    [21:0]    tb_cnt;
     
     divider_1kHz U_1(.clk_i(sys_clk),.clk_o(clock));
     
     key_fileter #(
     .CNT_MAX        (20'd9            )
     )
     key_fileter_inst(
        .sys_clk    (clock        ),
         .sys_rst_n    (sys_rst_n        ),
         .key_in        (key_in            ),
         .key_flag    (key_flag        )
     );

     parameter    CNT_1MS = 20'd19;
     parameter    CNT_11MS = 21'd39;
     parameter    CNT_41MS = 22'd99;
     parameter    CNT_51MS = 22'd109;
    parameter    CNT_60MS = 22'd129;
                     
    // 初始化系统时钟、复位信号和输入信号
    initial
         begin
            sys_clk     <= 1'b1;
            sys_rst_n     <= 1'b0;
             key_in         <= 1'b0;
             #5
             sys_rst_n    <= 1'b1;
         end
    
     // 定义系统时钟，1kHz
     always #5 sys_clk = ~sys_clk;
    
     // tb_cnt: 按键过程计数器，用于模拟按键抖动过程
     always @(posedge clock or negedge sys_rst_n)
         if(!sys_rst_n)
             tb_cnt <= 22'b0;
        else if(tb_cnt==CNT_60MS)    // 计数器计到60MS是完成一次按键从按下到释放的过程
             tb_cnt <= 22'b0;
         else
            tb_cnt <= tb_cnt + 1'b1;
             
     // key_in:产生输入随机数，模拟按键情况
   always @(posedge clock or negedge sys_rst_n)
         if(!sys_rst_n)
             key_in <= 1'b1;            // 按键未按下时的状态为高电平
        else if((tb_cnt>=CNT_1MS && tb_cnt<=CNT_11MS) || (tb_cnt>=CNT_41MS && tb_cnt<=CNT_51MS))
             key_in <= {$random} % 2;
         else if(tb_cnt>=CNT_11MS && tb_cnt<=CNT_41MS)
             key_in <= 1'b0;
        else
             key_in <= 1'b1;
             
     
 endmodule
