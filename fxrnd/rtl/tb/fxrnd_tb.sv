// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Module     : fxrnd_tb                                             Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: Testbench for fxrnd block.

`include "../rtl/tb/logger.sv"
`include "../rtl/tb/fxrnd_interface.sv"
`include "../rtl/tb/fxrnd_driver.sv"
`include "../rtl/tb/fxrnd_monitor.sv"

module fxrnd_tb();

// Testbench parameters:
localparam unsigned DELAY = 10;

// DUT parameters:
localparam string   OVFLW_MODE = "WRAP";
localparam string   QUANT_MODE = "RND";
localparam unsigned WL_IN      = 'd8;
localparam unsigned WL_OUT     = 'd4;
localparam          IWL_IN     = 'd4;
localparam          IWL_OUT    = 'd2;
localparam unsigned SIGNED     = 1'b1;

// Testbench registers, wires and variables:
logic [WL_IN-1:0]  w_data_in;
logic [WL_OUT-1:0] w_data_out;

// DUT interface instanciation:
fxrnd_interface dut_if();

// DUT instanciation:
fxrnd #(
    .OVFLW_MODE(OVFLW_MODE),
    .QUANT_MODE(QUANT_MODE),
    .WL_IN     (WL_IN     ),
    .WL_OUT    (WL_OUT    ),
    .IWL_IN    (IWL_IN    ),
    .IWL_OUT   (IWL_OUT   ),
    .SIGNED    (SIGNED    )
) uu_fxrnd (
    .i_data(dut_if.i_data),
    .o_data(dut_if.o_data)
);

// Logger instanciation:
Logger logger = new("fxrnd_compare.txt");

// Driver and Monitor instanciation:
fxrnd_driver #(
    .WL_IN(WL_IN),
    .DELAY(DELAY)
    ) driver  = new("fxrnd_input.txt", dut_if, logger);

fxrnd_monitor #(
    .WL_OUT(WL_OUT),
    .DELAY (DELAY )
    ) monitor = new("fxrnd_arch.txt", dut_if, logger);

// Initial block:
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
end

initial begin
    //w_data_in = 0;
    //w_data_out = 0;
    //#10;
    //w_data_in = 1;
    //w_data_out = 1;
    //#10;
    logger.header();
    logger.log("INFO", "Starting simulation");
    driver.init();
    fork
        begin
            driver.test_sanity();
        end begin
            monitor.test_sanity();
        end
    join
    fork
        begin
            driver.read_file();
        end begin
            monitor.read_file();
        end
    join
    logger.result(monitor.errors);
    logger.footer();
    $finish();
end

endmodule
