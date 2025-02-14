// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Class      : fxrnd_monitor                                        Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: Monitor for fxrnd block testbench.

class fxrnd_monitor #(
    parameter unsigned WL_IN = 'd4,
    parameter unsigned DELAY = 'd10
);

int     errors; 
int     fd;
string  file_name;
virtual fxrnd_interface dut_if;
Logger  logger;

// Class constructor:
function new(string file_name, virtual fxrnd_interface dut_if, Logger logger);
    this.dut_if = dut_if;
    this.logger = logger; 
    this.errors = 0; 
endfunction

// Task name  : test_sanity_round
// Description: Sanity test the fixed-point rounding by entering known value.
task test_sanity_round();
    wait(dut_if.mon_check == 1'b1);
    logger.log("TEST", "Checking Test Sanity Round...");
    this.errors = (dut_if.o_data != 3'b010)? this.errors++ : this.errors; 
    logger.log("TEST", , errors==this.errors);
endtask

endclass
