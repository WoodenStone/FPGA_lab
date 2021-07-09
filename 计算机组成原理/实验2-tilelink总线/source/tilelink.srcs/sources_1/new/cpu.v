module cpu (
    input  wire        clk        ,
    input  wire        rst_n      ,
    input  wire        wr         ,
    input  wire        rd         ,
    input  wire [3:0]  byte       ,
    input  wire [3:0]  addr       ,
    input  wire [31:0] wdata      ,
    output wire        rdata_v    ,
    output wire [31:0] rdata      ,
    output wire        cpu_wr     ,
    output wire        cpu_rd     ,
    output wire [3:0]  cpu_byte   ,
    output wire [3:0]  cpu_addr   ,
    output wire [31:0] cpu_wdata  ,
    input  wire        cpu_rdata_v,  
    input  wire [31:0] cpu_rdata  ,
    input  wire        trans_over
);

reg wr_ff;
reg rd_ff;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) wr_ff <= 1'b0;
    else        wr_ff <= wr;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) rd_ff <= 1'b0;
    else        rd_ff <= rd;
end

assign cpu_wr = wr & ~wr_ff & trans_over;
assign cpu_rd = rd & ~rd_ff & trans_over;

assign cpu_byte = byte;

assign cpu_addr = addr;

assign cpu_wdata = wdata;

assign rdata_v = cpu_rdata_v;

assign rdata = cpu_rdata;

endmodule

