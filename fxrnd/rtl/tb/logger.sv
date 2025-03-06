// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Class      : Logger                                               Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: A logger to logfile handling

class Logger #(parameter unsigned HEAD_WIDE = 40);
    shortint info_level;
    string   file_name;
    string   tags[];
    string   separator_thin = "";
    string   separator_bold = "";
    
    // Class constructor
    // function new(shortint info_level=0, string file_name="None");
    function new();
        this.tags       = '{"INFO", "TEST", "WARNING", "ERROR", "FATAL"};
        for(int i=0; i<HEAD_WIDE; i++) begin
            this.separator_thin = {separator_thin,"-"};
            this.separator_bold = {separator_bold,"="};
        end
        //this.info_level = info_level;
        //this.file_name  = file_name;
    endfunction

    // Function to centralize text for display
    function string center(string text);
        int padding = (HEAD_WIDE - text.len())/2;
        if(padding > 0) begin
            return {{padding{" "}},text,{padding{" "}}};
        end else begin
            return text;
        end
    endfunction

    // Log method
    task log(string tag, string message="None", bit status=0);
        // Test if the tags is declared in tags list:
        bit      found = 1'b0;
        shortint level = 0;
        foreach (this.tags[i]) begin
            if(tag == this.tags[i]) begin
                found = 1'b1;
                level = i;
                break;
            end
        end
        // display formatted message:
        if(!found) begin
            $display("[WARNING] Logger: Tag '%s' not found in tags list.", tag);
        end else if(level >= this.info_level) begin
            if((tag == "TEST") && (message != "None")) begin
                $write("[%s] %s", tag, message);
            end else if((tag == "TEST") && (message == "None")) begin
                if(status) $display("PASS");
                else       $display("FAIL");
            end else begin
                $display("[%s] %s", tag, message);
            end
        end
    endtask

    // Task to print log header
    task header();
        //$display({HEAD_WIDE{"="}});
        $display("%s",this.separator_bold);
        $display(center("RTL Simulation"));
        $display(center("Copyright (c) 2025 SandBlocks"));
        $system("date");
        //$display({HEAD_WIDE{"-"}});
        $display("%s",this.separator_thin);
    endtask

    // Task to print log footer
    task footer();
        //$display({HEAD_WIDE{"-"}});
        $display("%s",this.separator_thin);
        $display("Simulation stopped at time %0t ps", $time);
        //$display({HEAD_WIDE{"="}});
        $display("%s",this.separator_bold);
    endtask

    // Task to print the testbench final result 
    task result(int errors);
        $display("%s",this.separator_thin);
        if(errors == 0) $display(center("P A S S"));
        else            $display(center("F A I L"));
    endtask

endclass
