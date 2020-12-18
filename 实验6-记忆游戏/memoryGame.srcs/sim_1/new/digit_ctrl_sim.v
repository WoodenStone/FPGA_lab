`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 21:16:30
// Design Name: 
// Module Name: digit_ctrl_sim
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

module digit_ctrl_sim( );
    
    
    reg clk = 1;
    reg [7:0] sw;
    reg S4=0;
    reg S0=0;
    reg S1=0;
    reg S2=0;
    reg S3=0;
    wire [7:0] DN0_K;
    wire [7:0] DN1_K;
    wire [3:0] DN0;
    wire [3:0] DN1;

    dignt_ctrl U_1(
      .clk  (clk),
      .sw   (sw),
      .S_4   (S4),
      .S_0   (S0),
      .S_1   (S1),
      .S_2   (S2),
      .S_3   (S3),
      .DN0_K  (DN0_K), 
      .DN1_K  (DN1_K), 
      .DN0_en    (DN0),
      .DN1_en    (DN1)
    );
    
    always #1 clk = ~clk;
    
    initial begin
        #5 S0=1;    //按下S0，开始生成随机数
        #550 begin S0=0; sw=8'b0000_0001; end//读取存储器
        #20  S1=1;  //按下S1
        #300 S1=0; 
        #100 sw[2:0]=3'b000;
        #30 begin S2=1; end
        
        #300 begin S2=0; S3=1; end
        #300 begin S3=0; sw[2:0]=3'b001; end
        #30 begin S3=1; end
        #300 begin S3=0; sw[2:0]=3'b111; end
        #30 begin S3=1; end
        #300 begin S3=0; sw[2:0]=3'b111; end
        #30 begin S3=1;end
        #300 begin S3=0;sw[2:0]=3'b110; end
        #30 begin S3=1; end
        #300 begin S3=0; end//匹配失败
        
        #10 begin sw[2:0]=3'b000; end
        #30 begin S3=1; end
        #300 begin S3=0; sw[2:0]=3'b001; end
        #30 begin S3=1; end
        #300 begin S3=0; sw[2:0]=3'b111; end
        #30 begin S3=1; end
        #300 begin S3=0; sw[2:0]=3'b111; end
        #30 begin S3=1;end
        #300 begin S3=0;sw[2:0]=3'b111; end
        #30 begin S3=1; end
        #300 begin S3=0; end    //匹配成功
        
        #300 $stop;
        //#700 $stop;



      
    end
    

endmodule

