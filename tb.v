`timescale 1ns/100ps

`include "avr_core.v"
`include "avr_io_out.v"
`include "avr_io_uart.v"
`include "avr_io_timer.v"
//`include "main.v"
`include "flash.v"
`include "ram.v"
//`include "avr_io_spi.v"

module tb();
reg reset_n=0;
reg clk=0;

initial begin
    forever #10 clk = ~clk;
end

initial begin
    reset_n = 0;
    #10;
    reset_n = 1;
    #600000 $finish;
end

initial begin
    $dumpfile ("dump.vcd");
    $dumpvars();
end


top
    dut
    (
        .hwclk(clk),
        .rst(~reset_n),
        .led(),
        .ftdi_rx(),
        .ftdi_tx(),
        .pin_scl0(),
        .pin_sda0()
    );

endmodule

