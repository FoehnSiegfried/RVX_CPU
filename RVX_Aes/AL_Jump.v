`include "RVX_Info.v"

module AL_Jump (
    input wire clk,
    input wire rst,

    input wire [(`RVINST_W-1):0] instIn_IFID,
    input wire branchTaken_EX,
    input wire [(`BUS_W-1):0] pcPlusImmIn_IDEX,//br
    input wire [(`BUS_W-1):0] pcPlusImmIn_ID,//ju
    input wire [(`BUS_W-1):0] pcPlusRegData1In_ID,//ju

    output reg jumpEnOut,
    output reg [(`BUS_W-1):0] jumpAddrOut,
    output reg flushIFOut,
    output reg flushIDOut
);

wire [6:0] opcodeIFID;
assign opcodeIFID = instIn_IFID[6:0];

reg jumpEn;
reg jumpAddr;

always @(*) begin
    if(branchTaken_EX)begin
        flushIFOut <= 1'b1;
        flushIDOut <= 1'b1;
        jumpEn <= 1'b1;
        jumpAddr <= pcPlusImmIn_IDEX;
    end else begin
        case (opcodeIFID)
            `OP_IJ : begin
                flushIFOut <= 1'b1;
                flushIDOut <= 1'b0;
                jumpEn <= 1'b1;
                jumpAddr <= pcPlusRegData1In_ID;
            end
            `OP_J : begin
                flushIFOut <= 1'b1;
                flushIDOut <= 1'b0;
                jumpEn <= 1'b1;
                jumpAddr <= pcPlusImmIn_ID;
            end
            default: begin
                flushIFOut <= 1'b0;
                flushIDOut <= 1'b0;
                jumpEn <= 1'b0;
                jumpAddr <= {`BUS_W{1'b0}};
            end
        endcase
    end
end

always @(posedge clk or negedge rst)begin
    if(!rst)begin
        jumpEnOut <= 1'b0;
        jumpAddrOut <= {`BUS_W{1'b0}};
    end else begin
        jumpEnOut <= jumpEn;
        jumpAddrOut <= jumpAddr;
    end
end
    
endmodule