`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/21 15:15:29
// Design Name: 
// Module Name: Mealy_sim
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


module Mealy_sim(

    );
    reg clk_i=1'd1;
    reg set_i;
    reg rst_n_i;
    reg [7:0] data_i;
    wire detect_o;
    Mealy u_1(.rst_n_i(rst_n_i),.clk_i(clk_i),.set_i(set_i),.data_i(data_i),.detect_o(detect_o));
    
    always begin 
        #5 clk_i=~clk_i;
    end
    
    initial begin
        set_i=1'd0;
        //data_i[7:0]=8'b01010111;
        data_i[7:0]=8'b11011111;
        rst_n_i=1'd1;
        
        #10 set_i=1'd1;
        #100 rst_n_i=1'd0;
        #100 begin rst_n_i=1'd1; set_i=1'd0; end
       #100 set_i=1'd1;
      // #300 set_i=1'd0;
       #300 $finish;
        /* #100 set_i=1'd1;
        #200 rst_n_i=1'd0;*/
        
        
    end
endmodule
