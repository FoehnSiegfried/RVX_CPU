`include "RVX_Info.v"

module Decoder_MEM (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    output wire [4:0] memOpOut
);

wire workEn;
wire dmWR;
wire [2:0] cptOp;

wire isOP_S;
wire isOP_IL;
assign isOP_S = (opcode == `OP_S);
assign isOP_IL= (opcode == `OP_IL);

assign workEn = (isOP_S || isOP_IL);
assign dmWR = isOP_S;
assign cptOp = funct3;

assign memOpOut = {cptOp, dmWR, workEn};

endmodule