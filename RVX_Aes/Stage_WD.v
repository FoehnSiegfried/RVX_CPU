`include "RVX_Info.v"

module Stage_WD (
    input wire clk,
    input wire rst,

    input wire [7:0] wdOpIn,
    input wire [(`BUS_W-1):0] pcPlusIn,
    input wire [(`BUS_W-1):0] exResultIn,
    input wire [(`BUS_W-1):0] memResultIn,
    input wire [(`BUS_W-1):0] immIn,
    output reg [4:0] regAddrOut,
    output reg regWeOut,
    output reg [(`BUS_W-1):0] regWDataOut
);

reg workEn;
reg [1:0] dataSelect;
always @(*)begin
    workEn <= wdOpIn[0];
    dataSelect <= wdOpIn[2:1];
end

always @(*) begin
    if(!rst || !workEn) begin
        regAddrOut <= 5'b00000;
        regWeOut <= 1'b0;
        regWDataOut <= {`BUS_W{1'b0}};
    end else begin
        regAddrOut <= wdOpIn[7:3];
        regWeOut <= workEn;
        case(dataSelect)
        2'b00 : regWDataOut <= exResultIn;
        2'b01 : regWDataOut <= memResultIn;
        2'b10 : regWDataOut <= immIn;
        2'b11 : regWDataOut <= pcPlusIn;
        endcase
    end
end

endmodule
