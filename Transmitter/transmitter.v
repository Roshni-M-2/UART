`timescale 1ns / 1ps

module transmitter(
    input clk,
    input reset,
    input [7:0]data,
    input transmit,
    output reg TxD
 );
 
 reg [20:0]counter;
 reg [3:0]bitcounter;
 reg [9:0]rightshiftreg;
 reg load;
 reg shift;
 reg clr;
 reg state, nextstate;
 
 always @(posedge clk) begin
    if(reset)begin
        state <= 0;
        counter <= 0;
        bitcounter <= 0;  
    end
    
    else begin
        counter <= counter+1;
        if(counter > 10415)begin
               state <= nextstate;
               counter <= 0;
               if(load) rightshiftreg <= {1'b1,data,1'b0};
               if(clr) bitcounter <= 0;
               if(shift) begin
                rightshiftreg <= rightshiftreg >> 1;
                bitcounter <= bitcounter + 1;
               end
         end
        
    end
  end
  
  always@(posedge clk) begin
    load <= 0;
    shift <= 0;
    clr <= 0;
    nextstate <= 0;
    TxD <= 1;
    
    case(state) 
        0: begin
            if(transmit)begin
                nextstate <= 1;
                load <= 1;
                clr <= 0;
                shift <= 0;  
            end
            else begin 
                nextstate <= 0;
                TxD <= 1;
            end
        end
        
        1: begin
            if(bitcounter >= 10) begin
                nextstate <= 0;
                TxD <= 1;
                clr <= 1;
            end
            else begin
                nextstate <= 1;
                TxD <= rightshiftreg[0];
                shift <= 1;
            end
        end
        
        default : begin
            nextstate <= 0;
            TxD <= 1;
        end
    endcase
  end
endmodule
