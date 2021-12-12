
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/10 15:41:57
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



module top(
    input clk,
    input rst_n,
    output [31:0] display_x19,
    output debug_wb_have_inst,
    output [31:0] debug_wb_pc,
    output debug_wb_ena,
    output [4:0] debug_wb_reg,
    output [31:0] debug_wb_value
    );

    //if and IF_ID
    wire [31:0] NPC;
    wire [31:0] PC_if;
    wire [31:0] instruction_if;
    wire [31:0] instruction_ID;
    wire [31:0] PC_ID;

    // id and ID_EX
    wire [31:0] RD1_id;
    wire [31:0] RD2_id;
    wire [2:0]  sext_op;
    wire [31:0] ext_number_id;
    wire [31:0] RD1_EX;
    wire [31:0] RD2_EX;
    wire [31:0] PC_EX;
    wire [4:0]  wR_EX;
    wire [31:0] instruction_EX;
    wire [31:0] imm_MEM;
    wire        we_rf_EX   ;
    wire [2:0]  wd_sel_EX  ;
    wire        alub_sel_EX;
    wire [3:0]  ALU_mode_EX;
    wire [2:0]  npc_op_EX  ;
    wire        dram_we_EX ;
    wire [31:0] ext_number_EX;
    wire [31:0] dram_data_EX;

    //ex and EX_MEM and mem
    wire [31:0] operandB;
    wire [1:0]  zero;
    wire [31:0] ALU_result_ex;
    wire [31:0] ALU_result_MEM;
    wire [31:0] RD2_MEM;
    wire [31:0] PC_MEM;
    wire [31:0] RD1_MEM;
    wire [4:0]  wR_MEM;
    wire        we_rf_MEM  ;
    wire [2:0]  wd_sel_MEM ;
    wire [2:0]  npc_op_MEM ;
    wire        dram_we_MEM;
    wire [31:0] DMEM_rd;
    wire [31:0] instruction_MEM;
    wire [31:0] operandB_EX;
    wire [31:0] dram_data_MEM;
    
    
    //MEM_WB
    wire [31:0] RD1_WB;
    wire [4:0] wR_WB;
    wire [31:0] DMEM_rd_WB;
    wire [31:0] ALU_result_WB;
    wire        we_rf_WB;
    wire [2:0]  wd_sel_WB;  
    wire [31:0] imm_WB;
    wire [31:0] WD;
    wire [31:0] PC_WB;
    wire [31:0] PC_addr_JUMP;
    wire [31:0] instruction_WB;

    //control signals
    wire [2:0] npc_op_ctrl;
    wire we_rf_ctrl;
    wire [2:0] sext_op_ctrl;
    wire [2:0] wd_sel_ctrl;
    wire alub_sel_ctrl;
    wire dram_we_ctrl;
    wire [3:0] ALU_mode_ctrl;
    
    // stall  forwarding
    wire stall;
    wire [1:0] forwardA;
    wire [1:0] forwardB;
    wire [31:0] forwardA_result;
    wire [31:0] forwardB_result;
    wire [31:0] forwardA_result_EX;
    wire [31:0] forwardB_result_EX;
    wire stall_j;
    wire stall_j_ID;
    wire stall_j_EX;
    wire stall_j_MEM;
    wire stall_j_WB;
    wire [31:0] dram_data;


    //debug signals start
     assign debug_wb_have_inst = (we_rf_WB || (instruction_WB[6:0] == `B_type && ~we_rf_WB) || (instruction_WB[6:0] == `S_type && ~we_rf_WB)) && ~stall_j_WB  ;
    assign debug_wb_pc = PC_WB;
    assign debug_wb_ena = we_rf_WB;
    assign debug_wb_reg = wR_WB;
    assign debug_wb_value = WD;
    //debug signals end


    // if stage
    inst_mem U_insfetch(
        .a(PC_if[15:2]),
        .spo(instruction_if)
    );

    PC u_PC(
        .NPC   ( NPC   ),
        .clk   ( clk   ),
        .rst_n ( rst_n ),
        .stall  (stall),
        .stall_j(stall_j),
        .PC    ( PC_if )
    );

    // IF_ID register
    IF_ID u_IF_ID(
        .rst_n          ( rst_n          ),
        .clk            ( clk            ),
        .IF_PC          ( PC_if          ),
        .IF_instruction ( instruction_if ),
        .instruction_ID ( instruction_ID ),
        .PC_ID          ( PC_ID          ),
        .stall  (stall),
        .stall_j(stall_j),
        .stall_j_ID(stall_j_ID)
    );

    // id stage
    regfile u_regfile(
        .clk   ( clk   ),
        .rD1   ( instruction_ID[19:15]   ),
        .rD2   ( instruction_ID[24:20]   ),
        .wR    ( wR_WB    ),
        .wD    ( WD    ),
        .WE    ( we_rf_WB    ),
        .rst_n ( rst_n ),
        .display_x19(display_x19),
        .RD1   ( RD1_id   ),
        .RD2   ( RD2_id   )
    );

    imm_gen u_imm_gen(
        .instruction ( instruction_ID[31:7] ),
        .sext_op     ( sext_op_ctrl     ),
        .ext_number  ( ext_number_id  )
    );

    // ID_EX register
    ID_EX u_ID_EX(
        .clk            ( clk            ),
        .rst_n          ( rst_n          ),
        .ID_PC          ( PC_ID          ),
        .ID_RD1         ( RD1_id         ),
        .ID_RD2         ( RD2_id         ),
        .ID_ext_num     ( ext_number_id     ),
        .ID_wR          ( instruction_ID[11:7]   ),
        .ID_instruction ( instruction_ID ),
        .ID_operandB (operandB),
        .RD1_EX         ( RD1_EX         ),
        .imm_EX         ( ext_number_EX         ),
        .RD2_EX         ( RD2_EX         ),
        .PC_EX          ( PC_EX          ),
        .wR_EX          ( wR_EX          ),
        .instruction_EX ( instruction_EX ),
        .operandB_EX(operandB_EX),
        .ID_we_rf       ( we_rf_ctrl       ),
        .ID_wd_sel      ( wd_sel_ctrl      ),
        .ID_ALU_mode    ( ALU_mode_ctrl    ),
        .ID_npc_op      ( npc_op_ctrl      ),
        .ID_dram_we     ( dram_we_ctrl     ),
        .we_rf_EX       ( we_rf_EX       ),
        .wd_sel_EX      ( wd_sel_EX      ),
        .ALU_mode_EX    ( ALU_mode_EX    ),
        .npc_op_EX      ( npc_op_EX      ),
        .dram_we_EX     ( dram_we_EX     ),
        .dram_data  (dram_data),
        .dram_data_EX(dram_data_EX),
        .stall              (stall),
        .forwardA_result    (forwardA_result),
        .forwardA_result_EX    (forwardA_result_EX),
        .stall_j_ID(stall_j_ID),
        .stall_j_EX(stall_j_EX)
    );
    
    forwarding_sl u_forwarding_sl(
        .instruction_ID ( instruction_ID ),
        .rd_ex          ( wR_EX          ),
        .rd_mem         ( wR_MEM         ),
        .rd_wb          ( wR_WB          ),
        .RD2_id         ( RD2_id         ),
        .ALU_result_ex  ( ALU_result_ex  ),
        .ALU_result_MEM ( ALU_result_MEM ),
        .ALU_result_WB  ( ALU_result_WB  ),
        .dram_data      ( dram_data      )
    );


    
    // alub is in ID stage
    ALUB_MUX u_ALUB_MUX(
        .alub_sel ( alub_sel_ctrl ),
        .RD2      ( forwardB_result      ),
        .imm      ( ext_number_id      ),
        .operandB  ( operandB  )
    );
    
    //ex stage
    ALU u_ALU(
        .operandA ( forwardA_result_EX ),
        .operandB ( operandB_EX ),
        .ALU_mode ( ALU_mode_EX ),
        .zero     ( zero     ),
        .ALU_result  ( ALU_result_ex  )
    );
    
    idecode u_idecode(
        .clk          ( clk          ),
        .rst_n        ( rst_n        ),       
        .instruction_if (instruction_if),
        .instruction_EX (instruction_EX),
        .forwardA_result_EX(forwardA_result_EX),
        .PC_if         ( PC_if        ),
        .zero           (zero),
        .imm_EX      (ext_number_EX),
        .npc_op_EX  (npc_op_EX),
        .NPC          ( NPC          )
    );

    // EX_MEM register
    EX_MEM u_EX_MEM(
        .clk            ( clk            ),
        .rst_n          ( rst_n          ),
        .EX_ALU_result  ( ALU_result_ex  ),
        .EX_wR          ( wR_EX          ),
        .EX_PC          ( PC_EX          ),
        .EX_imm         ( ext_number_EX         ),
        .EX_instruction (instruction_EX),
        .EX_dram_data (dram_data_EX),
        .dram_data_MEM(dram_data_MEM),
        .instruction_MEM(instruction_MEM),
        .imm_MEM        ( imm_MEM        ),
        .ALU_result_MEM ( ALU_result_MEM ),
        .wR_MEM         ( wR_MEM         ),
        .PC_MEM         ( PC_MEM         ),
        .EX_we_rf       ( we_rf_EX       ),
        .EX_wd_sel      ( wd_sel_EX      ),
        .EX_dram_we     ( dram_we_EX     ),
        .we_rf_MEM      ( we_rf_MEM      ),
        .wd_sel_MEM     ( wd_sel_MEM     ),
        .dram_we_MEM    ( dram_we_MEM    ),
        .stall_j_EX(stall_j_EX),
        .stall_j_MEM(stall_j_MEM)
    );

    // mem stage
    data_mem U_dataRAM(
        .clk     (clk     ),
        .we ( dram_we_MEM ),
        .a    ( ALU_result_MEM[15:2]    ),
        .d ( dram_data_MEM ),
        .spo  ( DMEM_rd  )
    );

    // MEM_WB register
    MEM_WB u_MEM_WB(
        .clk            ( clk            ),
        .rst_n          ( rst_n          ),
        .MEM_DMEM_rd    ( DMEM_rd        ),
        .MEM_ALU_result ( ALU_result_MEM ),
        .MEM_wR         ( wR_MEM         ),
        .MEM_imm        ( imm_MEM        ),
        .MEM_PC         ( PC_MEM         ),
        .MEM_instruction (instruction_MEM),
        .instruction_WB (instruction_WB),
        .PC_WB          ( PC_WB          ),
        .imm_WB         ( imm_WB         ),
        .wR_WB          ( wR_WB          ),
        .DMEM_rd_WB     ( DMEM_rd_WB     ),
        .ALU_result_WB  ( ALU_result_WB  ),
        .MEM_we_rf      ( we_rf_MEM      ),
        .MEM_wd_sel     ( wd_sel_MEM     ),
        .we_rf_WB       ( we_rf_WB       ),
        .wd_sel_WB      ( wd_sel_WB      ),
        .stall_j_MEM(stall_j_MEM),
        .stall_j_WB(stall_j_WB)
    );

    WD_MUX u_WD_MUX(
        .clk        ( clk        ),
        .rst_n      ( rst_n      ),
        .wd_sel     ( wd_sel_WB     ),
        .U_ext_num  ( imm_WB      ),
        .ALU_result ( ALU_result_WB ),
        .DMEM_rd    ( DMEM_rd_WB    ),
        .PC_addr    ( PC_WB    ),
        .WD         ( WD         )
    );


    //control unit: generate control signals at the stage of ID
    control u_control(
        .instruction ( instruction_ID ),
        .stall_j(stall_j),
        .we_rf       ( we_rf_ctrl       ),
        .sext_op     ( sext_op_ctrl     ),
        .wd_sel      ( wd_sel_ctrl      ),
        .alub_sel    ( alub_sel_ctrl    ),
        .ALU_mode    ( ALU_mode_ctrl    ),
        .npc_op      ( npc_op_ctrl      ),
        .dram_we     ( dram_we_ctrl     )
    );

    //stall signal: executes at ID stage
    stall u_stall(
        .clk            ( clk            ),
        .rst_n          ( rst_n          ),
        .instruction_if (instruction_if),
        .instruction_ID ( instruction_ID ),
        .instruction_EX ( instruction_EX),
        .instruction_MEM ( instruction_MEM),
        .instruction_WB ( instruction_WB),
        .rd_ex          ( wR_EX          ),
        .rd_mem         ( wR_MEM         ),
        .rd_wb          ( wR_WB          ),
        .stall          ( stall          ),
        .stall_j    (stall_j)
    );

    //forwarding unit and MUX
    forwarding u_forwarding(
     .rs1_id       (instruction_ID[19:15]),
	 .rs2_id      (instruction_ID[24:20]),
	 .rd_ex       (wR_EX),
	 .rd_mem   (wR_MEM)   ,
	 .rd_wb   (wR_WB),
	 .we_rf_ex (we_rf_EX),
	 .we_rf_mem(we_rf_MEM),
	 .we_rf_wb(we_rf_WB),
	 .instruction_ID(instruction_ID),
	 .instruction_WB(instruction_WB),
	 .instruction_MEM(instruction_MEM),
	 .forwardA(forwardA),
	 .forwardB(forwardB)
    );
    
    forwardA_MUX u_forwardA_MUX (
        .RD1(RD1_id),
        .ALU_result(ALU_result_ex),
        .ALU_result_MEM(ALU_result_MEM),
        .ALU_result_WB(ALU_result_WB),
        .forwardA(forwardA),
        .forwardA_result(forwardA_result)
    );
    
    forwardB_MUX u_forwardB_MUX(
        .RD2(RD2_id),
        .ALU_result(ALU_result_ex),
        .ALU_result_MEM(ALU_result_MEM),
        .ALU_result_WB(ALU_result_WB),
        .forwardB(forwardB),
        .forwardB_result(forwardB_result)
    );


endmodule
