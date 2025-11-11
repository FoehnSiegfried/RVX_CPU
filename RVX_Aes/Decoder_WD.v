`include "RVX_Info.v"

module Decoder_WD (
    input wire [6:0] opcode,
    input wire [4:0] rd,
    output wire [7:0] wdOpOut
);

wire workEn;
reg [1:0] dataSelect;
wire [4:0] regAddr;
assign workEn = ((opcode != `OP_IE) && (opcode != `OP_S) && (opcode != `OP_B));
assign regAddr = rd;
always @(*) begin
    case(opcode)
    `OP_IL : dataSelect = 2'b01;
    `OP_IJ, `OP_J : dataSelect = 2'b11;
    `OP_U : dataSelect = 2'b10;
    default : dataSelect = 2'b00;
    endcase
end

assign wdOpOut = {regAddr, dataSelect, workEn};
    
endmodule