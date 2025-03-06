#include "fxrnd_defines.h"
#include <systemc.h>
#include "fxrnd.h"
#include "fxrnd_tb.h"

using namespace sc_core;
using namespace sc_dt;

SC_MODULE(fxrnd_main){
    fxrnd    *uu_fxrnd;
    fxrnd_tb *uu_fxrnd_tb;

    #if(PROBE_SIGNALS)
        sc_trace_file *tf = sc_create_vcd_trace_file(BLOCK_NAME); 
    #endif

    sc_signal<sc_fixed<WL_IN, IWL_IN>>  w_data;
    sc_signal<sc_fixed<WL_OUT,IWL_OUT>> w_data_rnd;

    // Constructor
    SC_CTOR(fxrnd_main) {

        // DUT instanciation and wirebonding
        uu_fxrnd = new fxrnd("fxrnd");
        uu_fxrnd->i_data(w_data);
        uu_fxrnd->o_data(w_data_rnd);

        // DUT instanciation and wirebonding
        uu_fxrnd_tb = new fxrnd_tb("fxrnd_tb");
        uu_fxrnd_tb->i_data(w_data_rnd);
        uu_fxrnd_tb->o_data(w_data);

        #if(PROBE_SIGNALS)
            tf->set_time_unit(10, SC_NS); 
            sc_trace(tf, w_data, "w_data");
            sc_trace(tf, w_data_rnd, "w_data_rnd");
        #endif
    }

    // Destructor
    ~fxrnd_main(){
        delete uu_fxrnd;
        delete uu_fxrnd_tb;
        #if(PROBE_SIGNALS)
            sc_close_vcd_trace_file(tf);
        #endif
    }
};

fxrnd_main *uu_fxrnd_main = NULL;

int sc_main(int argc, char* argv[]){

    uu_fxrnd_main = new fxrnd_main("fxrnd_main");

    // Start simulation
    sc_start();

    cout << "Simulation finished at time " << sc_time_stamp() << endl;

    return 0;
}
