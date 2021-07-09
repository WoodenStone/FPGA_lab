
module driver(
    input clk_in,
    input reset_in,
    input [12:0] end_addr,
    output reg [11:0] count,
    output reg test_success,
     output reg test_fail
  );

wire reset;
wire clk;

assign reset = reset_in;
assign clk = clk_in;

reg [12:0] test_addr;
reg cache_rreq;
wire cache_hit;
wire [7:0] cache_rdata;
wire [7:0] trace_rdata;

wire rreq_cache2mem;
wire [12:0] raddr_cache2mem;
wire [1:0] burst_len_cache2mem;
wire [31:0] rdata_mem2cache;
wire rvalid_mem2cache;

blk_mem trace(.clka(clk),.addra(test_addr),.dina(0),.wea(0),.douta(trace_rdata));
cache cache0(      .clk(clk),
                .reset(reset),
                .raddr_from_cpu(test_addr),
                .rreq_from_cpu(cache_rreq),
                .rdata_to_cpu(cache_rdata),
                .hit_to_cpu(cache_hit),
                .rreq_to_mem(rreq_cache2mem),
                .raddr_to_mem(raddr_cache2mem),
                .rdata_from_mem(rdata_mem2cache),
                .rvalid_from_mem(rvalid_mem2cache) );
mem_wrap mem0(  .clk(clk),
                .reset(reset),
                .rreq(rreq_cache2mem),
                .raddr(raddr_cache2mem),
                .rdata(rdata_mem2cache),
                .rvalid(rvalid_mem2cache)
                 );
                
enum logic [7:0] { IDLE = 8'b0000_0000,
               READ_TRACE = 8'b0000_0001,
               READ_CACHE = 8'b0000_0010,
               RES_COMPARE = 8'b0010_0000,
               TEST_FAIL = 8'b0000_1000,
               TEST_PASS = 8'b0001_0000 } current_state, next_state;


// 状态转移逻辑               
always @(posedge clk)   begin
    if(reset)   begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

reg [7:0] data_from_cache;
reg [7:0] data_from_trace;

// 如果当前状态是等待Cache，并且Cache数据可用，则可以采集Cache的数据
always @(posedge clk)   begin
    if(reset)   begin
        data_from_cache <= 0;
    end else begin
        if(current_state == READ_CACHE && cache_hit) begin
            data_from_cache <= cache_rdata;
        end
    end
end

// trace ram一个周期可以读出数据
always @(posedge clk)   begin
    if(reset)   begin
        data_from_trace <= 0;
    end else begin
        if(current_state == READ_TRACE) begin
            data_from_trace <= trace_rdata;
        end
    end
end

always @(*) begin
    case (current_state)
        IDLE:   begin
            next_state = READ_TRACE;
        end
        READ_TRACE: begin
            next_state = READ_CACHE;
        end
        READ_CACHE: begin
            if(cache_hit)   begin
                next_state = RES_COMPARE; // Cache成功返回数据，可以进行下一步比对
            end else begin   
                next_state = READ_CACHE;
            end
        end
        RES_COMPARE: begin
            if(data_from_cache == data_from_trace)   begin
                if(test_addr == end_addr)   begin   // 测试完毕
                    next_state = TEST_PASS;
                end else begin
                    next_state = READ_TRACE;
                end
            end else begin
                next_state = TEST_FAIL;
            end
        end
        TEST_FAIL:  begin
            next_state = TEST_FAIL;
        end
        TEST_PASS:  begin
            next_state = TEST_PASS;
        end
        default:    begin
            next_state = IDLE;
        end
    endcase
end

// 性能计数器
always @(posedge clk)   begin
    if(reset)   begin  
        count <= 0;
    end else if(current_state == READ_CACHE)   begin
        count <= count + 1;
    end else begin
        count <= count;
    end
end

// 在二段状态机改写成三段的过程中，需要注意状态机原有的由时序逻辑输出的信号需要改写成组合逻辑
always @(posedge clk) begin
    if(reset)   begin
            test_addr <= 0;
            cache_rreq <= 0;
            test_success <= 0;
            test_fail <= 0;
    end else begin
        case (next_state)
            IDLE:   begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
            READ_TRACE: begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
            READ_CACHE: begin
                test_addr <= test_addr;
                cache_rreq <= 1; 
                test_success <= 0;
                test_fail <= 0;
            end
            RES_COMPARE:    begin
                test_addr <= test_addr + 1;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
            TEST_FAIL:  begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 1;
            end
            TEST_PASS:  begin
                test_addr <= test_addr;
                cache_rreq <= 0;
                test_success <= 1;
                test_fail <= 0;
            end
            default:    begin
                test_addr <= 0;
                cache_rreq <= 0;
                test_success <= 0;
                test_fail <= 0;
            end
        endcase
    end
end

endmodule
