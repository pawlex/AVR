/*
Copyright (c) 2014 Alex Forencich
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

// Language: Verilog 2001
// .prescale(125000000/(9600*8))
`timescale 1ns / 1ns

/*
 * AXI4-Stream UART
 */
module uart #
       (
           parameter DATA_WIDTH = 8
       )
       (
           input wire clk,
           input wire rst,

           /*
            * AXI input
            */
           input wire [DATA_WIDTH - 1: 0] input_axis_tdata,
           input wire input_axis_tvalid,
           output wire input_axis_tready,

           /*
            * AXI output
            */
           output wire [DATA_WIDTH - 1: 0] output_axis_tdata,
           output wire output_axis_tvalid,
           input wire output_axis_tready,
           /*
            * UART interface
            */
           input wire rxd,
           output wire txd,

           /*
            * Status
            */
           output wire tx_busy,
           output wire rx_busy,
           output wire rx_overrun_error,
           output wire rx_frame_error,

           /*
            * Configuration
            */
           input wire [15: 0] prescale

       );


`ifdef SIMULATION
wire tx_ready, tx_valid, rx_ready, rx_valid;
assign tx_valid = input_axis_tvalid;
assign tx_ready = input_axis_tready;
assign rx_valid = output_axis_tvalid;
assign rx_ready = output_axis_tready;
`endif


uart_tx #(
            .DATA_WIDTH(DATA_WIDTH)
        )
        uart_tx_inst (
            .clk(clk),
            .rst(rst),
            // axi input
            .input_axis_tdata(input_axis_tdata),
            .input_axis_tvalid(input_axis_tvalid),
            .input_axis_tready(input_axis_tready),
            // output
            .txd(txd),
            // status
            .busy(tx_busy),
            // configuration
            .prescale(prescale)
        );

uart_rx #(
            .DATA_WIDTH(DATA_WIDTH)
        )
        uart_rx_inst (
            .clk(clk),
            .rst(rst),
            // axi output
            .output_axis_tdata(output_axis_tdata),
            .output_axis_tvalid(output_axis_tvalid),
            .output_axis_tready(output_axis_tready),
            // input
            .rxd(rxd),
            // status
            .busy(rx_busy),
            .overrun_error(rx_overrun_error),
            .frame_error(rx_frame_error),
            // configuration
            .prescale(prescale)
        );

endmodule
