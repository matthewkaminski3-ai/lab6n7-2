`timescale 1ns/1ps

module uart_tx #(
    parameter int unsigned DATA_BITS  = 8,
    parameter int unsigned OVERSAMPLE = 16
) (
    input  logic                 clk,
    input  logic                 rst,
    input  logic                 tick_16x,
    input  logic [DATA_BITS-1:0] tx_data,
    input  logic                 transmit,
    output logic                 uart_tx_out,
    output logic                 busy
);
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state_d, state_q;
    logic [$clog2(OVERSAMPLE)-1:0] tick_count_d, tick_count_q;
    logic [$clog2(DATA_BITS):0]    bit_index_d, bit_index_q;
    logic [DATA_BITS-1:0]          shift_reg_d, shift_reg_q;
    logic                          uart_tx_out_d, uart_tx_out_q;

    always_comb begin
        state_d       = state_q;
        tick_count_d  = tick_count_q;
        bit_index_d   = bit_index_q;
        shift_reg_d   = shift_reg_q;
        uart_tx_out_d = uart_tx_out_q;

        if (tick_16x) begin
            tick_count_d = tick_count_q + 1'b1;
        end

        unique case (state_q)
            IDLE: begin
                uart_tx_out_d = 1'b1;
                tick_count_d  = '0;
                bit_index_d   = '0;
                if (transmit) begin
                    state_d       = START;
                    shift_reg_d   = tx_data;
                    uart_tx_out_d = 1'b0;
                end
            end

            START: begin
                uart_tx_out_d = 1'b0;
                if (tick_16x && tick_count_q == (OVERSAMPLE-1)) begin
                    state_d      = DATA;
                    tick_count_d = '0;
                end
            end

            DATA: begin
                uart_tx_out_d = shift_reg_q[0];
                if (tick_16x && tick_count_q == (OVERSAMPLE-1)) begin
                    tick_count_d = '0;
                    shift_reg_d  = {1'b0, shift_reg_q[DATA_BITS-1:1]};
                    if (bit_index_q == DATA_BITS-1) begin
                        state_d     = STOP;
                        bit_index_d = '0;
                    end else begin
                        bit_index_d = bit_index_q + 1'b1;
                    end
                end
            end

            STOP: begin
                uart_tx_out_d = 1'b1;
                if (tick_16x && tick_count_q == (OVERSAMPLE-1)) begin
                    state_d      = IDLE;
                    tick_count_d = '0;
                    bit_index_d  = '0;
                end
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state_q       <= IDLE;
            tick_count_q  <= '0;
            bit_index_q   <= '0;
            shift_reg_q   <= '0;
            uart_tx_out_q <= 1'b1;
        end else begin
            state_q       <= state_d;
            tick_count_q  <= tick_count_d;
            bit_index_q   <= bit_index_d;
            shift_reg_q   <= shift_reg_d;
            uart_tx_out_q <= uart_tx_out_d;
        end
    end

    assign uart_tx_out = uart_tx_out_q;
    assign busy        = (state_q != IDLE);
endmodule
