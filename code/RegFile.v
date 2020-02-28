`include"define.v"
module RegFile(
    input wire rst,
    input wire [4:0]regaAddr,
    input wire [4:0]regbAddr,
    input wire regaRd,
    input wire regbRd,
    input wire we,                       //we can only change regcData
    input wire [4:0]wAddr,                
    input wire [31:0]wData,
    input wire clk,
    output reg [31:0]regaData,
    output reg [31:0]regbData
    );
    reg [31:0]Ram[31:0];               //rom may more appropriate
    always@(posedge clk)
        if(rst == `RstDisable)
            if(we == `Valid && wAddr != `Zero)
                Ram[wAddr] = wData;
            else;

    always@(*)
        if(rst == `RstEnable)
            regaData = `Zero;
        else if(regaAddr == `Zero)       //just to ensure ram[0] is 0 .....wtf?
            regaData = `Zero;
        else
            regaData = Ram[regaAddr];
    
    always@(*)
        if(rst == `RstEnable)
            regbData = `Zero;
        else if(regbAddr == `Zero)
            regbData = `Zero;
        else
            regbData = Ram[regbAddr];
        
    initial
        begin

            /*Ram[0] = 32'h0000_0000;
            Ram[1] = 32'h0000_00f0;
            Ram[2] = 32'h0000_0f00;
            Ram[3] = 32'h0000_0ff0;
            Ram[4] = 32'hff00_00ff;
            Ram[5] = 32'hff00_00ff; 
            Ram[19] = 32'h0000_0060;
            Ram[20] = 32'h0000_0008;*/
            Ram[0] = 32'h0000_0000;
            Ram[1] = 32'h0000_0008;
            Ram[2] = 32'h0000_0100;
            Ram[3] = 32'hFFFF_FFFF;
            Ram[4] = 32'h0000_0003;
            Ram[5] = 32'hFFFF_FFFD;
            Ram[6] = 32'h0000_0048;
            Ram[17] = 32'h0000_0002;
            Ram[18] = 32'h0000_0003;
            Ram[19] = 32'h0000_0060;

            /*Ram[0] = 32'h0000_0000;
            Ram[1] = 32'h0000_0000;
            Ram[2] = 32'h0000_0000;
            Ram[3] = 32'h0000_0000;
            Ram[4] = 32'h0000_0000;
            Ram[5] = 32'h0000_0000;
            Ram[6] = 32'h0000_0000;
            Ram[7] = 32'h0000_0000;
            Ram[8] = 32'h0000_0000;
            Ram[9] = 32'h0000_0000;
            Ram[10] = 32'h0000_0000;
            Ram[11] = 32'h0000_0000;
            Ram[12] = 32'h0000_0000;
            Ram[13] = 32'h0000_0000;
            Ram[14] = 32'h0000_0000;
            Ram[15] = 32'h0000_0000;
            Ram[16] = 32'h0000_0000;
            Ram[17] = 32'h0000_0000;
            Ram[18] = 32'h0000_0000;
            Ram[19] = 32'h0000_0000;
            Ram[20] = 32'h0000_0000;
            Ram[21] = 32'h0000_0000;
            Ram[22] = 32'h0000_0000;
            Ram[23] = 32'h0000_0000;
            Ram[24] = 32'h0000_0000;
            Ram[25] = 32'h0000_0000;
            Ram[26] = 32'h0000_0000;
            Ram[27] = 32'h0000_0000;
            Ram[28] = 32'h0000_0000;
            Ram[29] = 32'h0000_0000;
            Ram[30] = 32'h0000_0000;
            Ram[31] = 32'h0000_0000;*/
            
        end

/*        begin
            if(regaRd == `Valid;
                regaData = Rom[regaAddr];
            else
                regaData = `Zero;
            if(regbRd == `Valid)
                regbData = Rom[regbAddr];
            else
                regbData = `Zero;
        end
*/

endmodule
