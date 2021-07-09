module slave (
    input  wire        clk      ,   
    input  wire        rst_n    ,
    output reg         a_ready  ,
    input  wire        a_valid  ,  
    input  wire [3:0]  a_opcode ,
    input  wire [3:0]  a_mask   ,
    input  wire [3:0]  a_address,
    input  wire [31:0] a_data   ,
    input  wire        d_ready  ,
    output reg         d_valid  ,
    output reg  [3:0]  d_opcode ,
    output wire  [31:0] d_data   ,
    output reg         reg_wr   ,
    output reg         reg_rd   ,
    output reg  [3:0]  reg_byte ,
    output reg  [3:0]  reg_addr ,
    output reg  [31:0] reg_wdata,
    input  wire [31:0] reg_rdata
);

// a_ready 只有一个从设备 可保持高位
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        a_ready <= 1'b0;
    end
    else begin
        a_ready <= 1'b1;
    end
end

reg d_valid_ctrl;

// d_valid_ctrl 打拍 以跟随reg_rdata变化指示可读
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n ) begin 
        d_valid_ctrl <= 1'b0;
    end else if ((a_opcode == 4'h4 ) & d_ready) d_valid_ctrl <= 1'b1;   //GET: D通道携带可接受数据
    else d_valid_ctrl <= 1'b0;
end

// d_valid
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n ) begin 
        d_valid <= 1'b0;
    end else if (((a_opcode == 4'h1 ) | (a_opcode == 4'h0)) & a_valid) d_valid <= 1'b1;     //PUT：A通道携带数据有效
    else  d_valid <= d_valid_ctrl;
end

// reg_wr PUT & A通道数据有效
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) reg_wr <= 1'd0;
    else if ((a_opcode == 4'h0 | a_opcode == 4'h1) & a_valid) reg_wr <= 1'b1;
    else reg_wr <= 1'b0;
end

// reg_rd GET & D通道可接受
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) reg_rd <= 1'd0;
    else if ((a_opcode == 4'h4 ) & d_ready) reg_rd <= 1'b1;
    else reg_rd <= 1'b0;
end

// d_opcode
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) d_opcode <= 4'h0;
    else if (a_address == 4'h1) d_opcode <= 4'h1;   // AccessAckData
    else d_opcode <= 4'h0;
end

// reg_byte
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) reg_byte <= 4'h0;
    else if (a_valid) reg_byte <= a_mask;
    else reg_byte <= 4'h0;
end

// reg_addr
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)  reg_addr <= 4'h0;
    else if (a_valid) reg_addr <= a_address;
    else reg_addr <= 4'h0;
end

// d_data 与GET返回数据同步
assign d_data = (~rst_n)? 32'h0 : reg_rdata;

// reg_wdata
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) reg_wdata <= 32'h0;
    else if (a_opcode == 4'h1) begin
        reg_wdata[31:24] <= a_mask[3] ? a_data[31:24] : 8'h0;
        reg_wdata[23:16] <= a_mask[2] ? a_data[23:16] : 8'h0;
        reg_wdata[15:8] <= a_mask[1] ? a_data[15:8] : 8'h0;
        reg_wdata[7:0] <= a_mask[0] ? a_data[7:0] : 8'h0;
    end 
    else if (a_opcode == 4'h0) reg_wdata <= a_data;
    else reg_wdata <= 32'h0;
end

endmodule