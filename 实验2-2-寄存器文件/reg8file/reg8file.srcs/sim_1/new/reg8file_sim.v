`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/07 20:49:22
// Design Name: 
// Module Name: reg8file_sim
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


module reg8file_sim(

    );
    reg clk=1'b0;   //时钟
    reg clrn=1'b1;  //不清零
    reg wen=1'b1;   //不可写
    reg [2:0]wsel=3'b000;   
    reg [2:0]rsel=3'b000;
    reg [7:0]d=8'haa; //写入data
    wire [7:0] q;   //输出
    
    reg8file u1(.wsel(wsel),.wen(wen),.rsel(rsel),.clk(clk),.clrn(clrn),.d(d),.q(q));
    //IMPORTANT! 注意时钟上升沿是*突变*
    always begin
        #10 clk=~clk;
    end
    //将时延设长一点有利于分析波形
    initial begin
        //向触发器0写入a0并读出D0
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b000; d=8'ha0; rsel=3'b000;end
        //向触发器1写入a1并读出D0
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b001;d=8'ha1;rsel=3'b000;end
        //向触发器2写入a2并读出D1
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b010;d=8'ha2;rsel=3'b001;end
        //向触发器3写入a3并读出D2
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b011;d=8'ha3;rsel=3'b010;end
        //向触发器4写入a4并读出D3
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b100;d=8'ha4;rsel=3'b011;end
        //向触发器5写入a5并读出D4
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b101;d=8'ha5;rsel=3'b100;end
        //向触发器6写入a6并读出D5
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b110;d=8'ha6;rsel=3'b101;end
       //向触发器7写入a7并读出D6
        #40 begin clrn=1'b1;wen=1'b0;wsel=3'b111;d=8'ha7;rsel=3'b110;end
        //读出D7
        #40 begin clrn=1'b1;wen=1'b0;rsel=3'b111;end
        //关闭写使能，向触发器D7写入b7，读出D7
        #40 begin wen=1'b1;d=8'hb7;wsel=3'b111;rsel=3'b111;end
        //清零
        #40 begin clrn=1'b0;rsel=3'b111;end
        #40 $finish;
    end    
endmodule
