#include "fxrnd.h"

void fxrnd::fxrnd_func(void){
    sc_fixed<WL_OUT, IWL_OUT, SC_RND_INF, SC_SAT> rnd_data;

    rnd_data = i_data.read();
    o_data.write(rnd_data);
}
