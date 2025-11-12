###RVX_K12
第二代分测版本
实现除ecall，ebreak之外的rv32i指令集
如下说明范围亦如此

##Unit_Stage_MEM
访存阶段设计说明：
mem阶段严格仅对于IL，S型指令起作用


##Unit_Stage_WD
写回阶段设计说明：
wd阶段严格仅对于S，B型以外的指令起作用
写回内容按指令型分类：
R：exResult     (rs + rs)
I：exResult     (rs + imm)
IL：memResult   (rs + imm)
IJ：pcPlus      (pc + 4)
U：imm_U        (imm << 12)
UA：exResult    (pc + imm_U)

#wdOp编码：
----------------workEn(1)
1.工作使能：
依照起作用的指令型划分：
WD阶段不工作写回    (0)
WD阶段工作写回      (1)
----------------dataSelect(2)
因此，以上需要数据可以总结为四种，并用二位编码标识：
1.exResult      (00)
2.memResult     (01)
3.imm_U         (10)
4.pcPlus        (11)
----------------regWAddr(5)
写回地址，由指令的[11:7]位rd决定，共五位

以上相加共8位
组合模式：
[7:0] wdOp={regWAddr, dataSelect, workEn}
00000 00 0
76543 21 0
workEn = wdOp[0]
dataSelect = wdOp[2:1]
regWAddr = wdOp[7:3]

#输入：
clk
rst

wdOp

exResult
memResult
imm_U
pcPlus

#输出：
regWEn      (x)     (x为异步输出，t为同步输出，同步异步概念为相对于时钟)
regWAddr    (x)
regWData    (x)
