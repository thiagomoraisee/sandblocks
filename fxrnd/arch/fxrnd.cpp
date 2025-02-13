#include "fxrnd.h"

void fxrnd::fxrnd_func(void){
    sc_fixed<4,2,SC_RND> rnd_data;

    rnd_data = i_data.read();
    o_data.write(rnd_data);
}
