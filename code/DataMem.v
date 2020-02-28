`include"define.v"
module DataMem(
    input clk,
    input wire ce,
    input wire we,
    input wire [31:0]dataIn,
    input [31:0]addr,
    output reg [31:0]dataOut
);
    reg [31:0]mem[1023:0];

    initial
        begin
            mem[1] = 32'h0000_ffff;
            mem[2] = 32'hffff_0000;
        end
 
    /*always@(*)
        begin
            if(ce == `Invalid)
                dataOut = `Zero;
            else if(we == `RamUnWrite)
                dataOut = mem[addr[11:2]];
            else
                mem[addr[11:2]] = dataIn; 
        end
   */
    always@(*)      
        if(ce == `RamDisable)
          dataOut = `Zero;
        else
          dataOut = mem[addr[11 : 2]]; 
    always@(posedge clk)
        if(ce == `RamEnable && we == `RamWrite)
            mem[addr[11 : 2]] = dataIn;
        else ;

endmodule
