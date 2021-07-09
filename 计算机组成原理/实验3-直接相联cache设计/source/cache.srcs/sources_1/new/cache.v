`timescale 1ns / 1ps
module cache(
    // ȫ���ź�
    input clk,
    input reset,
    // ��CPU���ķ����ź�
    input [12:0] raddr_from_cpu,     // CPU��Ķ���ַ
    input rreq_from_cpu,            // CPU���Ķ�����
    // ���²��ڴ�ģ�������ź�
    input [31:0] rdata_from_mem,     // �ڴ��ȡ������
    input rvalid_from_mem,          // �ڴ��ȡ���ݿ��ñ�־
    // �����CPU���ź�
    output [7:0] rdata_to_cpu,      // �����CPU������
    output hit_to_cpu,              // �����CPU�����б�־
    // ������²��ڴ�ģ����ź�
    output reg rreq_to_mem,         // ������²��ڴ�ģ��Ķ�����
    output reg [12:0] raddr_to_mem  // ������²�ģ���ͻ�������׵�ַ
    );
    
    
   parameter READY = 3'b001,
                      TAG_CHECK  = 3'b010,
                      REFILL = 3'b100;
    reg [2:0] current_state;
    reg [2:0] next_state;
    wire [36:0] data_cache;
    reg [36:0] refill_data;
    reg refill_en;
    reg valid = 1'b0;
    reg [3:0]cache_tag;
    reg refill_done;
    reg [7:0] rdata;
//    ��ַ�ֽ�
    reg [3:0] tag; //���λ4λ tag <= raddr_from_cpu [12:9]
    reg [6:0] cache_addr; // cache����7λ cache_addr <= raddr_from_cpu [8:2]
    reg [1:0] cache_offset; //�ֿ���ƫ��2λ cache_offset <= raddr_from_cpu[1:0]
    
   
    
    blk_mem_gen_0 your_instance_name(.clka(clk),.addra(cache_addr),.dina(refill_data),.wea(refill_en),.douta(data_cache));
    
    always @(*)begin
        tag = raddr_from_cpu [12:9];
        cache_addr = raddr_from_cpu [8:2];
        cache_offset = raddr_from_cpu[1:0];
        valid = data_cache[36];
        cache_tag = data_cache[35:32];
        raddr_to_mem = raddr_from_cpu;
    end
    
    
    always @(posedge clk) begin
        if (reset) begin
            current_state <= READY;
        end else begin
            current_state <= next_state;
        end 
    end
    
    always @(*) begin
        case (current_state)
            READY: if (rreq_from_cpu) begin
                            next_state = TAG_CHECK;
                        end else begin
                            next_state = READY;
                        end
            TAG_CHECK: if (hit_to_cpu) begin
                                next_state = READY;
                            end else begin
                                next_state = REFILL;
                            end
            REFILL: if(refill_en) begin
                            next_state = TAG_CHECK;
                       end else begin
                            next_state = REFILL;
                       end
            default: begin
            end
        endcase
    end
    

    assign rdata_to_cpu = rdata;
    //    �ֿ���ƫ��    
    always @(*) begin
        case (cache_offset)
            2'b00: rdata = data_cache [7:0];
            2'b01: rdata = data_cache [15:8];
            2'b10: rdata = data_cache [23:16];
            2'b11: rdata = data_cache [31:24];
            default: begin rdata = 0; end
        endcase
    end

    
//    ���
    assign hit_to_cpu = rreq_from_cpu ? ((tag == cache_tag) && (current_state == TAG_CHECK) && valid) : 0 ;
    always @(posedge clk) begin
        case (current_state) 
            READY: begin
                rreq_to_mem <= 1'b0;
                refill_en <= 1'b0;
            end
            TAG_CHECK: begin  
            end
            REFILL: begin
                rreq_to_mem <= 1'b1;
                if (rvalid_from_mem) begin
                    refill_en <= 1'b1;
                    refill_data <= {rvalid_from_mem, tag, rdata_from_mem};
                end
            end
            default: begin 
            end
        endcase
    end
    
endmodule