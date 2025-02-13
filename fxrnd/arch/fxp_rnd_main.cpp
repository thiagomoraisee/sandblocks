#include "fxp_rnd_defines.h"
#include <systemc.h>
#include "fxp_rnd.h"
#include "fxp_rnd_tb.h"

using namespace sc_core;
using namespace sc_dt;

SC_MODULE(fxp_rnd_main){
    fxp_rnd    *uu_fxp_rnd;
    fxp_rnd_tb *uu_fxp_rnd_tb;

    #if(PROBE_SIGNALS)
        sc_trace_file *tf = sc_create_vcd_trace_file(BLOCK_NAME); 
    #endif

    sc_signal<sc_fixed<8,2>> w_data;
    sc_signal<sc_fixed<4,2>> w_data_rnd;

    // Constructor
    SC_CTOR(fxp_rnd_main) {

        // DUT instanciation and wirebonding
        uu_fxp_rnd = new fxp_rnd("fxp_rnd");
        uu_fxp_rnd->i_data(w_data);
        uu_fxp_rnd->o_data(w_data_rnd);

        // DUT instanciation and wirebonding
        uu_fxp_rnd_tb = new fxp_rnd_tb("fxp_rnd_tb");
        uu_fxp_rnd_tb->i_data(w_data_rnd);
        uu_fxp_rnd_tb->o_data(w_data);

        #if(PROBE_SIGNALS)
            tf->set_time_unit(10, SC_NS); 
            sc_trace(tf, w_data, "w_data");
            sc_trace(tf, w_data_rnd, "w_data_rnd");
        #endif
    }

    // Destructor
    ~fxp_rnd_main(){
        delete uu_fxp_rnd;
        delete uu_fxp_rnd_tb;
        #if(PROBE_SIGNALS)
            sc_close_vcd_trace_file(tf);
        #endif
    }
};

fxp_rnd_main *uu_fxp_rnd_main = NULL;

int sc_main(int argc, char* argv[]){
    uu_fxp_rnd_main = new fxp_rnd_main("fxp_rnd_main");

    // Start simulation
    sc_start();

    cout << "Simulation finished at time " << sc_time_stamp() << endl;

    return 0;
}
