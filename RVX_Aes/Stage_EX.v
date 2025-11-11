`include "RVX_Info.v"

module Stage_EX (
    input wire clk,
    input wire rst,
    input wire flush,
//out
    input wire [4:0] memOpIn,
    input wire [7:0] wdOpIn,
    input wire [(`BUS_W-1):0] pcPlusIn,
    output reg [4:0] memOpOut,
    output reg [7:0] wdOpOut,
    output reg [(`BUS_W-1):0] regData2Out,
    output reg [(`BUS_W-1):0] pcPlusOut,
    output reg [(`BUS_W-1):0] immOut,
//me
    input wire [11:0] exOpIn,
    input wire [(`BUS_W-1):0] regData1In,
    input wire [(`BUS_W-1):0] pcIn,
    input wire [(`BUS_W-1):0] regData2In,
    input wire [(`BUS_W-1):0] immIn,
    output reg [(`BUS_W-1):0] exResultOut,  //create
    output wire branchTakenOut              //create
);

reg workEn;
reg aluEn;
reg branchEn;
reg aluSrcASelect;
reg aluSrcBSelect;
reg [3:0] aluOp;
reg [2:0] branchOp;

always @(*) begin
    workEn <= exOpIn[0];
    aluEn <= exOpIn[2];
    branchEn <= exOpIn[1];
    aluSrcASelect <= exOpIn[4];
    aluSrcBSelect <= exOpIn[3];
    aluOp <= exOpIn[8:5];
    branchOp <= exOpIn[11:9];
end

wire [(`BUS_W-1):0] aluSrcA;
wire [(`BUS_W-1):0] aluSrcB;
assign aluSrcA = aluSrcASelect ? pcIn : regData1In;
assign aluSrcB = aluSrcBSelect ? immIn: regData2In;

wire [(`BUS_W-1):0] aluOut;
wire branchTaken;

RV_ALU ra_mod(
    .aluOp(aluOp),
    .srcA(aluSrcA),
    .srcB(aluSrcB),
    .aluOut(aluOut)
);

RV_Branch rb_mod(
    .branchOp(branchOp),
    .srcA(regData1In),
    .srcB(regData2In),
    .branchTaken(branchTaken)
);

assign branchTakenOut = branchEn ? branchTaken : 1'b0;

always @(posedge clk or negedge rst) begin
    if(!rst || flush)begin
        memOpOut <= 5'b00000;
        wdOpOut <= 8'b0000_0000;
        regData2Out <= {`BUS_W{1'b0}};
        pcPlusOut <= {`BUS_W{1'b0}};
        immOut <= {`BUS_W{1'b0}};
        exResultOut <= {`BUS_W{1'b0}};
    end else begin
        memOpOut <= memOpIn;
        wdOpOut <= wdOpIn;
        regData2Out <= regData2In;
        pcPlusOut <= pcPlusIn;
        immOut <= immIn;
        if(workEn)begin
            if(aluEn) exResultOut <= aluOut;
            else exResultOut <= {`BUS_W{1'b0}};
        end else begin
            exResultOut <= {`BUS_W{1'b0}};
        end
    end
end

endmodule