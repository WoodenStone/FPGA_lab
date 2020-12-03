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
                     
    // ��ʼ��ϵͳʱ�ӡ���λ�źź������ź�
    initial
         begin
            sys_clk     <= 1'b1;
            sys_rst_n     <= 1'b0;
             key_in         <= 1'b0;
             #5
             sys_rst_n    <= 1'b1;
         end
    
     // ����ϵͳʱ�ӣ�1kHz
     always #5 sys_clk = ~sys_clk;
    
     // tb_cnt: �������̼�����������ģ�ⰴ����������
     always @(posedge clock or negedge sys_rst_n)
         if(!sys_rst_n)
             tb_cnt <= 22'b0;
        else if(tb_cnt==CNT_60MS)    // �������Ƶ�60MS�����һ�ΰ����Ӱ��µ��ͷŵĹ���
             tb_cnt <= 22'b0;
         else
            tb_cnt <= tb_cnt + 1'b1;
             
     // key_in:���������������ģ�ⰴ�����
   always @(posedge clock or negedge sys_rst_n)
         if(!sys_rst_n)
             key_in <= 1'b1;            // ����δ����ʱ��״̬Ϊ�ߵ�ƽ
        else if((tb_cnt>=CNT_1MS && tb_cnt<=CNT_11MS) || (tb_cnt>=CNT_41MS && tb_cnt<=CNT_51MS))
             key_in <= {$random} % 2;
         else if(tb_cnt>=CNT_11MS && tb_cnt<=CNT_41MS)
             key_in <= 1'b0;
        else
             key_in <= 1'b1;
             
     
 endmodule
