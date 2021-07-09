`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 10:24:29
// Design Name: 
// Module Name: top
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


module top (
    input  wire        clk      ,
    input  wire        rst_n    ,
    input  wire        wr       ,
    input  wire        rd       ,
    input  wire [3:0]  byte     ,
    input  wire [3:0]  addr     ,
    input  wire [31:0] wdata    ,
    output wire        rdata_v  ,
    output wire [31:0] rdata     
);

wire        cpu_wr     ;
wire        cpu_rd     ;
wire [3:0]  cpu_byte   ;
wire [3:0]  cpu_addr   ;
wire [31:0] cpu_wdata  ;
wire        cpu_rdata_v;
wire [31:0] cpu_rdata  ;
wire        a_ready    ;
wire        a_valid    ;  
wire [3:0]  a_opcode   ;
wire [3:0]  a_mask     ;
wire [3:0]  a_address  ;
wire [31:0] a_data     ;
wire        d_ready    ;
wire        d_valid    ;
wire [3:0]  d_opcode   ;
wire [31:0] d_data     ;
wire        reg_wr     ;
wire        reg_rd     ;
wire [3:0]  reg_byte   ;
wire [3:0]  reg_addr   ;
wire [31:0] reg_wdata  ;
wire [31:0] reg_rdata  ;
wire        trans_over ;

cpu u_cpu (
    .clk         (clk        ),
    .rst_n       (rst_n      ),
    .wr          (wr         ),
    .rd          (rd         ),
    .byte        (byte       ),
    .addr        (addr       ),
    .wdata       (wdata      ),
    .rdata_v     (rdata_v    ),
    .rdata       (rdata      ),
    .cpu_wr      (cpu_wr     ),
    .cpu_rd      (cpu_rd     ),
    .cpu_byte    (cpu_byte   ),
    .cpu_addr    (cpu_addr   ),
    .cpu_wdata   (cpu_wdata  ),
    .cpu_rdata_v (cpu_rdata_v),
    .cpu_rdata   (cpu_rdata  ),
    .trans_over  (trans_over )
);

master u_master (
    .clk         (clk        ),
    .rst_n       (rst_n      ),
    .cpu_wr      (cpu_wr     ),
    .cpu_rd      (cpu_rd     ),
    .cpu_byte    (cpu_byte   ),
    .cpu_addr    (cpu_addr   ),
    .cpu_wdata   (cpu_wdata  ),
    .cpu_rdata_v (cpu_rdata_v),
    .cpu_rdata   (cpu_rdata  ),
    .a_ready     (a_ready    ),
    .a_valid     (a_valid    ), 
    .a_opcode    (a_opcode   ),
    .a_mask      (a_mask     ),
    .a_address   (a_address  ),
    .a_data      (a_data     ),
    .d_ready     (d_ready    ),
    .d_valid     (d_valid    ),
    .d_opcode    (d_opcode   ),
    .d_data      (d_data     ),
    .trans_over  (trans_over )
);

slave u_slave (
    .clk       (clk      ),   
    .rst_n     (rst_n    ),
    .a_ready   (a_ready  ),
    .a_valid   (a_valid  ),  
    .a_opcode  (a_opcode ),
    .a_mask    (a_mask   ),
    .a_address (a_address),
    .a_data    (a_data   ),
    .d_ready   (d_ready  ),
    .d_valid   (d_valid  ),
    .d_opcode  (d_opcode ),
    .d_data    (d_data   ),
    .reg_wr    (reg_wr   ),
    .reg_rd    (reg_rd   ),
    .reg_byte  (reg_byte ),
    .reg_addr  (reg_addr ),
    .reg_wdata (reg_wdata),
    .reg_rdata (reg_rdata)
);

cordic u_cordic (
    .clk       (clk      ),
    .rst_n     (rst_n    ),
    .reg_wr    (reg_wr   ),
    .reg_rd    (reg_rd   ),
    .reg_byte  (reg_byte ),
    .reg_addr  (reg_addr ),
    .reg_wdata (reg_wdata),
    .reg_rdata (reg_rdata)
);

endmodule


