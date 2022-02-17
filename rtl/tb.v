`timescale 1ns/100ps

module tb();
reg reset_n = 0;
reg clk = 0;

initial
begin
    forever
        #10 clk = ~clk;
end

initial
begin
    reset_n = 0;
    #10;
    reset_n = 1;
    #60000 $finish;
end

initial
begin
    $dumpfile ("dump.vcd");
    $dumpvars();
end


top
    dut
    (
        .hwclk(clk),
        .rst(~reset_n),
        .uart_prescale(),
        .uart_tx_data_i(),
        .uart_rx_data_o(),
        .uart_rx_ready_i(),
        .uart_tx_valid_i(),
        .uart_rx_valid_o(),
        .uart_tx_ready_o()
    );

endmodule

