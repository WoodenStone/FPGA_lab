module top (
    input  wire       clk  ,
    input  wire       rst_n,
    input  wire [7:0] x    ,
    input  wire [7:0] y    ,
    input  wire       start,
    output wire [7:0] z1   ,
    output wire [7:0] r1   ,
    output wire [7:0] z2   ,
    output wire [7:0] r2   ,
    output wire       busy     
);

wire busy1;
wire busy2;

div_rr u_div_rr (
    .clk    (clk  ),
    .rst_n  (rst_n),
    .x      (x    ),
    .y      (y    ),
    .start  (start),
    .z1     (z1   ),
    .r1     (r1   ),
    .busy1  (busy1)
);

div_as u_div_as (
    .clk    (clk  ),
    .rst_n  (rst_n),
    .x      (x    ),
    .y      (y    ),
    .start  (start),
    .z2     (z2   ),
    .r2     (r2   ),
    .busy2  (busy2)
);

assign busy = busy1 | busy2;

endmodule
