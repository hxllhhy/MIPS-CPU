`include"define.v"
module HiLo(
            input clk,
            input rst,
            input wire [31:0]loData,
            input wire wlo,
            input wire [31:0]hiData,
            input wire whi,
            output reg [31:0]rlo,
            output reg [31:0]rhi
);
    always@(posedge clk)
        if(rst == `RstEnable)
            rhi = `Zero;
        else if(whi == `Valid)
            rhi = hiData;      //rhi and rlo will not change but wlo is Valid
/*        else
            rlo = `Zero;*/

    always@(posedge clk)
        if(rst == `RstEnable)
            rlo = `Zero;
        else if(wlo == `Valid)
            rlo = loData;
/*        else
            rhi = `Zero;*/

endmodule
