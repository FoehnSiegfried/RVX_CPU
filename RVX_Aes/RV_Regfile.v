`include "RVX_Info.v"

module RV_Regfile (
    input wire clk,
    input wire rst,

    input wire we,
    input wire [4:0] waddr,
    input wire [(`BUS_W-1):0] wdata,

    input wire [4:0] raddr1,
    output wire [(`BUS_W-1):0] rdata1,

    input wire [4:0] raddr2,
    output wire [(`BUS_W-1):0] rdata2
);

reg [(`BUS_W-1):0] regfile [0:31];

assign rdata1 = (raddr1 == 5'b0) ? {`BUS_W{1'b0}} :
                ((raddr1 == waddr) && we) ? wdata :
                regfile[raddr1];

assign rdata2 = (raddr2 == 5'b0) ? {`BUS_W{1'b0}} :
                ((raddr2 == waddr) && we) ? wdata :
                regfile[raddr2];

always @(*)begin
    if(we && (waddr != 5'b0))begin
        regfile[waddr] <= wdata;
    end
end

integer i;
always @(negedge rst) begin
    if (!rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] <= {`BUS_W{1'b0}};
        end
    end
end
    
endmodule