`include"define.v"
module EX(
    input wire rst,
    input wire [5:0]op,
    //input wire [5:0]type,
    input wire [31:0]regaData,
    input wire [31:0]regbData,
    input wire regcWr_i,
    input wire [4:0]regcAddr_i,
    input wire [31:0]imm,
    output reg [31:0]regcData,
    output reg [4:0]regcAddr,
    output reg regcWr,
    output reg [31:0]memAddr,
    output reg [31:0]memData,
    output reg [5:0]op_o,

    input wire [31:0]rhi,
    input wire [31:0]rlo,
    output reg whi,
    output reg [31:0]hiData,
    output reg wlo,
    output reg [31:0]loData,

    input wire [31:0]pc,
    input wire [31:0]cp0rData,
    output reg [4:0]cp0rAddr,
    output reg [31:0]cp0wData,
    output reg [4:0]cp0wAddr,
    output reg cp0we,
    output reg [31:0]pc_o,
    output reg [31:0]excptype,
    output reg [31:0]epc
    );

    always@(*)
    begin

        if(rst == `RstEnable)
                begin
                    op_o = `Nop;
                    regcAddr = `Zero;
                    regcWr = `RamUnWrite;
                    op_o = op;
                end
            
        
        excptype = `Zero;
        cp0rAddr = `Status;
        cp0we = `RamUnWrite;
        if(rst == `RstEnable)
            begin
                regcData = `Zero;
                excptype = `Zero;
            end
        else if(cp0rData[10] == 1 && op != `Mtc0)
            begin
                op_o = `Nop;
                excptype = `CountInt;
                //pc_o = pc;
            end
        else
        begin
            /*if(excptype != `CountInt && excptype != `SysInt)
                excptype = `Zero;*/
         
                pc_o = pc;
            case(op)
                `Or:
                    regcData = regaData | regbData;

                `And:
                    regcData = regaData & regbData; 

                `Add:
                    regcData = regaData + regbData;
                
                `Sub:
                    regcData = regaData - regbData;

                `Multu:
                    begin
                        whi = `Valid;
                        wlo = `Valid;
                        {hiData, loData} = regaData * regbData;
                    end

                `Mult:
                    begin
                        whi = `Valid;
                        wlo = `Valid;
                        {hiData, loData} = $signed(regaData) * $signed(regbData);
                    end
    
                `Divu:
                    begin
                        whi = `Valid;
                        wlo = `Valid;
                        loData = regaData / regbData;
                        hiData = regaData % regbData;
                    end

                `Div:
                    begin
                        whi = `Valid;
                        wlo = `Valid;
                        loData = $signed(regaData) / $signed(regbData);
                        hiData = $signed(regaData) % $signed(regbData);
                    end

                `Xor:
                    regcData = regaData ^ regbData;

                `Sll:
                    regcData = regaData << regbData;
                    //regcData = {regaData[31-regbData:0],regbData{0}};
    
                `Srl:
                    regcData = regaData >> regbData;

                `Sra:
                    regcData = ($signed(regaData)) >>> regbData;

                `Beq:
                    regcData = `Zero;

                `Bne:
                    regcData = `Zero;

                `Bltz:
                    regcData = `Zero;

                `Bgtz:
                    regcData = `Zero;

                `J:
                    regcData = `Zero;

                `Jr:
                    regcData = `Zero;
          
                `Jal:
                    regcData = imm;

                `Jalr:
                    regcData = imm;

                `Slt:
                    if($signed(regaData) < $signed(regbData))
                        regcData = 32'b0000_0001;
                    else
                        regcData = `Zero;

                `Mfhi:
                    regcData = rhi;

                `Mflo:
                    regcData = rlo;

                `Mthi:
                    begin
                        whi = `Valid;
                        hiData = regaData;
                    end
                `Mtlo:
                    begin
                        wlo = `Valid;
                        loData = regaData;
                    end                
                `Lui:
                    regcData = regaData;

                `Lw:
                    begin
                        memAddr = regaData + regbData;
                        regcData = `Zero;
                    end

                `Sw:      
                    begin
                        memAddr = regaData + imm;
                        memData = regbData;
                        regcData = `Zero;
                    end 
 
                `Ll:
                    begin
                        memAddr = regaData + regbData;
                        regcData = `Zero;
                    end

                `Sc:      
                    begin
                        memAddr = regaData + imm;
                        memData = regbData;
                        regcData = `Zero;
                    end

                `Mfc0:
                    begin
                        cp0rAddr = imm;
                        cp0we = `RamUnWrite;
                        regcData = cp0rData;
                    end

                `Mtc0:
                    begin
                        cp0wAddr = imm;
                        cp0wData = regaData;
                        cp0we = `RamWrite;
                        excptype = `Zero;
                    end

                `Eret:
                    begin
                        cp0rAddr = `EPC;
                        cp0we = `RamUnWrite;
                        epc = cp0rData;
                        excptype = `ERET;
                    end

                `Syscall:
                    begin
                        pc_o = pc + 4;
                        //cp0we = `RamUnWrite;
                        //cp0rAddr = `EPC;
                        //epc = cp0rData;
                        excptype = `SysInt;
                    end
                default:
                    regcData = `Zero;   
            endcase
        end
        if(rst == `RstEnable)
            begin
                regcAddr = `Zero;
                regcWr = `RamUnWrite;
            end
        else
            begin
                regcAddr = regcAddr_i;
                regcWr = regcWr_i;
            end
        if(op != `Lw && op != `Sw && op != `Ll && op != `Sc)
                    begin
                        op_o = op;
                        regcAddr = regcAddr_i;
                        regcWr = regcWr_i;
                        
                    end
                    op_o = op;
    end
    /*always@(*)
        case(type)
            `logic:
                regcData = logicout;
            default:
                regcData = `Zero;
        endcase
    */


endmodule
