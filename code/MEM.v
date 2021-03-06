`include"define.v"
module Mem(
    input wire rst,
    input wire [5:0]op,
    input wire [31:0]regcData, //resault or memory address
    input wire [4:0]regcAddr,
    input wire regcWr,         //wheather write to target regfile
    
    input wire [31:0]memAddr_i,  //the address we want to write to DataMem or read from
    input wire [31:0]memData,
    input wire [31:0]RData,    //the data read from DataMem
    
    output reg [31:0]regData,
    output reg [4:0]regAddr,
    output reg regWr,
    
    output reg [31:0]memAddr,  //the address of the data where we want to write to DataMem or read from DataMem
    output reg [31:0]WData,
    output reg memWr,          //read the memory or write the memory
    output reg memCe,           //if the momory is valid

    output reg wLLbit,
    output reg wbit,
    input wire rLLbit
);
    always@(*)
    case(op)
        `Lw:
            begin
                memAddr = memAddr_i;
                memWr = `RamUnWrite;
                memCe = `RamEnable;
                WData = `Zero;        //why we need't to change regWr,because the changed RData would change the regData!
                regData = RData;
                regAddr = regcAddr;
                regWr = `Valid;
            end

        `Sw:
            begin
                regData = `Zero;
                regAddr = `Zero;
                regWr = `Invalid;

                memWr = `RamWrite;
                memCe = `RamEnable;
                memAddr = memAddr_i;
                WData = memData;
            end

        `Ll:
            begin
                memAddr = memAddr_i;
                memWr = `RamUnWrite;
                memCe = `RamEnable;
                WData = `Zero;        //why we need't to change regWr,because the changed RData would change the regData!
                regData = RData;
                regAddr = regcAddr;
                regWr = `Valid;
                wLLbit = 1;
                wbit = `Valid;
            end

        `Sc:
            if(rLLbit == 1)
                begin
                    memWr = `RamWrite;
                    memCe = `RamEnable;
                    memAddr = memAddr_i;
                    WData = memData;

                    regData = 32'b1;        //if write success ,write 1 to rt
                    regAddr = regcAddr;
                    regWr = `Valid;
                    wLLbit = 0;
                    wbit = `Valid;
                end
            else
                begin
                    memWr = `RamUnWrite;
                    memCe = `RamDisable;
                    memAddr = `Zero;
                    WData = `Zero;

                    regData = `Zero;       //if write fail, write 0 to rt
                    regAddr = regcWr;
                    regWr = `Valid;
                    wbit = `Invalid;
                end

        `Eret:
            begin
                wbit = `Valid;
                wLLbit = 0;
            end

        `Eret:
            begin
                wbit = `Valid;
                wLLbit = 0;
            end

        `Syscall:
            begin
                wbit = `Valid;
                wLLbit = 0;
            end
        default:
            begin
                regAddr = regcAddr;
                regWr = regcWr;
                regData = regcData;
                wbit = `Invalid;
            end
    endcase
    

endmodule
