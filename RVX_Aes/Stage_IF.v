`include "RVX_Info.v"

`define ONE_INST_W 3'b001

module Stage_IF (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,
//out
    input wire [(`BUS_W-1):0] instIn,
    output reg [(`BUS_W-1):0] instAddrOut,  //pc
//me
    input wire jumpEn,
    input wire [(`BUS_W-1):0] jumpAddr,

    output reg [(`BUS_W-1):0] pcOut,
    output reg [(`BUS_W-1):0] pcPlusOut,
    output reg [(`BUS_W-1):0] instOut
);

wire [(`BUS_W-1):0] pc;
wire [(`BUS_W-1):0] pcPlus;
reg [(`BUS_W-1):0] nextPC;
assign pc = jumpEn ? jumpAddr : nextPC;
assign pcPlus = pc + `ONE_INST_W;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        nextPC <= {`BUS_W{1'b0}};
    end else begin
        nextPC <= flush ? pc :
                  stall ? pc :
                  pcPlus;
    end
end

always @(*)begin
    instAddrOut = pc;
end

always @(posedge clk or negedge rst) begin
    if(!rst || flush) begin
        pcOut <= {`BUS_W{1'b0}};
        pcPlusOut <= {`BUS_W{1'b0}};
        instOut <= `NOP;
    end else if(stall) begin
        
    end else begin
        pcOut <= pc;
        pcPlusOut <= pcPlus;
        instOut <= instIn;
    end
end

endmodule