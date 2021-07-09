`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 11:38:14
// Design Name: 
// Module Name: top_sim
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


module tb_tilelinksim (
);

reg clk;
reg rst_n = 1'b1;
reg wr;
reg rd;
reg [3:0]byte;
reg [3:0]addr;
reg [31:0]wdata;
reg wr_ctrl = 1'b0;
reg rd_ctrl = 1'b0;
wire rdata_v;
wire [31:0] rdata;

reg [3:0] byte_ctrl;
reg [3:0] addr_ctrl;
reg [31:0] wdata_ctrl;


top u_top(
    .clk     (clk     ),
    .rst_n   (rst_n   ),
    .wr      (wr      ),
    .rd      (rd      ),
    .byte    (byte    ),
    .addr    (addr    ),
    .wdata   (wdata   ),
    .rdata_v (rdata_v ),
    .rdata   (rdata   )
);

initial begin
    clk=1'b1;
end
always begin
    #1 clk = ~clk;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) wr_ctrl <= 1'b0;
    else wr <= wr_ctrl;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) rd_ctrl <= 1'b0;
    else rd <= rd_ctrl;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) byte_ctrl <= 1'b0;
    else byte <= byte_ctrl;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) addr_ctrl <= 1'b0;
    else addr <= addr_ctrl;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) wdata_ctrl <= 1'b0;
    else wdata <= wdata_ctrl;
end

task test_rst_n;
begin
    #5 rst_n = 1'b0;
    #5 rst_n = 1'b1;
    $display ("test_rst_n");
end
endtask


task test_putfulldata_1_1;
begin
    #2 wr_ctrl = 1'b1; byte_ctrl = 4'b1111; addr_ctrl = 4'h1; wdata_ctrl = 32'h1000a;
    #2 wr_ctrl = 1'b0; byte_ctrl = 4'h0; addr_ctrl = 4'h0; wdata_ctrl = 32'h0;
    #8 $display("test_putfulldata_1_1");
end
endtask

task test_putfulldata_1_2;
begin
    #2 wr_ctrl = 1'b1; byte_ctrl = 4'b1111; addr_ctrl = 4'h1; wdata_ctrl = 32'h10014;
    #2 wr_ctrl = 1'b0; byte_ctrl = 4'h0; addr_ctrl = 4'h0; wdata_ctrl = 32'h0;
    #8 $display("test_putfulldata_1_2");
end
endtask


task test_cordic_begin_sin;
begin
    #2 wr_ctrl = 1'b1; byte_ctrl = 4'b1111; addr_ctrl = 4'h0; wdata_ctrl[8] = 1'b0; wdata_ctrl[0] = 1'b1;
    #2 wr_ctrl = 1'b0; byte_ctrl = 4'h0; addr_ctrl = 4'h0; wdata_ctrl = 32'h0;
    #8 $display("test_cordic_begin_sin");
end
endtask

task test_cordic_begin_cos;
begin
    #2 wr_ctrl = 1'b1; byte_ctrl = 4'b1111; addr_ctrl = 4'h0; wdata_ctrl[8] = 1'b1; wdata_ctrl[0] = 1'b1;
    #2 wr_ctrl = 1'b0; byte_ctrl = 4'h0; addr_ctrl = 4'h0; wdata_ctrl = 32'h0;
    #8 $display("test_cordic_begin_cos");
end
endtask

task test_cordic_result;
begin
    #30 rd_ctrl = 1'b1; byte_ctrl = 4'b1111; addr_ctrl = 4'h2;
    #2 rd_ctrl = 1'b0; byte_ctrl = 4'h0; addr_ctrl = 4'h0;
    #8 $display("test_cordic_result");
end
endtask

task test_putpartialdata;
begin
    #2 wr_ctrl = 1'b1; byte_ctrl = 4'b0001; addr_ctrl = 4'h1; wdata_ctrl = 32'h0f03;
    #2 wr_ctrl = 1'b0; byte_ctrl = 4'h0; addr_ctrl = 4'h1; wdata_ctrl = 32'h0;
    #8 $display("test_putpartialdata");
end
endtask


initial begin
    $display("tilelink_test start ");
    test_rst_n;

    test_putfulldata_1_1;
    test_cordic_begin_sin;
    test_cordic_result;
    test_putfulldata_1_2;
    test_cordic_begin_sin;
    test_cordic_result;
    test_putfulldata_1_1;
    test_cordic_begin_cos;
    test_cordic_result;
    test_putfulldata_1_2;
    test_cordic_begin_cos;
    test_cordic_result;
    test_putpartialdata;
    test_cordic_begin_sin;
    test_cordic_result;
    test_putpartialdata;
    test_cordic_begin_cos;
    test_cordic_result;
    #20 $stop();

end



endmodule
