`include "RVX_Info.v"

`define INST_MEM_SIZE 8192

module InstMem (
    input wire clk,
    input wire [(`BUS_W-1):0] imAddrIn,

    output wire [(`BUS_W-1):0] instOut
);

reg [31:0] im [0:(`INST_MEM_SIZE-1)];

assign instOut = {im[imAddrIn+3], im[imAddrIn+2], im[imAddrIn+1], im[imAddrIn]};

integer i;
initial begin
    for (i = 0; i < `INST_MEM_SIZE; i=i+1)begin
        im[i] = `NOP;
    end
    im[0]= `NOP;
im[1]=32'h01000513;
im[2]=32'h02000593;
im[3]=32'h04000613;
im[4]=32'h08000693;
im[5]=32'h00d52023;
im[6]=32'h00052783;
im[7]=32'h00d79263;
im[8]=32'h01000f93;
im[9]=32'h00000013;
im[10]=32'hfff00f93;
end

endmodule