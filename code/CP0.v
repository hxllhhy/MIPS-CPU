`include"define.v"
module CP0(
    input wire clk,
    input wire rst,
    input wire [5:0]int,
    input wire cp0we,
    input wire [4:0]cp0wAddr,
    input wire [31:0]cp0wData,
    input wire [4:0]cp0rAddr,
    input wire [31:0]excptype,
    input wire [31:0]epc,
    output reg [5:0]intimer,
    output reg [31:0]cp0rData 
    );
//////////////////////////////////////////////////////////////////////////read and wirete cp0ram
    reg [31:0]cp0ram[31:0];
    reg [31:0]epc_temp;
    initial
        begin
            cp0rData = `Zero;
            intimer = `IntNotAssert;
            cp0ram[`Count] = `Zero;
            cp0ram[`Compare] = `Zero;
            cp0ram[`Status] = 32'h1000_0000;
            cp0ram[`Cause] = `Zero;
            cp0ram[`EPC] = `Zero;
        end
    always@(posedge clk)
        begin
            if(rst == `RstEnable)
                begin
                    cp0rData = `Zero;
                    intimer = `IntNotAssert;
                    cp0ram[`Count] = `Zero;
                    cp0ram[`Compare] = `Zero;
                    cp0ram[`Status] = 32'h1000_0000;
                    cp0ram[`Cause] = `Zero;
                    cp0ram[`EPC] = `Zero;
                end
            else
                begin
                    cp0ram[`Count] = cp0ram[`Count] + 1;
                    if(cp0ram[`Count] == cp0ram[`Compare] && cp0ram[`Compare] != 0)
                        intimer[0] = `IntAssert;
 
                    if(cp0we == `RamWrite)
                        case(cp0wAddr)
                            `Count:
                                cp0ram[`Count] = cp0wData;
                            `Compare:
                                begin
                                    cp0ram[`Compare] = cp0wData;
                                    intimer = `IntNotAssert;        //Interrupt over
                                end
                            `Cause:
                                cp0ram[`Cause] = cp0wData;
                            `Status:
                                cp0ram[`Status] = cp0wData;
                            `EPC:
                                cp0ram[`EPC] = cp0wData;
    
                            /*default:
                                begin
                                    cp0rData = `Zero;
                                    intimer = `IntNotAssert;
                                    cp0ram[`Count] = `Zero;
                                    cp0ram[`Compare] = `Zero;
                                    cp0ram[`Status] = 32'h1000_0000;
                                    cp0ram[`Status][15:10] = int; 
                                    cp0ram[`Cause] = `Zero;
                                    cp0ram[`EPC] = `Zero;
                                end*/
                       endcase  
                end
        end

    always@(*)
        begin
            if(rst == `RstEnable)
                cp0rData = `Zero;
            else if(cp0we == `RamUnWrite)
                cp0rData = cp0ram[cp0rAddr]; 
        end

/////////////////////////////////////////////////////////////////////////////////

 /*   always@(posedge clk)
        if(rst == `RstEnable)
            cp0ram[`Status] = 32'h1000_0000;
        else //if(intimer == `IntNotAssert)
            begin
                epc_temp = cp0ram[`EPC];    
                //cp0ram[`Status] = {16'h1000,int,10'b0};
                cp0ram[`Status][15:10] = int;
                //cp0ram[`Status] = {cp0ram[`Status][31:16],int,cp0ram[`Status][9:0]};
                cp0ram[`EPC] = epc;
                //if(intimer == `IntAssert)
                //    cp0ram[`EPC] = epc_temp;
            end*/
    always@(*)
        if(rst == `RstEnable)
            cp0ram[`Status] = 32'h1000_0000;
        else
            begin   
                cp0ram[`Status][15:10] = int;
                if(intimer == `IntAssert && excptype == `CountInt)
                    cp0ram[`EPC] = epc + 4;
            end
    always@(posedge clk)
        if(excptype == `SysInt)
            cp0ram[`EPC] = epc;        
    /*always@(posedge clk)
        if(intimer == `IntNotAssert)
            cp0ram[`EPC] = epc;*/

endmodule
