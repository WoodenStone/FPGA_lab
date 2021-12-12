# FPGA_lab

### HITSZ 2020 秋 数字逻辑设计实验

包含源文件及工程文件、仿真截图、部分仿真分析报告和实验6综合实验（记忆游戏）的实验报告。

### HITSZ 2021 春 计组实验

实验一：恢复余数法和加减交替法（不恢复余数法）实现8位原码除法器，并实现在开发板上通过拨码开关输入、数码管显示两种方法的商和余数的功能

实验二：tilelink总线协议设计

实验三：直接相联cache设计

测试方法：实验一、二提交测试平台测试，实验三通过all_sim.v文件测试。

### 2021 夏 计算机设计与实践

使用verilog编写RISC V架构的单周期和五级流水线CPU设计。

单周期支持37条指令：

`add、sub、and、or、xor、sll、srl、sra、slt、sltu、addi、andi、ori、xori、slli、srli、srai、slti、sltiu、lb、lh、lw、jalr、lbu、lhu、sb、sh、sw、beq、bne、blt、bltu、bge、bgeu、lui、auipc、jal`

五级流水线，支持24条指令：

`add、sub、and、or、xor、sll、srl、sra、addi、andi、ori、xori、slli、srli、srai、lw、jalr、sw、beq、bne、blt、bge、lui、jal`

流水线实现停顿和前递。

测试：trace、上板。

外设没做，写不动写不动。
