`include"define.v"
module IO(
    input wire clk,
    input wire ce,
    input wire we,
    input wire [31:0]wtData,
    input wire [31:0]addr,
    output reg [31:0]rdData,

    output reg [31:0]Seg,
    output reg [15:0]Led,
    input wire [1:0]Sel,
    input wire [31:0]Button
    );
/*    reg [31:0]IORam[9:0];
    reg [10:0]Index;

    initial
        IORam[1] = 32'hffff_ffff;

    always@(*)
        Index = addr[12:2] - 11'b1_0000_0000_00; */

    always@(*)
        if(ce == `IODisable)
            rdData = `Zero;
        else if(we == `IOUnWrite)
            case(addr)   
                `KEY:begin
                    rdData = {16{Sel}};
                end
                `BUTTON:begin
                    rdData = Button;
                end
            endcase
    always@(posedge clk)
        if(ce == `IOEnable && we == `IOWrite)
            case(addr)
                `SEG:begin
                    Seg = wtData;
                end
                `LED:begin
                    Led = wtData[15:0];
                end
           endcase
endmodule
