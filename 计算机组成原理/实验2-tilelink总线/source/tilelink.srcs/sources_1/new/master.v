module master (
    input  wire        clk        ,
    input  wire        rst_n      ,
    input  wire        cpu_wr     ,
    input  wire        cpu_rd     ,
    input  wire [3:0]  cpu_byte   ,
    input  wire [3:0]  cpu_addr   ,
    input  wire [31:0] cpu_wdata  ,
    output wire        cpu_rdata_v,
    output wire [31:0] cpu_rdata  ,
    input  wire        a_ready    ,
    output reg         a_valid    ,
    output reg  [3:0]  a_opcode   ,
    output reg  [3:0]  a_mask     ,
    output reg  [3:0]  a_address  ,
    output reg  [31:0] a_data     ,
    output reg         d_ready    ,
    input  wire        d_valid    ,
    input  wire [3:0]  d_opcode   ,
    input  wire [31:0] d_data     ,
    output reg         trans_over
);
// d_ready
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)               d_ready <= 1'b0;
    else if (cpu_wr | cpu_rd) d_ready <= 1'b1;
end
//a_valid
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)               a_valid <= 1'b0;
    else if (cpu_wr | cpu_rd) a_valid <= 1'b1;
    else                      a_valid <= 1'b0;
end
// a_opcode
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                    a_opcode <= 4'h0;
    else if (cpu_wr & (&cpu_byte)) a_opcode <= 4'h0;
    else if (cpu_wr)               a_opcode <= 4'h1;
    else if (cpu_rd)               a_opcode <= 4'h4;
    else                           a_opcode <= 4'h0;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)               a_mask <= 4'h0;
    else if (cpu_wr | cpu_rd) a_mask <= cpu_byte;
    else                      a_mask <= 4'h0;  
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)               a_address <= 4'h0;
    else if (cpu_wr | cpu_rd) a_address <= cpu_addr;
    else                      a_address <= 4'h0;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)      a_data <= 32'h0;
    else if (cpu_wr) a_data <= cpu_wdata;
    else             a_data <= 32'h0;  
end

reg rd_period;
reg trans_over_ff;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) trans_over_ff <= 1'b0;
    else        trans_over_ff <= trans_over;
end

wire trans_over_pos = trans_over & ~trans_over_ff;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)              rd_period <= 1'b0;
    else if (trans_over_pos) rd_period <= 1'b0;
    else if (cpu_rd)         rd_period <= 1'b1;
end

assign cpu_rdata_v = rd_period & d_valid;

assign cpu_rdata = d_data;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                 trans_over <= 1'b1;
    else if (a_ready & a_valid) trans_over <= 1'b0;
    else if (d_ready & d_valid) trans_over <= 1'b1;
end

endmodule
