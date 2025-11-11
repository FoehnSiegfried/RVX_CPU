`include "RVX_Info.v"

`define DATA_MEM_SIZE 8192

module DataMem (
    input wire clk,
    input wire rst,
    input wire [(`BUS_W-1):0] dmAddrIn,    //dm
    input wire dmWeIn,                     //dm
    input wire dmReIn,                     //dm
    input wire [3:0] dmDataWIn,            //dm
    input wire [(`BUS_W-1):0] dmWDataIn,   //dm

    output reg [(`BUS_W-1):0] dmRDataOut    //dm
);

reg [7:0] dm [0:(`DATA_MEM_SIZE-1)];

always @(*) begin
    if (dmReIn) begin
        dmRDataOut = {dm[dmAddrIn+3], dm[dmAddrIn+2], dm[dmAddrIn+1], dm[dmAddrIn]};
    end else begin
        dmRDataOut = {`BUS_W{1'b0}};
    end
end

integer i;
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        for (i = 0; i < `DATA_MEM_SIZE ; i=i+1) begin
            dm[i] = 8'b0000_0000;
        end
    end else begin
        if (dmWeIn) begin
        case(dmDataWIn)
            4'b0001: begin
                dm[dmAddrIn] <= dmWDataIn[7:0];
            end
            4'b0011: begin
                dm[dmAddrIn+1] <= dmWDataIn[15:8];
                dm[dmAddrIn]   <= dmWDataIn[7:0];
            end
            4'b1111: begin
                dm[dmAddrIn+3] <= dmWDataIn[31:24];
                dm[dmAddrIn+2] <= dmWDataIn[23:16];
                dm[dmAddrIn+1] <= dmWDataIn[15:8];
                dm[dmAddrIn]   <= dmWDataIn[7:0];
            end
        endcase
        end
    end
end

endmodule