`include "RVX_Info.v"

module Stage_MEM (
    input wire clk,
    input wire rst,
    input wire flush,
//out
    input wire [7:0] wdOpIn,
    input wire [(`BUS_W-1):0] pcPlusIn,
    input wire [(`BUS_W-1):0] immIn,
    output reg [7:0] wdOpOut,
    output reg [(`BUS_W-1):0] pcPlusOut,
    output reg [(`BUS_W-1):0] exResultOut,
    output reg [(`BUS_W-1):0] immOut,
//me
    input wire [4:0] memOpIn,
    input wire [(`BUS_W-1):0] exResultIn,
    input wire [(`BUS_W-1):0] regData2In,
    input wire [(`BUS_W-1):0] dmRDataIn,    //dm
    output reg [(`BUS_W-1):0] dmAddrOut,    //dm
    output reg dmWeOut,                     //dm
    output reg dmReOut,                     //dm
    output reg [3:0] dmDataWOut,            //dm
    output reg [(`BUS_W-1):0] dmWDataOut,   //dm
    output reg [(`BUS_W-1):0] memResultOut  //create
);

parameter LB = 3'b000;
parameter LH = 3'b001;
parameter LW = 3'b010;
parameter LBU = 3'b100;
parameter LHU = 3'b101;

parameter SB = 3'b000;
parameter SH = 3'b001;
parameter SW = 3'b010;

reg workEn; // 0 OFF , 1 ON
reg dmWR; // 0 READ, 1 WRITE
reg [2:0] cptOp;

always @(*) begin
    workEn <= memOpIn[0];
    dmWR <= memOpIn[1];
    cptOp <= memOpIn[4:2];
end

reg [(`BUS_W-1):0] dmRData;
always @(*)begin
    if(workEn)begin
        dmAddrOut <= exResultIn;
        dmWeOut <= dmWR;
        dmReOut <= !dmWR;
        case(cptOp)
        SB : dmDataWOut <= 4'b0001;
        SH : dmDataWOut <= 4'b0011;
        SW : dmDataWOut <= 4'b1111;
        default : dmDataWOut <= 4'b0000;
        endcase
        if(dmWR)begin
            case(cptOp)
            SB : dmWDataOut <= {{(`BUS_W-8){1'b0}}, regData2In[7:0]};
            SH : dmWDataOut <= {{(`BUS_W-16){1'b0}}, regData2In[15:0]};
            SW : dmWDataOut <= regData2In;
            default : dmWDataOut <= {`BUS_W{1'b0}};
            endcase
        end else begin
            case(cptOp)
            LB : dmRData <= {{(`BUS_W-8){dmRDataIn[7]}}, dmRDataIn[7:0]};
            LH : dmRData <= {{(`BUS_W-16){dmRDataIn[15]}}, dmRDataIn[15:0]};
            LW : dmRData <= dmRDataIn;
            LBU : dmRData <= {{(`BUS_W-8){1'b0}}, dmRDataIn[7:0]};
            LHU : dmRData <= {{(`BUS_W-16){1'b0}}, dmRDataIn[15:0]};
            default : dmRData <= {`BUS_W{1'b0}};
            endcase
        end
    end else begin
        dmAddrOut <= {`BUS_W{1'b0}};
        dmWeOut <= 1'b0;
        dmReOut <= 1'b0;
        dmDataWOut <= 4'b0000;
        dmWDataOut <= {`BUS_W{1'b0}};
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst || flush) begin
        wdOpOut <= 8'b0000_0000;
        pcPlusOut <= {`BUS_W{1'b0}};
        exResultOut <= {`BUS_W{1'b0}};
        dmRData <= {`BUS_W{1'b0}};
        memResultOut <= {`BUS_W{1'b0}};
        immOut <= {`BUS_W{1'b0}};
    end else begin
        wdOpOut <= wdOpIn;
        pcPlusOut <= pcPlusIn;
        exResultOut <= exResultIn;
        memResultOut <= dmRData;
        immOut <= immIn;
    end
end

endmodule