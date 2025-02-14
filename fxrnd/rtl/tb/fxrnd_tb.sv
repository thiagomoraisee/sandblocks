// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Module     : fxrnd_tb                                             Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: Testbench for fxrnd block.

`include "../rtl/tb/logger.sv"
`include "../rtl/tb/fxrnd_interface.sv"
`include "../rtl/tb/fxrnd_driver.sv"

module fxrnd_tb();

// Testbench parameters:
localparam unsigned DELAY = 10;

// DUT parameters:
localparam string   OVFLW_MODE = "wrap";
localparam string   QUANT_MODE = "rnd";
localparam unsigned WL_IN      = 'd4;
localparam unsigned WL_OUT     = 'd3;
localparam          IWL_IN     = 'd2;
localparam          IWL_OUT    = 'd2;
localparam unsigned SIGNED     = 1'b1;

// Testbench registers, wires and variables:

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
Logger logger = new();

// DUT driver instanciation:
fxrnd_driver driver = new("fxrnd_input.txt", dut_if, logger);

// Initial block:
initial begin
    logger.header();
    logger.log("INFO", "Starting simulation");
    driver.init();
    logger.footer();
    $finish();
end

endmodule
