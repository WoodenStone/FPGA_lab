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
   input        sys_clk        ,    // ϵͳʱ��100MHz
   input        sys_rst_n    ,    // ȫ�ָ�λ
   input        key_in        ,    // ���������ź�
   output    reg    key_flag        // Ϊ1ʱ��ʾ�������⵽���������£�Ϊ0��ʾû�м�⵽������
 );
     reg    [19:0]    cnt;
     // cnt:���ʱ�ӵ������ؼ�⵽�ⲿ���������ֵΪ�͵�ƽʱ����ʼ����
     always @(posedge sys_clk or negedge sys_rst_n)
         if(!sys_rst_n)
             cnt <= 20'b0;
        else if(key_in)
            cnt <= 20'b0;
       else if(cnt==CNT_MAX && key_in)
           cnt <= cnt;
        else
            cnt <= cnt + 1'b1;
   
   // key_flag:��������10ms�����������Ч��־λ����key_flag��9ʱ���ߣ�ά��һ�����ڵĸߵ�ƽ
   always @(posedge sys_clk or negedge sys_rst_n)
        if(!sys_rst_n)
           key_flag <= 1'b0;
      else if(cnt== CNT_MAX-1'b1)
             key_flag <= 1'b1;
         else
             key_flag <= 1'b0;
             
 endmodule