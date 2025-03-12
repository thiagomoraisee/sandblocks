// SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
// Module     : fxrnd                                                Date: 2025.02.13
// Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
// Description: Fixed-point rounding block using IEEE 1666-2023 SystemC standard for
//              quantization and overflow methods.

module fxrnd #(
    parameter string   OVFLW_MODE = "WRAP",
    parameter string   QUANT_MODE = "RND",
    parameter unsigned WL_IN      = 'd4,
    parameter unsigned WL_OUT     = 'd3,
    parameter          IWL_IN     = 'd2,
    parameter          IWL_OUT    = 'd2,
    parameter unsigned SIGNED     = 1'b1
)(
    input  logic signed [WL_IN-1:0]  i_data,
    output logic signed [WL_OUT-1:0] o_data
);

// Local parameters:
localparam unsigned FWL_IN    = WL_IN - IWL_IN;        // Input data fractional bits
localparam unsigned FWL_OUT   = WL_OUT - IWL_OUT;      // Output data fractional bits
localparam unsigned DEL_FBITS = FWL_IN - FWL_OUT;      // Fractional bits to be deleted
localparam unsigned DEL_IBITS = IWL_IN - IWL_OUT;      // integer bits to be deleted
localparam unsigned WL_QUANT  = IWL_IN + FWL_OUT + 1;  // integer bits to be deleted

// Internal wires and variables:
logic signed [WL_QUANT-1:0] w_data;

// QUANTIZATION

generate
if(QUANT_MODE == "RND") begin : quant_mode_rnd
    if(FWL_OUT >= FWL_IN) begin
        assign w_data = $signed({i_data, {(FWL_OUT-FWL_IN){1'b0}} });
    end else begin
        assign w_data = $signed({i_data[WL_IN-1],i_data[WL_IN-1 : DEL_FBITS]}) + i_data[DEL_FBITS-1];
    end
end

if(QUANT_MODE == "RND_ZERO") begin : quant_mode_rnd_zero

    // Local wires and variables:
    logic w_delbits_msb; // Most significant deleted bit
    logic w_delbits_or;  // Bitwise 

    assign w_delbits_msb = i_data[DEL_FBITS-1];
    if(DEL_FBITS > 1) begin
        assign w_delbits_or  = |i_data[DEL_FBITS-2:0];
    end else begin
        assign w_delbits_or  = 1'b1;
    end

    if(FWL_OUT >= FWL_IN) begin
        assign w_data = $signed({i_data, {(FWL_OUT-FWL_IN){1'b0}} });
    end else begin
        always_comb begin
            if(w_delbits_msb && (w_delbits_or || i_data[WL_IN-1])) begin
                w_data = $signed({i_data[WL_IN-1],i_data[WL_IN-1 : DEL_FBITS]}) + 1'b1;
            end else begin
                w_data = $signed({i_data[WL_IN-1],i_data[WL_IN-1 : DEL_FBITS]});
            end
        end
    end
end
endgenerate

// OVERFLOW

generate
if(OVFLW_MODE == "WRAP") begin : ovflw_mode_wrap
    if(IWL_OUT > IWL_IN) begin
        assign o_data = $signed({{(IWL_OUT-IWL_IN){w_data[WL_IN-1]}}, w_data});
    end else begin
        assign o_data = w_data[WL_OUT-1:0];
    end
end

if(OVFLW_MODE == "SAT") begin : ovflw_mode_sat
    // Logic for Overflow detection
    logic w_ovflw_detect;
    assign w_ovflw_detect = ~((&w_data[WL_QUANT-1:WL_QUANT-DEL_IBITS-2])^(~|w_data[WL_QUANT-1:WL_QUANT-DEL_IBITS-2]));

    if(IWL_OUT > IWL_IN) begin
        assign o_data = $signed({{(IWL_OUT-IWL_IN){w_data[WL_IN-1]}}, w_data});
    end else begin
        always_comb begin
            if(w_ovflw_detect) begin
                // If an overflow occurred, then saturate.
                o_data[WL_OUT-1] = w_data[WL_QUANT-1];
                o_data[WL_OUT-2:0] = {(WL_OUT-1){~w_data[WL_QUANT-1]}};
            end else begin
                // If no overflow occurred, then copy the remaining bits.
                o_data = w_data[WL_OUT-1:0];
            end
        end
    end
end

if(OVFLW_MODE == "SAT_ZERO") begin : ovflw_mode_sat_zero
    // Logic for Overflow detection
    logic w_ovflw_detect;
    assign w_ovflw_detect = ~((&w_data[WL_QUANT-1:WL_QUANT-DEL_IBITS-2])^(~|w_data[WL_QUANT-1:WL_QUANT-DEL_IBITS-2]));

    if(IWL_OUT > IWL_IN) begin
        assign o_data = $signed({{(IWL_OUT-IWL_IN){w_data[WL_IN-1]}}, w_data});
    end else begin
        assign o_data = (w_ovflw_detect)? {(WL_OUT){1'b0}} : w_data[WL_QUANT-1:0];
    end
end

if(OVFLW_MODE == "SAT_SYM") begin : ovflw_mode_sat_sym
    // Logic for Overflow detection
    logic w_ovflw_detect;
    assign w_ovflw_detect = ~((&w_data[WL_QUANT-1:WL_QUANT-DEL_IBITS-2])^(~|w_data[WL_QUANT-1:WL_QUANT-DEL_IBITS-2]));

    if(IWL_OUT > IWL_IN) begin
        assign o_data = $signed({{(IWL_OUT-IWL_IN){w_data[WL_IN-1]}}, w_data});
    end else begin
        always_comb begin
            if(w_ovflw_detect || (w_data[WL_OUT-1:0] == ('d1 << (WL_OUT-1)))) begin
                // If an overflow occurred, then saturate.
                if(w_data[WL_QUANT-1]) begin
                    o_data = ('d1 << (WL_OUT-1)) | 'd1;
                end else begin
                    o_data = ~('d1 << (WL_OUT-1));
                end
            end else begin
                // If no overflow occurred, then copy the remaining bits.
                o_data = w_data[WL_OUT-1:0];
            end
        end
    end
end
endgenerate

endmodule
