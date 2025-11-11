`include "RVX_Info.v"

module AL_Jump (
    input wire clk,
    input wire rst,

    input wire [(`RVINST_W-1):0] instIn_IDEX,
    input wire branchTaken_EX,
    input wire [(`BUS_W-1):0] exResultIn_EXMEM,

    output reg jumpEnOut,
    output reg [(`BUS_W-1):0] jumpAddrOut,
    output reg flushIFOut,
    output reg flushIDOut
);

wire [6:0] opcodeIDEX;
assign opcodeIDEX = instIn_IDEX[6:0];

always @(*)begin
    jumpAddrOut = exResultIn_EXMEM;
end

always @(*)begin
    if(branchTaken_EX)begin
        flushIFOut <= 1'b1;
        flushIDOut <= 1'b1;
    end else begin
        case (opcodeIDEX)
            `OP_IJ, `OP_J : begin
                flushIFOut <= 1'b1;
                flushIDOut <= 1'b1;
            end
            default: begin
                flushIFOut <= 1'b0;
                flushIDOut <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk or negedge rst)begin
    if(!rst)begin
        jumpEnOut <= 1'b0;
    end else begin
        if(branchTaken_EX)begin
            jumpEnOut <= 1'b1;
        end else begin
            case(opcodeIDEX)
            `OP_IJ, `OP_J : jumpEnOut <= 1'b1;
            default : jumpEnOut <= 1'b0;
            endcase
        end
    end
end

endmodule