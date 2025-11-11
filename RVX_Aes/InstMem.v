`include "RVX_Info.v"

`define INST_MEM_SIZE 128

module InstMem (
    input wire clk,
    input wire [(`BUS_W-1):0] imAddrIn,

    output wire [(`BUS_W-1):0] instOut
);

reg [7:0] im [0:(`INST_MEM_SIZE-1)];

assign instOut = {im[imAddrIn+3], im[imAddrIn+2], im[imAddrIn+1], im[imAddrIn]};

integer i;
initial begin
    for (i = 0; i < `INST_MEM_SIZE; i=i+1)begin
        im[i] = 8'b0000_0000;
    end
    //addi a0 zero 5
    im[0] = 8'h13;
    im[1] = 8'h05;
    im[2] = 8'h50;
    im[3] = 8'h00;
    //addi a1 a1 1
    im[4] = 8'h93;
    im[5] = 8'h85;
    im[6] = 8'h15;
    im[7] = 8'h00;
    //bne a1 a0 -4
    im[8] = 8'h6f;
    im[9] = 8'hf6;
    im[10] = 8'hdf;
    im[11] = 8'hff;
end
    
endmodule