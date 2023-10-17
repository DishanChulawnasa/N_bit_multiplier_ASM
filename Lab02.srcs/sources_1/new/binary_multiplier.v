`timescale 1ns / 1ps

module binary_multiplier(
Product,
Multiplicand,
Multiplier,
Start,
Clock,
Reset
);

output [5:0] Product;
input [2:0] Multiplicand,Multiplier; //Inputs to the multiplier
input Start,Clock,Reset;

parameter S_idle = 2'b00,
          S_add = 2'b01,
          S_shift = 2'b10;
reg [2:0] state,next_state;
reg [2:0] A,B,Q;
reg C;
reg [2:0] P;
reg Load_regs,Decr_P,Add_regs,Shift_regs;

assign Product = {C,A,Q};

//Control Unit
always @ (posedge Clock, negedge Reset)
    if (~Reset) state <= S_idle;
    else state <= next_state;

always @(state, Start, Q[0]) begin
    next_state = S_idle;
    Load_regs =0;
    Decr_P = 0;
    Add_regs = 0;
    Shift_regs = 0;
    case (state)
        S_idle: begin
                if (Start) 
                    next_state = S_add;
                    Load_regs = 1;
                end
        S_add: begin
               next_state = S_shift;
               Decr_P = 1;
               if (Q[0]==1) 
                    Add_regs = 1;
               end
        S_shift: begin
                    Shift_regs = 1;
                    if (P==0) 
                        next_state = S_idle;
                    else
                        next_state = S_add;
                    end
        default: next_state = S_idle;
    endcase
end 


//Datapath Unit
always @ (posedge Clock) begin
    if (Load_regs) begin
        P <= 3;
        A <= 0;
        C <= 0;
        
        B <= Multiplicand;
        Q <= Multiplier;
    end
    
    if (Add_regs)
        {C, A} <= A + B;
    if (Shift_regs)
        {C, A, Q} <= {C, A, Q} >> 1; 
    if (Decr_P)
        P <= P-1;
      
end

endmodule
