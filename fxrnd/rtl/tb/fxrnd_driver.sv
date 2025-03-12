// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Class      : fxrnd_driver                                         Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: Driver for fxrnd block testbench.

class fxrnd_driver #(
    parameter unsigned WL_IN = 'd8,
    parameter unsigned DELAY = 'd10
);

int     fd;
string  file_name;
virtual fxrnd_interface dut_if;
Logger  logger;

// Class constructor:
function new(string file_name, virtual fxrnd_interface dut_if, Logger logger);
    this.file_name = file_name;
    this.dut_if    = dut_if;
    this.logger    = logger; 
endfunction

// Task name  : read_file
// Description: Read inputs from this.file_name and send to DUT
task read_file();
    // Task internal variables
    string line;
         
    // Test if file exists and open in read mode
    logger.log("INFO", {"Driving inputs from file ", this.file_name});
    this.fd = $fopen(this.file_name, "r");
    if(fd) logger.log("INFO", {"File ", this.file_name, " successfuly read!"});
    else   logger.log("ERROR", {"File ", this.file_name, " not found!"});

    // Start driving inputs from file:
    while(! $feof(this.fd)) begin
        $fgets(line, this.fd);
        $sscanf(line, "%b", dut_if.i_data);
        #(DELAY) dut_if.mon_check = 1'b1;
        #(DELAY) dut_if.mon_check = 1'b0;
    end
    $fclose(this.fd);
endtask

// Task name  : init
// Description: Auxiliary task for initializing DUT's inputs with default values.
task init();
    logger.log("INFO", "Initializing dut with default values.");
    dut_if.i_data = {WL_IN{1'b0}};
    dut_if.mon_check = 1'b0;
endtask

// Task name  : test_sanity_round
// Description: Sanity test the fixed-point rounding by entering known value.
task test_sanity();
    logger.log("INFO", "Initializing sanity round test...");
    dut_if.i_data = 8'b1111_0011; //00.11 = 0.75 <4,2>
    #(DELAY) dut_if.mon_check = 1'b1;
    #(DELAY) dut_if.mon_check = 1'b0;
endtask

endclass
