#include "fxrnd_defines.h"
#include "fxrnd_tb.h"
#include <fstream>
#include <algorithm>

void fxrnd_tb::fxrnd_driver(void){
    // Open files to record arch input

    sc_fixed<WL_IN, IWL_IN> data_in;

    int range = pow(2,WL_IN);
    for(int n=0; n<500; n++){
        data_in = ((-range/2) + (rand() % range))/pow(2,WL_IN-IWL_IN);
        o_data.write(data_in);

        wait(10, SC_NS);
    }
}

void fxrnd_tb::fxrnd_monitor(void){
    // Open files to record arch output
    ofstream fi, fo;
    fi.open("fxrnd_input.txt");
    fo.open("fxrnd_arch.txt");
    std::string strip_in;
    std::string strip_out;

    sc_fixed<WL_OUT, IWL_OUT> data_out;

    wait(1, SC_NS);
    for(int n=0; n<500; n++){
        wait(10, SC_NS);
        data_out = i_data.read();

        cout << "-------------------------------------------------" << endl;
        cout << "Input data <"<< WL_IN << ","<< IWL_IN << ">\t: " 
             << o_data.read().to_string(SC_BIN) << "\t("
             << o_data.read().to_string(SC_DEC) << ")" << endl;

        cout << "Output data <"<< WL_OUT << ","<< IWL_OUT << ">\t: " 
             << data_out.to_string(SC_BIN) << "\t("
             << data_out.to_string(SC_DEC) << ")" << endl;

        // Format data string and store it into a file
        strip_in = o_data.read().to_string(SC_BIN);
        strip_in = strip_in.substr(2);
        strip_in = strip_in.substr(0,WL_IN-IWL_IN) + strip_in.substr(WL_IN-IWL_IN+1);
        fi << strip_in << endl;
        // Format data string and store it into a file
        strip_out = data_out.to_string(SC_BIN);
        strip_out = strip_out.substr(2);
        strip_out = strip_out.substr(0,WL_OUT-IWL_OUT) + strip_out.substr(WL_OUT-IWL_OUT+1);
        fo << strip_out << endl;
    }
    fi.close();
    fo.close();
}
