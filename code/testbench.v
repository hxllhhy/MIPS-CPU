`include"define.v"
module tb();
    reg rst;
    reg clk;
    Soc soc(.rst(rst), .clk(clk));
    
    always #10 clk = ~clk;
    
    initial
        begin
            clk = `Zero;
            rst = `RstEnable;
            #100 rst = `RstDisable;
        end
endmodule 