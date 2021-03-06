`include"define.v"
module InstMem(
    input wire ce,
    input wire [31:0]addr,
    output reg [31:0]data
    );
    reg [31:0]instRom[1023:0];
    //reg [11:0]index;
 
    always@(*)
        if(ce == `RomDisable)
            data = `Zero;
        else
            begin
                //index = addr[13:2] - 12'b01_0000_0010_10;
                //data = instRom[index];
                data = instRom[addr[11:2]];
            end
/*    initial
        begin
            //ori
            //cant write to r0

            //ram[00011] = ram[00001] | 0x0001
            //32'b001101_00001_00011_0000_0000_0000_0001
            instRom[0] = 32'h34230001;//ori r1 r3 0001   
            
            //ram[00101] = ram[00001] | 0x1100
            //32'b001101_00001_00101_0001_0001_0000_0000
            instRom[1] = 32'h34231100;//ori r1 r5 1100   
            
            instRom[2] = 32'h34011100;//ori r0 r1 1100
            instRom[3] = 32'h34020020;//ori r0 r2 0020
            instRom[4] = 32'h3403ff00;//ori r0 r3 ff00
            instRom[5] = 32'h3404ffff;//ori r0 r4 ff00
            
            //and
            //ram[5] = ram[3] & ram[4]
            instRom[6] = 32'h00682824;//and r3 r4 r5
            
            //ram[6] = ram[2] 
            //instRom[7] = 32'h;
            
            //100_011_00000_01010_0000_0000_0000_0100  
            instRom[8] = 32'h8C0A0004;//lw r0 r10 0004

            //100_011_00000_01001_0000_0000_0000_1000
            instRom[10] = 32'h8C090008;//lw r0 r19 0008

            //101011_00000_01010_0000_0000_0000_1100
            instRom[11] = 32'hAC0A000C;//sw r0 r10 0009

            //101011_00000_01001_0000_0000_0001_0000
            instRom[12] = 32'hAC090010;//sw r0 r9 0010

            //J
            instRom[13] = 32'h08000000;//j 0
        end
*/

/*    initial
        begin                         //    rs rt rd              //initial
            instRom[1] = 32'h00223020;//add r1 r2 r6;     //r0 0000_0000
            instRom[2] = 32'h00413822;//sub r2 r1 r7;     //r1 0000_00f0
            instRom[3] = 32'h00434024;//and r2 r3 r8;     //r2 0000_0f00 
            instRom[4] = 32'h00434825;//or  r2 r3 r9;     //r3 0000_0ff0 
            instRom[5] = 32'h00435026;//xor r2 r3 r10;    //r4 ff00_00ff
                                                          //r5 ff00_00ff
                                      //    rt rd   sa    //r19 0000_0060
            instRom[6] = 32'h00045A00;//sll r4 r11  8;  //r20 0000_0008  //logical left moving
            instRom[7] = 32'h00046202;//srl r4 r12  8;                   //logical right moving
            instRom[8] = 32'h00056A03;//sra r4 r13  8;                   //calculating right moving
            //instRom[9] = jr

                                       //     rs rt  imm
            instRom[10] = 32'h200E800F;//addi r0 r14 800f
            instRom[11] = 32'h308F000F;//andi r4 r15 000f
            instRom[12] = 32'h3490000F;//ori  r4 r16 000f
            instRom[13] = 32'h3891000F;//xori r4 r17 000f
        
            instRom[14] = 32'h8C120004;//lw   r0 r18 0004
            instRom[15] = 32'hAC12000C;//sw   r0 r18 000C
            instRom[16] = 32'h10010001;//beq  r0 r1  0001
            instRom[17] = 32'h10850001;//beq  r4 r5  0001
            instRom[19] = 32'h14850001;//bne  r4 r5  0001 
            instRom[20] = 32'h14010001;//bne  r0 r1  0001

            instRom[22] = 32'h02600008;//jr r19      //jump to instRom[24]

                                             //addr
            instRom[24] = 32'h0800001A;//j   1A      //jump to instRom[26]
            instRom[26] = 32'h3C15FFFF;//lui r21 ffff 
            instRom[27] = 32'h0C000000;//jal 0       //save pc to r31 and jump to 0
        end
*/

/*    initial
        begin
            instRom[1] = 32'h00220019;//multu r1,r2      //r0 32'h0000_0000      
            instRom[2] = 32'h00230018;//mult  r1,r3      //r1 32'h0000_0008  
            instRom[3] = 32'h00210019;//multu r1,r1      //r2 32'h0000_0100
            instRom[4] = 32'h0024001B;//divu r1,r4       //r3 32'hFFFF_FFFF //-1
            instRom[5] = 32'h0025001A;//div r1,r5        //r4 32'h0000_0003 
            instRom[6] = 32'h00005010;//mfhi r10         //r5 32'hFFFF_FFFD //-3
            instRom[7] = 32'h00005812;//mflo r11         //r6 32'h0000_0048
            instRom[8] = 32'h00200011;//mthi r1
            instRom[9] = 32'h00400013;//mtlo r2
            instRom[10] = 32'h1C600001;//bgtz r3 0001   
            instRom[11] = 32'h1C200001;//bgtz r1 0001    r1>0 then jump more 1 inst
            instRom[13] = 32'h04200001;//bltz r1 0001
            instRom[14] = 32'h04600001;//bltz r3 0001    r3<0 then jump more 1 inst
            instRom[16] = 32'h00C0F809;//jalr r6,r31     pc <- r6    r31 <- pc + 4  //jump to inst18
            instRom[18] = 32'h0001602A;//slt r12,r0,r1
            instRom[19] = 32'h0020602A;//slt r12,r1,r0   
            instRom[20] = 32'h0061602A;//slt r12,r3,r1
            instRom[21] = 32'h0065602A;//slt r12,r3,r5
        end
*/

    initial
        begin
            //instRom[1] = 32'hAC120004;//sw   r0 r18 0004 //user
            //instRom[2] = 32'h8C130004;//lw   r0 r19 0004 //user
            //instRom[3] = 32'hAC111000;//sw   r0 r17 1000 //io 
            //instRom[4] = 32'h8C141000;//lw   r0 r20 1000 //io

            instRom[1] = 32'hC0130004;//ll   r0 r19 0004 //user
            instRom[2] = 32'hE0110004;//sc   r0 r17 0004 //user
            //instRom[1] = 32'hC0131004;//ll   r0 r19 0004 //user
            //instRom[2] = 32'hE0111004;//sc   r0 r17 0004 //user
            instRom[3] = 32'h40815800;//mtc  r1 `Compare


            instRom[4] = 32'h0024001B;//divu r1,r4       //r3 32'hFFFF_FFFF //-1
            instRom[5] = 32'h0025001A;//div r1,r5        //r4 32'h0000_0003 
            instRom[6] = 32'h00005010;//mfhi r10         //r5 32'hFFFF_FFFD //-3
            instRom[7] = 32'h00005812;//mflo r11         //r6 32'h0000_0048
            instRom[8] = 32'h00200011;//mthi r1
            instRom[9] = 32'h00400013;//mtlo r2
            instRom[10] = 32'h1C600001;//bgtz r3 0001   
            instRom[11] = 32'h1C200001;//bgtz r1 0001    r1>0 then jump more 1 inst
             
            instRom[13] = 32'h0000000C;//syscall //Sysint to 0000_0E18 

            instRom[10'h381] = 32'h40805800;//mtc r0 `Compare  //0000_0E04
            instRom[10'h385] = 32'h42000018;//ERET             //0000_0E14
            instRom[10'h388] = 32'h42000018;//ERET//           //0000_0E20
        end

/*    initial begin
        instRom[0] = 32'h34211000;//ori r1,r1,1000
        instRom[1] = 32'h3442100C;//ori r2,r2,100C
        instRom[2] = 32'h8C230000;//lw  r3,0(r1)
        instRom[3] = 32'hAC430000;//sw  r3,0(r2)
        instRom[4] = 32'h00000008;//jr 0
    end*/
endmodule
