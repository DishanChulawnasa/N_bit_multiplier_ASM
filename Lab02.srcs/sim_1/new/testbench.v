`timescale 1ns / 1ps

module testbench();
    wire [5:0] Product;
    reg [2:0] Multiplicand, Multiplier;
    reg Start, Clock, Reset;
    
   binary_multiplier M1(Product,Multiplicand,Multiplier,Start,Clock,Reset);
    
    //Stimulus Waveforms
    initial #75 $finish;        
     
    initial begin
        Clock = 0;
        repeat(15)#5 Clock = ~Clock;
    end
    
    initial begin
        Start = 0;
        Reset = 0;
        #2 Start = 1; Reset = 1;
        Multiplicand = 3'b111;
        Multiplier = 3'b111;
        #10 Start = 0;
    end
       
    always @ (posedge Clock)
        $monitor("C=%b, A=%b, Q=%b, P=%b", M1.C, M1.A, M1.Q, M1.P);       
    
endmodule
