`timescale 1ns / 1ps

module top(
    input clk,

    // Transmitter inputs
    input btn1,
    input btn0,
    input [7:0] sw,
    input RxD,

    // Transmitter outputs
    output TxD,
    output TxD_debug,
    output transmit_debug,
    output button_debug,
    output clk_debug
);

    wire transmit;
    
    assign TxD_debug = TxD;
    assign transmit_debug = transmit;
    assign button_debug = btn1;
    assign clk_debug = clk;
  
    debounce D(
        clk,
        btn1,
        transmit
    );
    transmitter T(
        clk,
        btn0,
        sw,
        transmit,
        TxD
    );
    
endmodule