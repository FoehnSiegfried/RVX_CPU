`include "RVX_Info.v"

module Decoder_EX (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output wire [11:0] exOpOut
);

reg workEn;
reg aluEn;
reg branchEn;
reg aluSrcASelect;//0rs1,1pc
reg aluSrcBSelect;//0rs2,1imm
reg [2:0] branchOp;
reg [3:0] aluOp;

wire [3:0] aluOp_R;
wire [3:0] aluOp_I;
wire funct7Is0x00;
wire funct7Is0x20;
wire funct3Islla;// funct3 is sll ,srl ,sra
assign funct7Is0x00 = (funct7 == 7'b000_0000);
assign funct7Is0x20 = (funct7 == 7'b010_0000);
assign funct3Islla = ((funct3 == 3'b001) || (funct3 == 3'b101));

assign aluOp_R = funct7Is0x00 ? {1'b0, funct3} :
                 funct7Is0x20 ? {1'b1, funct3} :
                 4'b1111;
assign aluOp_I = funct3Islla ? aluOp_R : {1'b0, funct3};

always @(*) begin
    branchOp = funct3;
    case(opcode)
    `OP_R : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;//rs1
        aluSrcBSelect = 1'b0;//rs2
        aluOp = aluOp_R;
    end
    `OP_I : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;//rs1
        aluSrcBSelect = 1'b1;//imm
        aluOp = aluOp_I;
    end
    `OP_IL : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;//rs1
        aluSrcBSelect = 1'b1;//imm
        aluOp = 4'b0000;
    end
    `OP_IJ : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;//rs1
        aluSrcBSelect = 1'b1;//imm
        aluOp = 4'b0000;
    end
    `OP_IE : begin
        workEn = 1'b0;
        aluEn = 1'b0;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;
        aluSrcBSelect = 1'b0;
        aluOp = 4'b1111;
    end
    `OP_S : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;//rs1
        aluSrcBSelect = 1'b1;//imm
        aluOp = 4'b0000;
    end
    `OP_B : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b1;
        aluSrcASelect = 1'b1;//pc
        aluSrcBSelect = 1'b1;//imm
        aluOp = 4'b0000;
    end
    `OP_U : begin
        workEn = 1'b0;
        aluEn = 1'b0;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;
        aluSrcBSelect = 1'b0;
        aluOp = 4'b1111;
    end
    `OP_UA : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b0;
        aluSrcASelect = 1'b1;//pc
        aluSrcBSelect = 1'b1;//imm
        aluOp = 4'b0000;
    end
    `OP_J : begin
        workEn = 1'b1;
        aluEn = 1'b1;
        branchEn = 1'b0;
        aluSrcASelect = 1'b1;//pc
        aluSrcBSelect = 1'b1;//imm
        aluOp = 4'b0000;
    end
    default : begin
        workEn = 1'b0;
        aluEn = 1'b0;
        branchEn = 1'b0;
        aluSrcASelect = 1'b0;
        aluSrcBSelect = 1'b0;
        aluOp = 4'b1111;
    end
    endcase
end

assign exOpOut = {branchOp, aluOp, aluSrcASelect, aluSrcBSelect, aluEn, branchEn, workEn};

endmodule