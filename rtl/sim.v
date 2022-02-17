`ifdef __ICARUS__
    `define SIMULATION
`endif
`ifdef VERILATOR
    `define SIMULATION
`endif
`ifdef SIMULATION
    `define SIMULATOR
`endif
