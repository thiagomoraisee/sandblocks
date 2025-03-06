#include "fxrnd_defines.h"
#include "fxrnd_tb.h"

void fxrnd_tb::fxrnd_driver(void){
    sc_fixed<WL_IN, IWL_IN> data_in;

    int range = pow(2,WL_IN);
    for(int n=0; n<10; n++){
        data_in = ((-range/2) + (rand() % range))/pow(2,WL_IN-IWL_IN);
        o_data.write(data_in);
        wait(10, SC_NS);
    }
}

void fxrnd_tb::fxrnd_monitor(void){
    sc_fixed<WL_OUT, IWL_OUT> data_out;

    wait(1, SC_NS);
    for(int n=0; n<10; n++){
        wait(10, SC_NS);
        data_out = i_data.read();

        cout << "-------------------------------------------------" << endl;
        cout << "Input data <"<< WL_IN << ","<< IWL_IN << ">\t: " 
             << o_data.read().to_string(SC_BIN) << "\t("
             << o_data.read().to_string(SC_DEC) << ")" << endl;

        cout << "Output data <"<< WL_OUT << ","<< IWL_OUT << ">\t: " 
             << data_out.to_string(SC_BIN) << "\t("
             << data_out.to_string(SC_DEC) << ")" << endl;
    }
}
