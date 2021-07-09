`timescale 1ns / 1ps

module all_sim(
);
reg clk,reset;
wire [11:0] count;
wire [12:0] end_addr = 13'b0_1111_1111_1111;
wire test_success, test_fail;
driver g0(
    clk,
    reset,
    end_addr,
    count,
    test_success,
    test_fail
    );
integer fp_w;

initial begin
#0 
fp_w=$fopen("result","w");
reset = 1;
clk = 0;
#105 
reset = 0;

end

always @(posedge clk)   begin
    if(g0.current_state == 8'b0000_0001)    $display("���ʵ�ַΪ",g0.test_addr);
    if(g0.current_state == 8'b0000_0010 && g0.next_state == 8'b0000_0010 )    $display("�ȴ�Cache��Ӧ��Ӧ�õ�����",g0.data_from_trace);
    if(g0.cache_hit)    $display("Cache��������!");
    if(g0.current_state == 8'b0010_0000)    $display("Cache��ȡ������", g0.data_from_cache);
    if(g0.next_state == 8'b0000_0001)      $display("�õ�ַ������ȷ����������һ����ַ\n ----------- ");
end
always begin
    #10 clk = ~clk;
end 
always @(posedge clk)   begin
    if(test_success)    begin
        $fwrite(fp_w,"TEST PASSED\n");
        $fwrite(fp_w,"Cycles spent on reading cache: %d\n", count); 
        $fclose(fp_w); 
        $display("=======================����ȫ��ͨ��=========================");
        $stop; 
    end
    if(test_fail)   begin   
        $fwrite(fp_w,"TEST FAILED\n");
        $fwrite(fp_w,"At read addr %x, expect %x, but get %x\n", g0.test_addr, g0.data_from_trace, g0.data_from_cache);
        $fclose(fp_w);
        $display("==========================����δͨ���������뿴���������Ϣ==========================");
        $stop;
    end
end
endmodule
