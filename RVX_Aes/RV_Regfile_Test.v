`include "RVX_Info.v"

module RV_Regfile_Test (
    input wire clk,
    input wire rst,

    input wire we,
    input wire [4:0] waddr,
    input wire [(`BUS_W-1):0] wdata,

    input wire [4:0] raddr1,
    output wire [(`BUS_W-1):0] rdata1,

    input wire [4:0] raddr2,
    output wire [(`BUS_W-1):0] rdata2,

    output wire [(`BUS_W-1):0] rf_0,
    output wire [(`BUS_W-1):0] rf_1,
    output wire [(`BUS_W-1):0] rf_2,
    output wire [(`BUS_W-1):0] rf_3,
    output wire [(`BUS_W-1):0] rf_4,
    output wire [(`BUS_W-1):0] rf_5,
    output wire [(`BUS_W-1):0] rf_6,
    output wire [(`BUS_W-1):0] rf_7,
    output wire [(`BUS_W-1):0] rf_8,
    output wire [(`BUS_W-1):0] rf_9,
    output wire [(`BUS_W-1):0] rf_10,
    output wire [(`BUS_W-1):0] rf_11,
    output wire [(`BUS_W-1):0] rf_12,
    output wire [(`BUS_W-1):0] rf_13,
    output wire [(`BUS_W-1):0] rf_14,
    output wire [(`BUS_W-1):0] rf_15,
    output wire [(`BUS_W-1):0] rf_16,
    output wire [(`BUS_W-1):0] rf_17,
    output wire [(`BUS_W-1):0] rf_18,
    output wire [(`BUS_W-1):0] rf_19,
    output wire [(`BUS_W-1):0] rf_20,
    output wire [(`BUS_W-1):0] rf_21,
    output wire [(`BUS_W-1):0] rf_22,
    output wire [(`BUS_W-1):0] rf_23,
    output wire [(`BUS_W-1):0] rf_24,
    output wire [(`BUS_W-1):0] rf_25,
    output wire [(`BUS_W-1):0] rf_26,
    output wire [(`BUS_W-1):0] rf_27,
    output wire [(`BUS_W-1):0] rf_28,
    output wire [(`BUS_W-1):0] rf_29,
    output wire [(`BUS_W-1):0] rf_30,
    output wire [(`BUS_W-1):0] rf_31
);

reg [(`BUS_W-1):0] regfile [0:31];

assign rf_0 = regfile[0];
assign rf_1 = regfile[1];
assign rf_2 = regfile[2];
assign rf_3 = regfile[3];
assign rf_4 = regfile[4];
assign rf_5 = regfile[5];
assign rf_6 = regfile[6];
assign rf_7 = regfile[7];
assign rf_8 = regfile[8];
assign rf_9 = regfile[9];
assign rf_10 = regfile[10];
assign rf_11 = regfile[11];
assign rf_12 = regfile[12];
assign rf_13 = regfile[13];
assign rf_14 = regfile[14];
assign rf_15 = regfile[15];
assign rf_16 = regfile[16];
assign rf_17 = regfile[17];
assign rf_18 = regfile[18];
assign rf_19 = regfile[19];
assign rf_20 = regfile[20];
assign rf_21 = regfile[21];
assign rf_22 = regfile[22];
assign rf_23 = regfile[23];
assign rf_24 = regfile[24];
assign rf_25 = regfile[25];
assign rf_26 = regfile[26];
assign rf_27 = regfile[27];
assign rf_28 = regfile[28];
assign rf_29 = regfile[29];
assign rf_30 = regfile[30];
assign rf_31 = regfile[31];

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