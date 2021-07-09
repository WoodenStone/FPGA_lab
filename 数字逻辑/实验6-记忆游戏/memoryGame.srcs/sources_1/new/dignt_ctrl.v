`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 18:46:58
// Design Name: 
// Module Name: dignt_ctrl
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


module dignt_ctrl(
	input clk,
	//input [2:0]state,
	input S_3,
	input S_0,
	input S_1,
	input S_2,
	input [7:0]sw,
	input S_4,
	output reg [3:0]DN0_en,//使能
	output reg [3:0]DN1_en,
	output reg [7:0]DN0_K,
	output reg [7:0]DN1_K
	);
	
	
//	//state
//	parameter s0 = 3'b000;
//    parameter s1 = 3'b001;
//    parameter s2 = 3'b010;
//    parameter s3 = 3'b011;
//    parameter s4 = 3'b100;
	
	
	
	//each seg num
	reg [3:0]num0,num1,num2,num3,num4,num5,num6,num7;
	//random num
	reg [14:0]q;
	//get each random num
	wire [14:0] q0,q1,q2,q3,q4;
	//时钟分频
	wire clk_o;
	//1s播放计数器
	reg [26:0] cnt_1s=0;
	//4Hz闪烁计数器
	reg [26:0] cnt_4Hz=0;
	//if match flag
	wire ifmatch;
	//number to be matched
	reg [14:0] matchnum;
	//address to read
	reg [2:0] readsel;
	//led 
	wire [7:0] DN0_K1;
	wire [7:0] DN0_K2;
	wire [7:0] DN0_K3;
	wire [7:0] DN0_K4;
	wire [7:0] DN1_K1;
	wire [7:0] DN1_K2;
	wire [7:0] DN1_K3;
	wire [7:0] DN1_K4;
	//display count
	reg [1:0] scancnt=0;
	wire [2:0]state;
	//flag
	reg flag1;
	reg flag2;
	//key debounce
	wire key0,key1,key2,key3,key4;
	//分频
	divider_1kHz U_clk(.clk_i(clk),.clk_o(clk_o));
	//random num
	randnum U_num(.clk(clk_o),.en(key0),.q0(q0),.q1(q1),.q2(q2),.q3(q3),.q4(q4));
	//if match
	Moore_match U_match(clk_o,key3,sw[2:0],matchnum,ifmatch);
	//key debounce
	key_filter U_key0(.clk(clk_o),.key(S_0),.result(key0));
	key_filter U_key1(.clk(clk_o),.key(S_1),.result(key1));
	key_filter U_key2(.clk(clk_o),.key(S_2),.result(key2));
	key_filter U_key3(.clk(clk_o),.key(S_3),.result(key3));
	key_filter U_key4(.clk(clk_o),.key(S_4),.result(key4));
	/*Moore u_1(.clk(clk),.state_o(state),.key0(key0),.key1(key1),.key2(key2),.key4(key4));
	
 always@(posedge clk_o)begin
		case(state)
			s0:	//显示8个0
				begin num0<=0;num1<=0;num2<=0;num3<=0;num4<=0;num5<=0;num6<=0;num7<=0; 
					 cnt_1s<=0; matchnum<=0; readsel<=0;cnt_4Hz<=0;
				end
			s1:	//播放五组数字
				begin num0<=q[2:0];num1<=q[5:3];num2<=q[8:6];num3<=q[11:9];num4<=q[14:12];num5<=0;num6<=0;num7<=0;
						 cnt_1s<=cnt_1s+1;
						if(cnt_1s<=26'd1000) q<=q0;
						else if(cnt_1s<=26'd2000) q<=q1;
						else if(cnt_1s<=26'd3000) q<=q2;
						else if(cnt_1s<=26'd4000) q<=q3;
						else q<=q4;
				end
			s2:
				begin
					if(sw>3'd4)begin	//显示8个F
						num0<=4'd9;num1<=4'd9;num2<=4'd9;num3<=4'd9;num4<=4'd9;num5<=4'd9;num6<=4'd9;num7<=4'd9; 
						end
					else begin	//显示地址
						num0<=sw[2:0];num1<=0;num2<=0;num3<=0;num4<=0;num5<=0;num6<=0;num7<=0; readsel<=sw[2:0];
						case(sw)
							3'd0: matchnum<=q0;
							3'd1: matchnum<=q1;
							3'd2: matchnum<=q2;
							3'd3: matchnum<=q3;
							3'd4: matchnum<=q4;
						endcase
						end
				end
			s3:
				begin
					if(ifmatch==1) begin //显示地址-数字
						num0<=matchnum[2:0];num1<=matchnum[5:3];num2<=matchnum[8:6];num3<=matchnum[11:9];
						num4<=matchnum[14:12];num5<=4'd10;num6<=readsel;num7<=4'd8; 
					end
					else begin	//闪烁8个0
						cnt_4Hz <= (cnt_4Hz > 26'd250) ? 1 : cnt_4Hz + 1;
						if(cnt_4Hz <= 26'd125)	begin
							num7 <= 4'd0; num6 <= 4'd0; num5 <= 4'd0; num4 <= 4'd0; 
							num3 <= 4'd0; num2 <= 4'd0; num1 <= 4'd0; num0 <= 4'd0;
							end
						else begin
							num7 <= 4'd8; num6 <= 4'd8; num5 <= 4'd8; num4 <= 4'd8; 
							num3 <= 4'd8; num2 <= 4'd8; num1 <= 4'd8; num0 <= 4'd8;               
							end
						end
				end
			s4://显示8个0
				begin num0<=0;num1<=0;num2<=0;num3<=0;num4<=0;num5<=0;num6<=0;num7<=0; 
					  matchnum<=0; readsel<=0;cnt_4Hz<=0;
				end
		endcase
	end*/
	
	always@(posedge clk_o)begin
		if(key4==1)
				begin num0<=0;num1<=0;num2<=0;num3<=0;num4<=0;num5<=0;num6<=0;num7<=0; 
					 cnt_1s<=0; matchnum<=0; readsel<=3'bZ; cnt_4Hz<=0;
				end
		else if(flag1==1)
				begin num0<=q[2:0];num1<=q[5:3];num2<=q[8:6];num3<=q[11:9];num4<=q[14:12];num5<=0;num6<=0;num7<=0;
						 cnt_1s<=cnt_1s+1;
						if(cnt_1s<=26'd1000) q<=q0;
						else if(cnt_1s<=26'd2000) q<=q1;
						else if(cnt_1s<=26'd3000) q<=q2;
						else if(cnt_1s<=26'd4000) q<=q3;
						else q<=q4;
				end
		else if(key1==1)
				begin
					if(sw>3'd4)begin	//显示8个F
						num0<=4'd9;num1<=4'd9;num2<=4'd9;num3<=4'd9;num4<=4'd9;num5<=4'd9;num6<=4'd9;num7<=4'd9; 
						end
					else begin	//显示地址
						num0<=sw[2:0];num1<=0;num2<=0;num3<=0;num4<=0;num5<=0;num6<=0;num7<=0; readsel<=sw[2:0];
						case(sw)
							3'd0: matchnum<=q0;
							3'd1: matchnum<=q1;
							3'd2: matchnum<=q2;
							3'd3: matchnum<=q3;
							3'd4: matchnum<=q4;
						endcase
						end
				end
			else if (flag2==1)
				begin
					if(ifmatch==1) begin //显示地址-数字
						num0<=matchnum[2:0];num1<=matchnum[5:3];num2<=matchnum[8:6];num3<=matchnum[11:9];
						num4<=matchnum[14:12];num5<=4'd10;num6<=readsel;num7<=4'd8; 
					end
					else if(ifmatch==0) begin	//闪烁8个0
						cnt_4Hz <= (cnt_4Hz > 26'd250) ? 1 : cnt_4Hz + 1;
						if(cnt_4Hz <= 26'd125)	begin
							num7 <= 4'd0; num6 <= 4'd0; num5 <= 4'd0; num4 <= 4'd0; 
							num3 <= 4'd0; num2 <= 4'd0; num1 <= 4'd0; num0 <= 4'd0;
							end
						else begin
							num7 <= 4'd8; num6 <= 4'd8; num5 <= 4'd8; num4 <= 4'd8; 
							num3 <= 4'd8; num2 <= 4'd8; num1 <= 4'd8; num0 <= 4'd8; 
							end
			        end
			end
	end
	
	always@(posedge key4 or posedge key0 or posedge key1 or posedge key2) begin
	   if(key0==1)  flag1<=1;
	   else if(key1==1 || key4==1 || key2==1) flag1<=0;
	end
	
	always@(posedge key4 or posedge key0 or posedge key1 or posedge key2) begin
	   if(key2==1)  flag2<=1;
	   else if(key1==1 || key4==1 || key0==1) flag2<=0;
	end
	//显示led
	transnum U_0(.num(num0),.clk(clk_o),.led(DN1_K1));
	transnum U_1(.num(num1),.clk(clk_o),.led(DN1_K2));
	transnum U_2(.num(num2),.clk(clk_o),.led(DN1_K3));
	transnum U_3(.num(num3),.clk(clk_o),.led(DN1_K4));
	transnum U_4(.num(num4),.clk(clk_o),.led(DN0_K1));
	transnum U_5(.num(num5),.clk(clk_o),.led(DN0_K2));
	transnum U_6(.num(num6),.clk(clk_o),.led(DN0_K3));
	transnum U_7(.num(num7),.clk(clk_o),.led(DN0_K4));
	
	always@(posedge clk_o) begin
		scancnt<=(scancnt>=2'd3)?0:scancnt+1'd1;
	end
	
	always@(scancnt) begin
		case(scancnt)
			2'd0:begin DN0_en<=4'b0001; DN1_en<=4'b0001; end
			2'd1:begin DN0_en<=4'b0010; DN1_en<=4'b0010; end
			2'd2:begin DN0_en<=4'b0100; DN1_en<=4'b0100; end
			2'd3:begin DN0_en<=4'b1000; DN1_en<=4'b1000; end
		endcase
	end
	
	always@(DN0_en or DN1_en) begin
		case(DN0_en)
			4'b0001: DN0_K<=DN0_K1;
			4'b0010: DN0_K<=DN0_K2;
			4'b0100: DN0_K<=DN0_K3;
			4'b1000: DN0_K<=DN0_K4;
		endcase
		case(DN1_en)
			4'b0001: DN1_K<=DN1_K1;
			4'b0010: DN1_K<=DN1_K2;
			4'b0100: DN1_K<=DN1_K3;
			4'b1000: DN1_K<=DN1_K4;
		endcase
	end
endmodule
