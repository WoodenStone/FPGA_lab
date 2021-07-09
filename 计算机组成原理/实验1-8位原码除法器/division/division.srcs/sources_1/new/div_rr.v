//恢复余数法

module div_rr (
    input  wire       clk  ,
    input  wire       rst_n,
    input  wire [7:0] x    ,
    input  wire [7:0] y    ,
    input  wire       start,
    output wire [7:0] z1   ,
    output wire  [7:0] r1   ,
    output reg        busy1     
);


reg [7:0] quotient;
reg [3:0] cnt;
reg [7:0] dividend;  // 被除数
reg [7:0] divisor;
wire ans_sign;      //结果符号
assign ans_sign = dividend[7]^divisor[7];

wire [7:0]divisor_res;

reg [14:0] partial_remainder;
wire selector;

assign divisor_res = {1'b1 , ~divisor[6:0]+1'b1};
assign z1 = {ans_sign,quotient[6:0]}; 

wire [14:0] partial_remainder_left ;
assign partial_remainder_left = {partial_remainder[13:0],1'b0};

wire [14:0] recurrent;  //加[-y*]补
assign recurrent = {partial_remainder_left[14:0]} + {divisor_res, 7'h0} ;

assign selector = recurrent[14]; //选择信号

reg ready;


//begin
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ready <= 1'b0;
    end else if (start) begin
        ready <= 1'b1;  
    end else begin
        ready <= 1'b0 ; 
    end
end


//cnt
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'h0;
    end else if (start) begin
        cnt <= 4'h0;
    end else if (busy1) begin
        cnt <= cnt^4'h6 ? cnt +1'b1 : cnt ;
    end begin
    end
end

//busy1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        busy1 <= 1'b0;   
    end else if (ready) begin
        busy1 <= 1'b1;  
    end else begin
        busy1 <= (cnt==4'h6) ? 1'b0 :  busy1; 
    end
end


//divisor
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        divisor <= 8'h00;
    end else if (start) begin
        divisor <= y;
    end else begin

    end
end


//dividend
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dividend <= 8'h00;
        partial_remainder <= 15'h0;
    end else if (start) begin
        dividend <= x;
        partial_remainder <= {8'h0,x[6:0]};
    end else begin 
        if (busy1) begin
            if (selector) begin
                partial_remainder <= partial_remainder << 1; //余数为负，相当于直接左移    
            end else begin
                partial_remainder <= recurrent;
            end
        end else begin
        end   
    end
end


//quotient
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        quotient <= 8'b00000000;
    end else if (start) begin
        quotient <=  8'b00000000;
    end else begin
        if (busy1) begin
            quotient <= {quotient[6:0],~selector};
        end else begin
        end
    end
end

assign r1 = (partial_remainder[13:7]==7'b0000000) ? {dividend[7], 7'b0} : {dividend[7], partial_remainder[13:7]};

endmodule
