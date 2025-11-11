`include "RVX_Info.v"

module Main_Test ();

reg clk, rst;

initial begin
    clk = 0;
    rst = 1;
    #5;
    rst = 0;
    #5;
    rst = 1;
end

always #10 clk = ~clk;

wire cpu_dmWeOut, cpu_dmReOut;
wire [3:0] cpu_dmDataWOut;
wire [(`BUS_W-1):0] cpu_imAddrOut, cpu_dmAddrOut, cpu_dmWDataOut;

wire [(`BUS_W-1):0] im_instOut;

wire [(`BUS_W-1):0] dm_dmRDataOut;

RVX_Aes_CPU cpu(
    .clk(clk),
    .rst(rst),
    .imInstIn(im_instOut),
    .imAddrOut(cpu_imAddrOut),
    .dmRDataIn(dm_dmRDataOut),
    .dmAddrOut(cpu_dmAddrOut),
    .dmWeOut(cpu_dmWeOut),
    .dmReOut(cpu_dmReOut),
    .dmDataWOut(cpu_dmDataWOut),
    .dmWDataOut(cpu_dmWDataOut)
);

InstMem im(
    .clk(clk),
    .imAddrIn(cpu_imAddrOut),
    .instOut(im_instOut)
);

DataMem dm(
    .clk(clk),
    .rst(rst),
    .dmAddrIn(cpu_dmAddrOut),
    .dmWeIn(cpu_dmWeOut),
    .dmReIn(cpu_dmReOut),
    .dmDataWIn(cpu_dmDataWOut),
    .dmWDataIn(cpu_dmWDataOut),
    .dmRDataOut(dm_dmRDataOut)
);
    
endmodule