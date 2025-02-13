#include "fxp_rnd_defines.h"
#include <systemc.h>

SC_MODULE(fxp_rnd){
    // Interface
    sc_in <sc_fixed<8,2>> i_data;
    sc_out<sc_fixed<4,2>> o_data;
    // Functionality 
    void fxp_rnd_func();
    // Constructor
    SC_CTOR(fxp_rnd){
        SC_METHOD(fxp_rnd_func);
        sensitive << i_data;
    }
};
