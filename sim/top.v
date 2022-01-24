`timescale 1ns/1ns

module top
       (
           input	hwclk,
           input   rst,
           output  [7:0] led,
           //input	avr_rx,
           //output	avr_tx,
           //input   tb_rx,
           //output  tb_tx
           //
           input [15:0] uart_prescale,
           input [7:0] uart_tx_data_i,
           output [7:0] uart_rx_data_o,
           input uart_rx_ready_i,
           input uart_tx_valid_i,
           output uart_rx_valid_o,
           output uart_tx_ready_o
       );

wire pin_scl0;
wire pin_sda0;

wire		clk;
assign clk = hwclk;

parameter	pmem_width = 10;
parameter	dmem_width = 9;

wire			pmem_ce;
wire [pmem_width-1:0]	pmem_a;
wire [15:0]		pmem_d;

wire			dmem_re;
wire			dmem_we;
wire [dmem_width-1:0] 	dmem_a;
wire [7:0]		dmem_di;
wire [7:0]		dmem_do;
//input rst,

wire			io_re;
wire			io_we;
wire [5:0]		io_a;
wire [7:0]		io_do;


/*****************************************************************************/

ram	 core0_ram ( clk, dmem_re, dmem_we, dmem_a, dmem_di, dmem_do );
defparam core0_ram.ram_width = dmem_width;

flash	 core0_flash ( clk, pmem_ce,pmem_a, pmem_d );

/*****************************************************************************/

wire [7:0] io_di;

`define TIMER0

`ifdef TIMER0
wire timer0_io_select = (io_a[5:2] == 4'b0010);
wire timer0_io_re = timer0_io_select & io_re;
wire timer0_io_we = timer0_io_select & io_we;
wire timer0_irq;

avr_io_timer timer0
             (      clk, 1'b0,
                    timer0_io_re, timer0_io_we, io_a[1:0], io_di, io_do,
                    timer0_irq
             );
`else
wire timer0_irq = 0;
`endif

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

`define PORT0

`ifdef PORT0
wire port0_io_select = (io_a[5:0] == 6'b000100);
wire port0_io_re = (port0_io_select ? io_re : 1'b0);
wire port0_io_we = (port0_io_select ? io_we : 1'b0);
wire [7:0] port0_out;

avr_io_out port0
           (      clk, 1'b0,
                  port0_io_re, port0_io_we, io_di, io_do,
                  port0_out
           );

assign led = port0_out;
`else
assign led = 8'b00000000;
`endif

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

`define UART0

`ifdef UART0
wire uart0_io_select = (io_a[5:2] == 4'b0000);
wire uart0_io_re = (uart0_io_select ? io_re : 1'b0);
wire uart0_io_we = (uart0_io_select ? io_we : 1'b0);
wire uart0_txd;
wire uart0_rxd;
wire [2:0] uart0_irq;

//assign avr_tx = uart0_txd;
//assign uart0_rxd = avr_rx;

avr_io_uart uart0
            (	clk, 1'b0,
              uart0_io_re, uart0_io_we, io_a[1:0], io_di, io_do,
              uart0_txd, uart0_rxd,
              uart0_irq
            );
`else
assign avr_tx = avr_rx;
wire [2:0] uart0_irq;
assign uart0_irq = 3'b000;
`endif

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

// `define SPI0

`ifdef SPI0
wire spi0_io_select = (io_a[5:2] == 4'b0100);
wire spi0_io_re = (spi0_io_select ? io_re : 1'b0);
wire spi0_io_we = (spi0_io_select ? io_we : 1'b0);
wire spi0_enable;
wire spi0_master;
wire spi0_master_out;
wire spi0_master_in;
wire spi0_master_clk;
wire spi0_master_select;
wire spi0_slave_out;

`define ASYNC_SPI_SAMPLING

`ifdef ASYNC_SPI_SAMPLING
assign mosi = spi0_master_out;
assign spi0_master_in = miso;
assign sck = spi0_master_clk;
assign nss = ~spi0_master_select;
`else
reg	mosi, spi0_master_in, sck, nss;
always @(posedge clk) begin
    mosi <= spi0_master_out;
    spi0_master_in <= miso;
    sck <= spi0_master_clk;
    nss <= ~spi0_master_select;
end
`endif

avr_io_spi spi0
           (	clk, 1'b0,
             spi0_io_re, spi0_io_we, io_a[1:0], io_di, io_do,
             spi0_enable, spi0_master,
             spi0_master_clk, spi0_master_out, spi0_master_in, spi0_master_select,
             1'b0, 1'b0, spi0_slave_out, 1'b0
           );
`else

//assign sck = 1'b0;
//assign mosi = 1'b0;
//assign nss = 1'b1;

`endif


/*****************************************************************************/

wire iflag;
wire [1:0] ivect;

priority_encoder irq0 ( { uart0_irq[2], 1'b0, timer0_irq, 1'b0 }, iflag, ivect );

avr_core core0
         (	clk, rst,
           pmem_ce, pmem_a, pmem_d,
           dmem_re, dmem_we, dmem_a, dmem_di, dmem_do,
           io_re, io_we, io_a, io_di, io_do,
           iflag, ivect
         );

defparam core0.pmem_width = pmem_width;
defparam core0.dmem_width = dmem_width;
defparam core0.interrupt  = 1;
defparam core0.intr_width = 2;

// Instantiate the UART again, to give us console access
// to the test bench. :)
wire uart_rx_i, uart_tx_o;
//assign uart_rx_i = uart_tx;
//assign uart_rx = uart_tx_o;
//
//assign avr_tx = uart0_txd;
//assign uart0_rxd = avr_rx;
//
assign uart0_rxd = uart_tx_o;
assign uart_rx_i = uart0_txd;

/* verilator lint_off PINMISSING */
uart tb_uart
     (
         .clk(hwclk),
         .rst(rst),
         .input_axis_tdata(uart_tx_data_i),
         .input_axis_tvalid(uart_tx_valid_i),
         .input_axis_tready(uart_tx_ready_o),

         .output_axis_tdata(uart_rx_data_o),
         .output_axis_tvalid(uart_rx_valid_o),
         .output_axis_tready(uart_rx_ready_i),
         .rxd(uart_rx_i),
         .txd(uart_tx_o),
         .prescale(uart_prescale)
     );
/* verilator lint_on PINMISSING */
endmodule

