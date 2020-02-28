`include"define.v"
module MIOC(
    input wire memCe,
    input wire [31:0]wtData,
    input wire memWr,
    input wire [31:0]memAddr,
    input wire [31:0]ramRdData,
    input wire [31:0]ioRdData,
    output reg ramCe,
    output reg ramWe,
    output reg [31:0]ramWtData,
    output reg [31:0]ramAddr,
    output reg ioCe,
    output reg ioWe,
    output reg [31:0]ioWtData,
    output reg [31:0]ioAddr,
    output reg [31:0]rdData
);
    reg [31:0]User_start;
    reg [31:0]User_end;
    reg [31:0]IO_start;
    reg [31:0]IO_end;


    initial
        begin
            User_start = 32'h0000_0000;
            User_end = 32'h0000_0FFF;
            IO_start = 32'h0000_1000;
            IO_end = 32'h0000_1027;
        end
    always@(*)
        if(memAddr >= User_start && memAddr <= User_end)
            begin
                ramCe = memCe;
                ramWe = memWr;
                ramWtData = wtData;
                ramAddr = memAddr;
                rdData = ramRdData;
            end
        else if(memAddr >= IO_start && memAddr <= IO_end)
            begin
                ioCe = memCe;
                ioWe = memWr;
                ioWtData = wtData;
                ioAddr = memAddr;
                rdData = ioRdData;
            end    
endmodule
