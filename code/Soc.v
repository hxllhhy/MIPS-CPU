`include"define.v"
module Soc(
    input wire rst,
    input wire clk,
    output wire [15:0]led,
    input wire [1:0]sel
);
    wire romCe;
    wire [31:0]addr;
    wire [31:0]data;

    wire ramCe;
    wire ramWe;
    wire [31:0]ramWtData;
    wire [31:0]ramAddr;
    wire [31:0]ramRdData;

    wire ioCe;
    wire ioWe;
    wire [31:0]ioWtData;
    wire [31:0]ioAddr;
    wire [31:0]ioRdData;
    
    MIPS mips(.rst(rst), 
              .clk(clk), 
              .romCe(romCe), 
              .addr(addr), 
              .inst(data),

              .ramCe_MIOC(ramCe),
              .ramWe_MIOC(ramWe),
              .ramWtData_MIOC(ramWtData),
              .ramAddr_MIOC(ramAddr),
              .ramRdData(ramRdData),

              .ioCe_MIOC(ioCe),
              .ioWe_MIOC(ioWe),
              .ioWtData_MIOC(ioWtData),
              .ioAddr_MIOC(ioAddr),
              .ioRdData(ioRdData)
    );
    
    InstMem instmem(.ce(romCe),
                    .addr(addr),
                    .data(data));

    IO Io(.ce(ioCe),
          .we(ioWe),
          .wtData(ioWtData),
          .addr(ioAddr),
          .rdData(ioRdData),
          .clk(clk),
          .Seg(),
          .Led(led),
          .Sel(sel),
          .Button()         
    );

    DataMem datamem(
            .ce(ramCe),
            .we(ramWe),
            .dataIn(ramWtData),
            .addr(ramAddr),
            .dataOut(ramRdData),
            .clk(clk)
    );

endmodule
