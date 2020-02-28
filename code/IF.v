`include "define.v"
module IF(
    input wire clk,
    input wire rst,
    input wire [31:0]jAddr,
    input wire jCe,
    input wire excpt,
    input wire [31:0]ejpc,
    output reg romCe,
    output reg [31:0]pc
    );

    always@(*)
        if(rst == `RstEnable)
            romCe = `RomDisable;                   
        else
            romCe = `RomEnable;

    always@(posedge clk)
        if(romCe == `RomDisable)
            pc = `Zero;
        else if(jCe == `Valid)
            pc = jAddr;
        else if(excpt == `Valid)
            pc = ejpc;
        else
            pc = pc + 4;

endmodule
