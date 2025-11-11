`include "RVX_Info.v"

module Controller_AL (
    input wire clk,
    input wire rst,
    input wire [(`BUS_W-1):0] instIn_IFID,
    input wire [(`BUS_W-1):0] instIn_IDEX,
    input wire [(`BUS_W-1):0] exResultIn_EXMEM,
    input wire [(`BUS_W-1):0] memResultIn_MEMWD,
    input wire [(`BUS_W-1):0] regData1In_IDEX,
    input wire [(`BUS_W-1):0] regData2In_IDEX,
    input wire branchTaken_EX,
    input wire [(`BUS_W-1):0] pcPlusImmIn_IDEX,//br
    input wire [(`BUS_W-1):0] pcPlusImmIn_ID,//ju
    input wire [(`BUS_W-1):0] pcPlusRegData1In_ID,//ju

    output wire [(`BUS_W-1):0] exSrcAOut,
    output wire [(`BUS_W-1):0] exSrcBOut,
    output wire jumpEnOut,
    output wire [(`BUS_W-1):0] jumpAddrOut,
    output wire stallIFOut,
    output wire flushIFOut,
    output wire flushIDOut
);

wire flushID_ac;
wire flushID_aj;
assign flushIDOut = (flushID_ac || flushID_aj);

AL_Clash ac_mod(
    .clk(clk),
    .rst(rst),
    .instIn_IFID(instIn_IFID),
    .instIn_IDEX(instIn_IDEX),
    .exResultIn_EXMEM(exResultIn_EXMEM),
    .memResultIn_MEMWD(memResultIn_MEMWD),
    .regData1In_IDEX(regData1In_IDEX),
    .regData2In_IDEX(regData2In_IDEX),
    .exSrcAOut(exSrcAOut),
    .exSrcBOut(exSrcBOut),
    .stallIFOut(stallIFOut),
    .flushIDOut(flushID_ac)
);

AL_Jump aj_mod(
    .clk(clk),
    .rst(rst),
    .instIn_IFID(instIn_IFID),
    .branchTaken_EX(branchTaken_EX),
    .pcPlusImmIn_IDEX(pcPlusImmIn_IDEX),
    .pcPlusImmIn_ID(pcPlusImmIn_ID),
    .pcPlusRegData1In_ID(pcPlusRegData1In_ID),
    .jumpEnOut(jumpEnOut),
    .jumpAddrOut(jumpAddrOut),
    .flushIFOut(flushIFOut),
    .flushIDOut(flushID_aj)
);

endmodule