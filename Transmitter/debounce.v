`timescale 1ns / 1ps

module debounce#(parameter threshold = 100000)
(
    input clk,
    input btn1,
    output reg transmit
);

    reg ff1 = 0;
    reg ff2 = 0;
    reg [20:0]count = 0;
    always @(posedge clk) begin
        ff1 <= btn1;
        ff2 <= ff1;
    end
    
    always @(posedge clk) begin
        if(ff2) begin
            if(~&count) count <= count+1;
        end
        else begin
            if(|count) count <= count-1;
         end
         if(count>threshold)
            transmit <= 1;
         else
            transmit <= 0;
    end 
endmodule