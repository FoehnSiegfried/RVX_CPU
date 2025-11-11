`include "RVX_Info.v"

module AL_Clash (
    input wire clk,
    input wire rst,
    input wire [(`BUS_W-1):0] instIn_IFID,
    input wire [(`BUS_W-1):0] instIn_IDEX,
    input wire [(`BUS_W-1):0] exResultIn_EXMEM,
    input wire [(`BUS_W-1):0] memResultIn_MEMWD,
    input wire [(`BUS_W-1):0] regData1In_IDEX,
    input wire [(`BUS_W-1):0] regData2In_IDEX,
    
    output reg [(`BUS_W-1):0] exSrcAOut,
    output reg [(`BUS_W-1):0] exSrcBOut,
    output reg stallIFOut,
    output reg flushIDOut
);

wire [6:0] opcodeIFID;
wire [6:0] opcodeIDEX;
assign opcodeIFID = instIn_IFID[6:0];
assign opcodeIDEX = instIn_IDEX[6:0];

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
assign rs1 = ((opcodeIFID != `OP_U) && (opcodeIFID != `OP_J)) ? instIn_IFID[19:15] : 5'b00000;
assign rs2 = ((opcodeIFID != `OP_U) && (opcodeIFID != `OP_J) && (opcodeIFID != `OP_I) && (opcodeIFID != `OP_IL) && (opcodeIFID != `OP_IJ) && (opcodeIFID != `OP_IE)) ? instIn_IFID[24:20] : 5'b00000;
assign rd = ((opcodeIDEX != `OP_S) && (opcodeIDEX != `OP_B)) ? instIn_IDEX[11:7] : 5'b00000;

wire toSrcA;
wire toSrcB;
assign toSrcA = (rs1 != 5'b00000) && (rs1 == rd);
assign toSrcB = (rs2 != 5'b00000) && (rs2 == rd);

wire normalClash;
wire loadClash;
assign normalClash = (opcodeIDEX != `OP_IL) && (toSrcA || toSrcB);
assign loadClash = (opcodeIDEX == `OP_IL) && (toSrcA || toSrcB);

always @(*) begin
    if(loadClash)begin
        stallIFOut <= 1'b1;
        flushIDOut <= 1'b1;
    end else begin
        stallIFOut <= 1'b0;
        flushIDOut <= 1'b0;
    end
end

reg [3:0] clashRegEX;
reg [3:0] clashRegMEM;

always @(*)begin
    if(clashRegMEM[0])begin
        exSrcAOut <= clashRegMEM[3] ? memResultIn_MEMWD : regData1In_IDEX;
        exSrcBOut <= clashRegMEM[2] ? memResultIn_MEMWD : regData2In_IDEX;
    end else if(clashRegEX[1])begin
        exSrcAOut <= clashRegEX[3] ? exResultIn_EXMEM : regData1In_IDEX;
        exSrcBOut <= clashRegEX[2] ? exResultIn_EXMEM : regData2In_IDEX;
    end else begin
        exSrcAOut <= regData1In_IDEX;
        exSrcBOut <= regData2In_IDEX;
    end
end

always @(posedge clk or negedge rst)begin
    if(!rst)begin
        clashRegEX <= 4'b0000;
        clashRegMEM <= 4'b0000;
    end else begin
        clashRegEX[0] <= loadClash;
        clashRegEX[1] <= normalClash;
        clashRegEX[2] <= toSrcB;
        clashRegEX[3] <= toSrcA;
        clashRegMEM <= clashRegEX;
    end
end

endmodule