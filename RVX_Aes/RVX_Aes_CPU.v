`include "RVX_Info.v"

module RVX_Aes_CPU (
    input wire clk,
    input wire rst,
    input wire [(`BUS_W-1):0] imInstIn,      //im
    output wire [(`BUS_W-1):0] imAddrOut,    //im

    input wire [(`BUS_W-1):0] dmRDataIn,     //dm
    output wire [(`BUS_W-1):0] dmAddrOut,    //dm
    output wire dmWeOut,                     //dm
    output wire dmReOut,                     //dm
    output wire [3:0] dmDataWOut,            //dm
    output wire [(`BUS_W-1):0] dmWDataOut    //dm
);

wire AL_jumpEnOut, AL_stallIFOut, AL_flushIFOut, AL_flushIDOut;
wire [(`BUS_W-1):0] AL_exSrcAOut, AL_exSrcBOut, AL_jumpAddrOut;

wire [(`BUS_W-1):0] IF_instOut, IF_pcOut, IF_pcPlusOut;

wire [4:0] ID_memOpOut;
wire [7:0] ID_wdOpOut;
wire [11:0] ID_exOpOut;
wire [(`BUS_W-1):0] ID_pcOut, ID_pcPlusOut, ID_regData1Out, ID_regData2Out, ID_immOut, ID_instOut;

wire EX_branchTakenOut;
wire [4:0] EX_memOpOut;
wire [7:0] EX_wdOpOut;
wire [(`BUS_W-1):0] EX_regData2Out, EX_pcPlusOut, EX_immOut, EX_exResultOut;

wire [7:0] MEM_wdOpOut;
wire [(`BUS_W-1):0] MEM_pcPlusOut, MEM_exResultOut, MEM_immOut, MEM_memResultOut;

wire WD_regWeOut;
wire [4:0] WD_regAddrOut;
wire [(`BUS_W-1):0] WD_regWDataOut;

Controller_AL al_mod(
    .clk(clk),
    .rst(rst),
    .instIn_IFID(IF_instOut),
    .instIn_IDEX(ID_instOut),
    .exResultIn_EXMEM(EX_exResultOut),
    .memResultIn_MEMWD(MEM_memResultOut),
    .regData1In_IDEX(ID_regData1Out),
    .regData2In_IDEX(ID_regData2Out),
    .branchTaken_EX(EX_branchTakenOut),

    .exSrcAOut(AL_exSrcAOut),
    .exSrcBOut(AL_exSrcBOut),
    .jumpEnOut(AL_jumpEnOut),
    .jumpAddrOut(AL_jumpAddrOut),
    .stallIFOut(AL_stallIFOut),
    .flushIFOut(AL_flushIFOut),
    .flushIDOut(AL_flushIDOut)
);

Stage_IF if_mod(
    .clk(clk),
    .rst(rst),
    .stall(AL_stallIFOut),
    .flush(AL_flushIFOut),
    .instIn(imInstIn),
    .instAddrOut(imAddrOut),
    .instOut(IF_instOut),
    .jumpEn(AL_jumpEnOut),
    .jumpAddr(AL_jumpAddrOut),
    .pcOut(IF_pcOut),
    .pcPlusOut(IF_pcPlusOut)
);

Stage_ID id_mod(
    .clk(clk),
    .rst(rst),
    .stall(),
    .flush(AL_flushIDOut),
    .regAddrIn(WD_regAddrOut),
    .regWeIn(WD_regWeOut),
    .regWDataIn(WD_regWDataOut),
    .instIn(IF_instOut),
    .pcIn(IF_pcOut),
    .pcPlusIn(IF_pcPlusOut),

    .exOpOut(ID_exOpOut),
    .memOpOut(ID_memOpOut),
    .wdOpOut(ID_wdOpOut),
    .pcOut(ID_pcOut),
    .pcPlusOut(ID_pcPlusOut),
    .immOut(ID_immOut),
    .instOut(ID_instOut),

    .regData1Out(ID_regData1Out),
    .regData2Out(ID_regData2Out)
);

Stage_EX ex_mod(
    .clk(clk),
    .rst(rst),
    .flush(),
    .memOpIn(ID_memOpOut),
    .wdOpIn(ID_wdOpOut),
    .pcPlusIn(ID_pcPlusOut),
    .memOpOut(EX_memOpOut),
    .wdOpOut(EX_wdOpOut),
    .regData2Out(EX_regData2Out),
    .pcPlusOut(EX_pcPlusOut),
    .immOut(EX_immOut),
    .exOpIn(ID_exOpOut),
    .regData1In(AL_exSrcAOut),
    .pcIn(ID_pcOut),
    .regData2In(AL_exSrcBOut),
    .immIn(ID_immOut),
    .exResultOut(EX_exResultOut),
    .branchTakenOut(EX_branchTakenOut)
);

Stage_MEM mem_mod(
    .clk(clk),
    .rst(rst),
    .flush(),
    .wdOpIn(EX_wdOpOut),
    .pcPlusIn(EX_pcPlusOut),
    .immIn(EX_immOut),
    .wdOpOut(MEM_wdOpOut),
    .pcPlusOut(MEM_pcPlusOut),
    .exResultOut(MEM_exResultOut),
    .immOut(MEM_immOut),
    .memOpIn(EX_memOpOut),
    .exResultIn(EX_exResultOut),
    .regData2In(EX_regData2Out),
    .dmRDataIn(dmRDataIn),
    .dmAddrOut(dmAddrOut),
    .dmWeOut(dmWeOut),
    .dmReOut(dmReOut),
    .dmDataWOut(dmDataWOut),
    .dmWDataOut(dmWDataOut),
    .memResultOut(MEM_memResultOut)
);

Stage_WD wd_mod(
    .clk(clk),
    .rst(rst),
    .wdOpIn(MEM_wdOpOut),
    .pcPlusIn(MEM_pcPlusOut),
    .exResultIn(MEM_exResultOut),
    .memResultIn(MEM_memResultOut),
    .immIn(MEM_immOut),
    .regAddrOut(WD_regAddrOut),
    .regWeOut(WD_regWeOut),
    .regWDataOut(WD_regWDataOut)
);

endmodule