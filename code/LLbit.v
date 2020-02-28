`include"define.v"
module LLbit(
    input wire wLLbit,
    input wire wbit,
    input wire clk,
    input wire excpt,
    input wire rst,
    output reg rLLbit
    );

    always@(posedge clk)
        if(rst == `RstEnable)
            rLLbit = 0;
        else if(wbit == `Valid)
            rLLbit = wLLbit;

    always@(posedge clk)
        if(excpt == 1)
            rLLbit = 0; 
endmodule
