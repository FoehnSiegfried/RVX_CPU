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
    output reg [(`BUS_W-1):0] immOut,
    output reg [(`BUS_W-1):0] instOut,

    //allto
    output reg [(`BUS_W-1):0] regData1Out,
    output reg [(`BUS_W-1):0] regData2Out
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rd;
assign opcode = instIn[6:0];
assign funct3 = instIn[14:12];
assign funct7 = instIn[31:25];
assign rd = instIn[11:7];

wire [11:0] exOp;
wire [4:0] memOp;
wire [7:0] wdOp;
wire [(`BUS_W-1):0] imm;
wire [(`BUS_W-1):0] regData1;
wire [(`BUS_W-1):0] regData2;

reg [4:0] raddr1, raddr2;

always @(*)begin
    regData1Out<= regData1;
    regData2Out<= regData2;
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
    .raddr1(raddr1),
    .rdata1(regData1),
    .raddr2(raddr2),
    .rdata2(regData2)
);

always @(posedge clk or negedge rst) begin
    if(!rst || flush) begin
        exOpOut <= 12'b0000_0000_0000;
        memOpOut<= 5'b00000;
        wdOpOut <= 8'b0000_0000;
        pcOut <= {`BUS_W{1'b0}};
        pcPlusOut <= {`BUS_W{1'b0}};
        immOut <= {`BUS_W{1'b0}};
        instOut <= {`BUS_W{1'b0}};
        raddr1 <= 5'b00000;
        raddr2 <= 5'b00000;
    end else begin
        exOpOut <= exOp;
        memOpOut<= memOp;
        wdOpOut <= wdOp;
        pcOut <= pcIn;
        pcPlusOut <= pcPlusIn;
        immOut <= imm;
        instOut <= instIn;
        raddr1 <= instIn[19:15];
        raddr2 <= instIn[24:20];
    end
end

endmodule