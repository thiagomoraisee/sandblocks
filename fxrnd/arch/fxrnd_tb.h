#include <systemc.h>

SC_MODULE(fxrnd_tb){
    // Interface
    sc_in <sc_fixed<WL_OUT, IWL_OUT>> i_data;
    sc_out<sc_fixed<WL_IN, IWL_IN>>   o_data;
    // Functionalities
    void fxrnd_driver();
    void fxrnd_monitor();
    // Constructor
    SC_CTOR(fxrnd_tb){
        SC_THREAD(fxrnd_driver);
        SC_THREAD(fxrnd_monitor);
    }
};
