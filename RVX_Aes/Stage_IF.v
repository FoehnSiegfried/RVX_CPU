`include "RVX_Info.v"

`define ONE_INST_W 3'b100

module Stage_IF (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,
//out
    input wire [(`BUS_W-1):0] instIn,
    output reg [(`BUS_W-1):0] instOut,
//me
    input wire jumpEn,
    input wire [(`BUS_W-1):0] jumpAddr,
    output reg [(`BUS_W-1):0] pcOut,
    output reg [(`BUS_W-1):0] pcPlusOut
);

reg [(`BUS_W-1):0] pc;
wire [(`BUS_W-1):0] pcPlus;
wire [(`BUS_W-1):0] nextPc;
assign pcPlus = pc + `ONE_INST_W;
assign nextPc = flush ? pc :
                jumpEn? jumpAddr :
                stall ? pc :
                pcPlus;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        pc <= {`BUS_W{1'b0}};
    end else begin
        pc <= nextPc;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        instOut <= {`RVINST_W{1'b0}};
        pcOut <= {`BUS_W{1'b0}};
        pcPlusOut <= {`BUS_W{1'b0}};
    end else if(flush) begin
        instOut <= {`RVINST_W{1'b0}};
        pcOut <= {`BUS_W{1'b0}};
        pcPlusOut <= {`BUS_W{1'b0}};
    end else if(stall) begin
        
    end else begin
        instOut <= instIn;
        pcOut <= pc;
        pcPlusOut <= pcPlus;
    end
end

endmodule