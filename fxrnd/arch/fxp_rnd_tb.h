#include <systemc.h>

SC_MODULE(fxp_rnd_tb){
    // Interface
    sc_in <sc_fixed<4,2>> i_data;
    sc_out<sc_fixed<8,2>> o_data;
    // Functionalities
    void fxp_rnd_driver();
    void fxp_rnd_monitor();
    // Constructor
    SC_CTOR(fxp_rnd_tb){
        SC_THREAD(fxp_rnd_driver);
        SC_THREAD(fxp_rnd_monitor);
    }
};
