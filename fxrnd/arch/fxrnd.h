#include "fxrnd_defines.h"
#include <systemc.h>

SC_MODULE(fxrnd){
    // Interface
    sc_in <sc_fixed<WL_IN, IWL_IN>>  i_data;
    sc_out<sc_fixed<WL_OUT,IWL_OUT>> o_data;
    // Functionality 
    void fxrnd_func();
    // Constructor
    SC_CTOR(fxrnd){
        SC_METHOD(fxrnd_func);
        sensitive << i_data;
    }
};
