`include"define.v"
module MIPS(
    input wire clk,
    input wire rst,
    input wire [31:0]inst,
    output wire [31:0]addr,   //why use wire but reg,because it's need to be parameter
    output wire romCe,

    output wire ramCe_MIOC,
    output wire ramWe_MIOC,
    output wire [31:0]ramWtData_MIOC,
    output wire [31:0]ramAddr_MIOC,
    input wire [31:0]ramRdData,

    output wire ioCe_MIOC,
    output wire ioWe_MIOC,
    output wire [31:0]ioWtData_MIOC,
    output wire [31:0]ioAddr_MIOC,
    input wire [31:0]ioRdData 
    );
    wire[31:0]imm_o;
    wire[31:0]regaData_ID, regbData_ID, pc_ID;
    wire[31:0]regcData_EX, memAddr, memData;
    wire[31:0]regaData_RegFile, regbData_RegFile;

    wire[4:0]regaAddr_ID, regbAddr_ID, regcAddr_ID;
    wire[4:0]regaAddr_EX, regbAddr_EX, regcAddr_EX;
    wire[4:0]cp0rAddr_EX, cp0wAddr_EX;
    wire[31:0]cp0wData_EX, pc_EX, epc_EX, excptype_EX;
    wire cp0we_EX;
    
    wire regcWr_ID, regaRd, regbRd;
    wire regcWr_EX;
    wire[5:0] op, op_EX; 

    wire[31:0] jAddr_ID;
    wire jCe;

    wire[31:0] regData_MEM, memAddr_MEM, WData_MEM;
    wire[4:0] regAddr_MEM;
    wire wLLbit_MEM, wbit_MEM;
    wire regWr_MEM, memWr, memCe;

    //wire [31:0]dataOut_DataMem;

    wire whi_EX, who_EX;
    wire [31:0]hiData_EX, loData_EX;
    wire [31:0]rhi_HiLo, rlo_HiLo; 

    //wire ramCe_MIOC;
    //wire ramWe_MIOC;
    //wire [31:0]ramWtData_MIOC;
    //wire [31:0]ramAddr_MIOC;
    //wire ioCe_MIOC;
    //wire ioWe_MIOC;
    //wire [31:0]ioWtData_MIOC;
    //wire [31:0]ioAddr_MIOC;
    wire [31:0]rdData_MIOC;

    //wire [31:0]rdData_IO;

    wire rLLbit_LLbit;

    wire [31:0]cp0rData_CP0;
    wire [5:0]intimer_CP0;

    wire [31:0]ejpc_Ctrl;
    wire excpt_Ctrl;

    IF iff(.clk(clk),
           .rst(rst), 
           .pc(addr), 
           .romCe(romCe), 
           .jCe(jCe), 
           .jAddr(jAddr_ID),
           .ejpc(ejpc_Ctrl),
           .excpt(excpt_Ctrl)
    );
    
    ID id(.pc(addr),    //waiting..
          .inst(inst),
          .regaData_i(regaData_RegFile),
          .regbData_i(regbData_RegFile),
          .op(op),
          .regaData(regaData_ID),
          .regbData(regbData_ID),
          .regcWr(regcWr_ID),
          .regcAddr(regcAddr_ID),
          .regaRd(regaRd),
          .regaAddr(regaAddr_ID),
          .regbRd(regbRd),
          .regbAddr(regbAddr_ID),
          .rst(rst),
          .jCe(jCe),
          .imm_o(imm_o),
          .jAddr(jAddr_ID),
          .pc_o(pc_ID)
    );

    EX ex(
       //.type(op),
       .op(op),
       .imm(imm_o),
       .regaData(regaData_ID),
       .regbData(regbData_ID),
       .regcWr_i(regcWr_ID),
       .regcAddr_i(regcAddr_ID),
       .regcAddr(regcAddr_EX),
       .regcData(regcData_EX),
       .regcWr(regcWr_EX),
       .rst(rst),
       .op_o(op_EX),
       .memAddr(memAddr),
       .memData(memData),
       .whi(whi_EX),
       .hiData(hiData_EX),
       .wlo(wlo_EX),
       .loData(loData_EX),
       .rhi(rhi_HiLo),
       .rlo(rlo_HiLo),
       .pc(pc_ID),
       .cp0rAddr(cp0rAddr_EX),
       .cp0wData(cp0wData_EX),
       .cp0wAddr(cp0wAddr_EX),
       .cp0we(cp0we_EX),
       .pc_o(pc_EX),
       .excptype(excptype_EX),
       .epc(epc_EX),
       .cp0rData(cp0rData_CP0)
    );

    RegFile regfile(.regaAddr(regaAddr_ID),
                .regbAddr(regbAddr_ID),
                .regaRd(regaRd),
                .regbRd(regbRd),
                .we(regWr_MEM),
                .wAddr(regAddr_MEM),
                .wData(regData_MEM),
                .regaData(regaData_RegFile),
                .regbData(regbData_RegFile),
                .clk(clk),
                .rst(rst)
    );
    Mem mem(.op(op_EX),
            .regcData(regcData_EX),
            .regcAddr(regcAddr_EX),
            .regcWr(regcWr_EX),
            .memAddr_i(memAddr),
            .memData(memData),
            .regData(regData_MEM),
            .regAddr(regAddr_MEM),
            .regWr(regWr_MEM),
            .RData(rdData_MIOC),
            .memAddr(memAddr_MEM),
            .WData(WData_MEM),
            .memWr(memWr_MEM),
            .memCe(memCe_MEM),
            .wLLbit(wLLbit_MEM),
            .wbit(wbit_MEM),
            .rLLbit(rLLbit_LLbit),
            .rst(rst)
     );

    HiLo hilo(.rst(rst),
              .clk(clk),
              .loData(loData_EX),
              .wlo(wlo_EX),
              .hiData(hiData_EX),
              .whi(whi_EX),
              .rlo(rlo_HiLo),
              .rhi(rhi_HiLo)
    );

    MIOC Mioc(.memCe(memCe_MEM),
              .wtData(WData_MEM),
              .memWr(memWr_MEM),
              .memAddr(memAddr_MEM),
              .ramRdData(ramRdData),
              .ioRdData(ioRdData),
              .rdData(rdData_MIOC),
              .ramCe(ramCe_MIOC),
              .ramWe(ramWe_MIOC),
              .ramWtData(ramWtData_MIOC),
              .ramAddr(ramAddr_MIOC),
              .ioCe(ioCe_MIOC),
              .ioWe(ioWe_MIOC),
              .ioWtData(ioWtData_MIOC),
              .ioAddr(ioAddr_MIOC)
    );


    LLbit llbit(.wLLbit(wLLbit_MEM),
                .wbit(wbit_MEM),
                .excpt(excpt_Ctrl),
                .rst(rst),
                .clk(clk),
                .rLLbit(rLLbit_LLbit)
    );

    CP0 Cp0(.int(intimer_CP0),
            .cp0we(cp0we_EX),
            .cp0wAddr(cp0wAddr_EX),
            .cp0wData(cp0wData_EX),
            .cp0rAddr(cp0rAddr_EX),
            .cp0rData(cp0rData_CP0),
            .intimer(intimer_CP0),
            .excptype(excptype_EX),
            .epc(pc_EX),
            .clk(clk),
            .rst(rst)
    );

    Ctrl ctrl(.excptype(excptype_EX),
              .epc(epc_EX),
              .ejpc(ejpc_Ctrl),
              .excpt(excpt_Ctrl)
    );

/*    IO Io(.ce(ioCe_MIOC),
          .we(ioWe_MIOC),
          .wtData(ioWtData_MIOC),
          .addr(ioAddr_MIOC),
          .rdData(rdData_IO),
          .clk(clk)
    );

    DataMem datamem(.clk(clk),
            .ce(ramCe_MIOC),
            .we(ramWe_MIOC),
            .dataIn(ramWtData_MIOC),
            .addr(ramAddr_MIOC),
            .dataOut(dataOut_DataMem)
    );
*/
endmodule
