// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Module     : fxrnd_interface                                      Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: Interface for fxrnd connections.

interface fxrnd_interface #(
    parameter unsigned WL_IN  = 'd8,
    parameter unsigned WL_OUT = 'd4
);

logic signed [WL_IN-1:0]  i_data;
logic signed [WL_OUT-1:0] o_data;
logic                     mon_check;

endinterface
