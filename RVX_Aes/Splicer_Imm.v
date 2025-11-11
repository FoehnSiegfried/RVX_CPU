`include "RVX_Info.v"

module Splicer_Imm (
    input wire [(`BUS_W-1):0] instIn,
    output reg [(`BUS_W-1):0] immOut
);
reg [6:0] opcode;
reg [(`BUS_W-1):0] imm_i;
reg [(`BUS_W-1):0] imm_s;
reg [(`BUS_W-1):0] imm_b;
reg [(`BUS_W-1):0] imm_u;
reg [(`BUS_W-1):0] imm_j;

always @(*) begin
    opcode <= instIn[6:0];
    imm_i <= {{20{instIn[31]}}, instIn[31:20]};
    imm_s <= {{20{instIn[31]}}, instIn[31:25], instIn[11:7]};
    imm_b <= {{19{instIn[31]}}, instIn[7], instIn[30:25], instIn[11:8], 1'b0};
    imm_u <= {instIn[31:12], 12'b0};
    imm_j <= {{11{instIn[31]}}, instIn[31], instIn[19:12], instIn[20], instIn[30:21], 1'b0};
end

always @(*) begin
    case(opcode)
    `OP_I, `OP_IL, `OP_IJ, `OP_IE : immOut <= imm_i;
    `OP_S : immOut <= imm_s;
    `OP_B : immOut <= imm_b;
    `OP_U : immOut <= imm_u;
    `OP_J : immOut <= imm_j;
    default : immOut <= {`BUS_W{1'b0}};
    endcase
end

endmodule