
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/30 22:26:29
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    input [4:0] rD1,
    input [4:0] rD2,
    input [4:0] wR, //Ð´µØÖ·
    input [31:0] wD,//Ð´Êý¾Ý
    input WE,   //¶ÁÐ´Ñ¡Ôñ
    input rst_n,

    output [31:0] display_x19,
    output [31:0] RD1,
    output [31:0] RD2
);

    integer i = 0;
    reg [31:0] imem [0:31];

    // read port
    assign RD1 = rst_n ? imem[rD1] : 0;
    assign RD2 = rst_n ? imem[rD2] : 0;
    assign display_x19 = imem[5'd19];

    //write port
    always @(posedge clk or negedge rst_n) begin
		imem[5'h0] <= 32'b0;
        if(!rst_n) begin
            for (i = 0; i <= 31; i = i + 1)
                begin
                    imem[i] <= 0;
                end
        end else begin
            if(WE && wR != 5'h0)  imem[wR] <= wD; //WE = 1 Ð´
        end
    end

endmodule
