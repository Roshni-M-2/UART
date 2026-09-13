`timescale 1ns / 1ps

module receiver(

input clk, 
input reset, 
input RxD,
output [7:0]RxData 
 );
    
//internal variables
reg shift; 
reg state, nextstate; 
reg [3:0] bitcounter; // 4 bits counter to count up to 9 for UART receiving
reg [1:0] samplecounter; // 2 bits sample counter to count up to 4 for oversampling
reg [13:0] counter; // 14 bits counter to count the baud rate
reg [9:0] rxshiftreg; 
reg clear_bitcounter,inc_bitcounter,inc_samplecounter,clear_samplecounter; 

// constants
parameter clk_freq = 100_000_000;  // system clock frequency
parameter baud_rate = 9_600; //baud rate
parameter div_sample = 4; //oversampling
parameter div_counter = clk_freq/(baud_rate*div_sample);  // this is the number we have to divide the system clock frequency to get a frequency (div_sample) time higher than (baud_rate)
parameter mid_sample = (div_sample/2);  // this is the middle point of a bit where we want to sample it
parameter div_bit = 10; // 1 start, 8 data, 1 stop


assign RxData = rxshiftreg [8:1]; 

//UART receiver logic
always @ (posedge clk)
    begin 
        if (reset)begin 
            state <=0; 
            bitcounter <=0; 
            counter <=0; 
            samplecounter <=0; 
        end else begin 
            counter <= counter +1; 
            if (counter >= div_counter-1) begin 
                counter <=0; 
                state <= nextstate; 
                if (shift)rxshiftreg <= {RxD,rxshiftreg[9:1]}; 
                if (clear_samplecounter) samplecounter <=0; 
                if (inc_samplecounter) samplecounter <= samplecounter +1;
                if (clear_bitcounter) bitcounter <=0; 
                if (inc_bitcounter)bitcounter <= bitcounter +1; 
            end
        end
    end
   
//state machine

always @ (posedge clk) 
begin 
    shift <= 0; 
    clear_samplecounter <=0; 
    inc_samplecounter <=0; 
    clear_bitcounter <=0; 
    inc_bitcounter <=0; 
    nextstate <=0; 
    case (state)
        0: begin // idle state
            if (RxD) 
              begin
              nextstate <=0;     
              end
            else begin 
                nextstate <=1; 
                clear_bitcounter <=1; 
                clear_samplecounter <=1; 
            end
        end
        1: begin //receiving state
            nextstate <= 1; 
            if (samplecounter== mid_sample - 1) shift <= 1; 
                if (samplecounter== div_sample - 1) begin
                    if (bitcounter == div_bit - 1) begin 
                nextstate <= 0; 
                end 
                inc_bitcounter <=1; 
                clear_samplecounter <=1; 
            end else inc_samplecounter <=1; 
        end
       default: nextstate <=0;
     endcase
end         
endmodule