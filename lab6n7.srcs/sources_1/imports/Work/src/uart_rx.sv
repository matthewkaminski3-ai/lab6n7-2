`timescale 1ns/1ps

module uart_rx #(
    parameter int unsigned DATA_BITS  = 8,
    parameter int unsigned OVERSAMPLE = 16
) (
    input  logic                     clk,
    input  logic                     rst,
    input  logic                     tick_16x,
    input  logic                     uart_rx_in,
    output logic [DATA_BITS-1:0]     rx_data,
    output logic                     frame_error,
    output logic                     frame_error_sticky
);

    localparam int unsigned OVERSAMPLE_COUNTER_WIDTH = (OVERSAMPLE <= 1) ? 1 : $clog2(OVERSAMPLE);
    localparam int unsigned BIT_COUNTER_WIDTH        = (DATA_BITS <= 1) ? 1 : $clog2(DATA_BITS);

    (* fsm_encoding = "none" *)
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t                                    state_d, state_q;
    logic [OVERSAMPLE_COUNTER_WIDTH-1:0]       tick_count_d, tick_count_q;
    logic [BIT_COUNTER_WIDTH-1:0]              bit_index_d, bit_index_q;
    logic [DATA_BITS-1:0]                      shift_reg_d, shift_reg_q;
    logic [DATA_BITS-1:0]                      rx_data_d, rx_data_q;
    logic                                      frame_error_d, frame_error_q;
    logic                                      frame_error_sticky_d, frame_error_sticky_q;

    always_comb begin
        state_d               = state_q;
        tick_count_d          = tick_count_q;
        bit_index_d           = bit_index_q;
        shift_reg_d           = shift_reg_q;
        rx_data_d             = rx_data_q;
        frame_error_d         = frame_error_q;
        frame_error_sticky_d  = frame_error_sticky_q;

        if (tick_16x) begin
            tick_count_d = tick_count_q + 1'b1;
        end

        case (state_q)
            IDLE: begin
                tick_count_d  = '0;
                bit_index_d   = '0;
                frame_error_d = 1'b0;

                if (!uart_rx_in) begin
                    state_d = START;
                end
            end

            START: begin
                if (tick_16x && (tick_count_q == (OVERSAMPLE/2 - 1))) begin
                    if (uart_rx_in) begin
                        state_d      = IDLE;
                        tick_count_d = '0;
                    end
                end

                if (tick_16x && (tick_count_q == (OVERSAMPLE - 1))) begin
                    state_d      = DATA;
                    tick_count_d = '0;
                    bit_index_d  = '0;
                    shift_reg_d  = '0;
                end
            end

            DATA: begin
                if (tick_16x && (tick_count_q == (OVERSAMPLE/2 - 1))) begin
                    shift_reg_d[bit_index_q] = uart_rx_in;
                end

                if (tick_16x && (tick_count_q == (OVERSAMPLE - 1))) begin
                    tick_count_d = '0;

                    if (bit_index_q == DATA_BITS-1) begin
                        state_d     = STOP;
                    end else begin
                        bit_index_d = bit_index_q + 1'b1;
                    end
                end
            end

            STOP: begin
                if (tick_16x && (tick_count_q == (OVERSAMPLE/2 - 1))) begin
                    if (uart_rx_in) begin
                        rx_data_d            = shift_reg_q;
                        frame_error_d        = 1'b0;
                        frame_error_sticky_d = 1'b0;
                    end else begin
                        frame_error_d        = 1'b1;
                        frame_error_sticky_d = 1'b1;
                    end
                end

                if (tick_16x && (tick_count_q == (OVERSAMPLE - 1))) begin
                    state_d      = IDLE;
                    tick_count_d = '0;
                end
            end

            default: begin
                state_d = IDLE;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state_q              <= IDLE;
            tick_count_q         <= '0;
            bit_index_q          <= '0;
            shift_reg_q          <= '0;
            rx_data_q            <= '0;
            frame_error_q        <= 1'b0;
            frame_error_sticky_q <= 1'b0;
        end else begin
            state_q              <= state_d;
            tick_count_q         <= tick_count_d;
            bit_index_q          <= bit_index_d;
            shift_reg_q          <= shift_reg_d;
            rx_data_q            <= rx_data_d;
            frame_error_q        <= frame_error_d;
            frame_error_sticky_q <= frame_error_sticky_d;
        end
    end

    assign rx_data            = rx_data_q;
    assign frame_error        = frame_error_q;
    assign frame_error_sticky = frame_error_sticky_q;

endmodule
