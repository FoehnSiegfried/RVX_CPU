`include "RVX_Info.v"

module Stage_ID (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,

    input wire [4:0] regAddrIn,             //regfile
    input wire regWeIn,                     //regfile
    input wire [(`BUS_W-1):0] regWDataIn,   //regfile

    input wire [(`BUS_W-1):0] instIn,
    input wire [(`BUS_W-1):0] pcIn,
    input wire [(`BUS_W-1):0] pcPlusIn,

    output reg [11:0] exOpOut,
    output reg [4:0] memOpOut,
    output reg [7:0] wdOpOut,
    output reg [(`BUS_W-1):0] pcOut,
    output reg [(`BUS_W-1):0] pcPlusOut,
    output reg [(`BUS_W-1):0] regData1Out,
    output reg [(`BUS_W-1):0] regData2Out,
    output reg [(`BUS_W-1):0] immOut,
    output reg [(`BUS_W-1):0] pcPlusImmOutToEX,

    //alc
    output reg [(`BUS_W-1):0] instOut,
    output reg [(`BUS_W-1):0] pcPlusImmOutToAL,
    output reg [(`BUS_W-1):0] pcPlusRegData1OutToAL
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
assign opcode = instIn[6:0];
assign funct3 = instIn[14:12];
assign funct7 = instIn[31:25];
assign rd = instIn[11:7];
assign rs1 = instIn[19:15];
assign rs2 = instIn[24:20];

wire [11:0] exOp;
wire [4:0] memOp;
wire [7:0] wdOp;
wire [(`BUS_W-1):0] imm;
wire [(`BUS_W-1):0] regData1;
wire [(`BUS_W-1):0] regData2;

wire [(`BUS_W-1):0] pcPlusImm;
assign pcPlusImm = pcIn + imm;

always @(*) begin
    pcPlusImmOutToAL = pcPlusImm;
    pcPlusRegData1OutToAL = regData1 + imm;
end

Splicer_Imm si_mod(
    .instIn(instIn),
    .immOut(imm)
);

Decoder_EX de_mod(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .exOpOut(exOp)
);

Decoder_MEM dm_mod(
    .opcode(opcode),
    .funct3(funct3),
    .memOpOut(memOp)
);

Decoder_WD dw_mod(
    .opcode(opcode),
    .rd(rd),
    .wdOpOut(wdOp)
);

RV_Regfile_Test reg_mod(
    .clk(clk),
    .rst(rst),
    .we(regWeIn),
    .waddr(regAddrIn),
    .wdata(regWDataIn),
    .raddr1(rs1),
    .rdata1(regData1),
    .raddr2(rs2),
    .rdata2(regData2)
);

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        exOpOut <= 12'b0000_0000_0000;
        memOpOut<= 5'b00000;
        wdOpOut <= 8'b0000_0000;
        pcOut <= {`BUS_W{1'b0}};
        pcPlusOut <= {`BUS_W{1'b0}};
        regData1Out <= {`BUS_W{1'b0}};
        regData2Out <= {`BUS_W{1'b0}};
        immOut <= {`BUS_W{1'b0}};
        pcPlusImmOutToEX <= {`BUS_W{1'b0}};
        instOut <= {`BUS_W{1'b0}};
    end else begin
        exOpOut <= exOp;
        memOpOut<= memOp;
        wdOpOut <= wdOp;
        pcOut <= pcIn;
        pcPlusOut <= pcPlusIn;
        regData1Out <= regData1;
        regData2Out <= regData2;
        immOut <= imm;
        pcPlusImmOutToEX <= pcPlusImm;
        instOut <= instIn;
    end
end

endmodule