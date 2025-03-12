// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Class      : fxrnd_monitor                                        Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: Monitor for fxrnd block testbench.

class fxrnd_monitor #(
    parameter unsigned WL_OUT = 'd4,
    parameter unsigned DELAY  = 'd10
);

int     errors; 
int     fd;
string  file_name;
virtual fxrnd_interface dut_if;
Logger  logger;

// Class constructor:
function new(string file_name, virtual fxrnd_interface dut_if, Logger logger);
    this.file_name = file_name;
    this.dut_if    = dut_if;
    this.logger    = logger; 
    this.errors    = 0; 
endfunction

// Task name  : read_file
// Description: Read inputs from this.file_name and send to DUT
task read_file();
    // Task internal variables
    int test_errors = this.errors;
    string line;
    logic signed [WL_OUT-1:0] data_ref;
         
    // Test if file exists and open in read mode
    logger.log("INFO", {"Comparing outputs from file ", this.file_name});
    this.fd = $fopen(this.file_name, "r");
    if(fd) logger.log("INFO", {"File ", this.file_name, " successfuly read!"});
    else   logger.log("ERROR", {"File ", this.file_name, " not found!"});

    // Compare DUT output with reference file:
    logger.log("TEST", "Checking reference file...");
    while(! $feof(this.fd)) begin
        wait(dut_if.mon_check == 1'b1);
        $fgets(line, this.fd);
        $sscanf(line, "%b", data_ref);
        if(data_ref != dut_if.o_data) this.errors++; 
        logger.report(
            .port_name("o_data"),
            .dut_data ($sformatf("%b", dut_if.o_data)),
            .ref_data ($sformatf("%b", data_ref)),
            .isequal  (data_ref == dut_if.o_data));
        #(DELAY);
    end
    logger.log("TEST", ,test_errors==this.errors);
    $fclose(this.fd);
endtask

// Task name  : test_sanity
// Description: Sanity test the fixed-point rounding by entering known value.
task test_sanity();
    int test_errors = this.errors;
    wait(dut_if.mon_check == 1'b1);
    logger.log("TEST", "Checking Test Sanity...");
    if(dut_if.o_data != 4'b1100) this.errors++; 
    logger.log("TEST", ,test_errors==this.errors);
endtask

endclass
