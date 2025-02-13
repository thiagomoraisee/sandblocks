#include "fxp_rnd.h"

void fxp_rnd::fxp_rnd_func(void){
    sc_fixed<4,2,SC_RND> rnd_data;

    rnd_data = i_data.read();
    o_data.write(rnd_data);
}
