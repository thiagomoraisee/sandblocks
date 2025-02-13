#include <systemc.h>

SC_MODULE(fxrnd_tb){
    // Interface
    sc_in <sc_fixed<4,2>> i_data;
    sc_out<sc_fixed<8,2>> o_data;
    // Functionalities
    void fxrnd_driver();
    void fxrnd_monitor();
    // Constructor
    SC_CTOR(fxrnd_tb){
        SC_THREAD(fxrnd_driver);
        SC_THREAD(fxrnd_monitor);
    }
};
