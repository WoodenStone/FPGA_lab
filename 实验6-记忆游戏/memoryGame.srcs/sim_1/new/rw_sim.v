module rw_sim( );
    
    
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
        #550 begin S0=0; sw=8'b0000_0001; end//读取存储�?
        #20  S1=1;  //按下S1
        #700 begin S1=0; S4=1; end  //复位
        #300 begin S0=1; S4=0; end
        #550 begin S0=0; sw=8'b1111_1111; end
        #20 S1=1;
        #700 S1=0;
        #300 $stop;

      
    end
    

endmodule