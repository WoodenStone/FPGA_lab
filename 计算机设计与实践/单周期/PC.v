
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 12:04:54
// Design Name: 
// Module Name: PC
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


module PC(
    input [31:0] NPC,
    input clk,
    input rst_n,
    output reg [31:0] PC
    );
    
    always@ (posedge clk) begin
        if (!rst_n) PC <= 32'hffff_fffc;
        else PC <= NPC;
    end
endmodule
