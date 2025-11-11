`include "RVX_Info.v"

module RV_Regfile (
    input wire clk,
    input wire rst,

    input wire we,
    input wire [4:0] waddr,
    input wire [(`BUS_W-1):0] wdata,

    input wire [4:0] raddr1,
    output reg [(`BUS_W-1):0] rdata1,

    input wire [4:0] raddr2,
    output reg [(`BUS_W-1):0] rdata2
);

reg [(`BUS_W-1):0] regfile [0:31];

always @(*)begin
    if(raddr1 == 5'b0)begin
        rdata1 = {`BUS_W{1'b0}};
    end else if((raddr1 == waddr) && we) begin
        rdata1 = wdata;
    end else begin
        rdata1 = regfile[raddr1];
    end
end

always @(*)begin
    if(raddr2 == 5'b0)begin
        rdata2 = {`BUS_W{1'b0}};
    end else if((raddr2 == waddr) && we) begin
        rdata2 = wdata;
    end else begin
        rdata2 = regfile[raddr2];
    end
end

integer i;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] <= {`BUS_W{1'b0}};
        end
    end else begin
        if(we && (waddr != 5'b0))begin
        regfile[waddr] <= wdata;
        end
    end
end
    
endmodule