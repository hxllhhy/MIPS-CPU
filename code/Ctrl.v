`include"define.v"
module Ctrl(
    input wire [31:0]excptype,
    input wire [31:0]epc,
    output reg [31:0]ejpc,
    output reg excpt
    );

    always@(*)
        begin
            case(excptype)
                `CountInt:     //0000_0001
                    begin
                        excpt = `Valid;
                        ejpc = `CountIPC;
                    end
                `SysInt:       //0000_0010
                    begin
                        excpt = `Valid;
                        ejpc = `SysIPC;
                    end
                `ERET:         //0000_0100
                    begin
                        ejpc = epc;
                        excpt = `Valid;
                    end
                default:
                    begin
                        excpt = `Invalid;
                        
                    end
            endcase
        end
endmodule
