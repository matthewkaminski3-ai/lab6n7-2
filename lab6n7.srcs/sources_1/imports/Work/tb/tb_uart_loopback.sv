`timescale 1ns/1ps

module tb_uart_loopback;
    localparam int unsigned F_CLK_HZ   = 100_000_000;
    localparam int unsigned BAUD       = 9600;
    localparam int unsigned OVERSAMPLE = 16;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic tick_16x;
    logic [7:0] tx_data = 8'h00;
    logic transmit = 1'b0;
    logic uart_tx_out;
    logic uart_rx_in;
    logic [7:0] rx_data;
    logic frame_error;
    logic frame_error_sticky;
    logic busy;

    always #5 clk = ~clk;

    baud_gen #(
        .F_CLK_HZ  (F_CLK_HZ),
        .BAUD      (BAUD),
        .OVERSAMPLE(OVERSAMPLE)
    ) baud_gen_i (
        .clk     (clk),
        .rst     (rst),
        .tick_16x(tick_16x)
    );

    uart_tx #(
        .DATA_BITS (8),
        .OVERSAMPLE(OVERSAMPLE)
    ) tx_inst (
        .clk        (clk),
        .rst        (rst),
        .tick_16x   (tick_16x),
        .tx_data    (tx_data),
        .transmit   (transmit),
        .uart_tx_out(uart_tx_out),
        .busy       (busy)
    );

    // Simple 2-FF synchronizer to match top-level integration
    sync_2ff sync_rx (
        .clk     (clk),
        .rst     (rst),
        .async_in(uart_tx_out),
        .sync_out(uart_rx_in)
    );

    uart_rx #(
        .DATA_BITS (8),
        .OVERSAMPLE(OVERSAMPLE)
    ) rx_inst (
        .clk        (clk),
        .rst        (rst),
        .tick_16x          (tick_16x),
        .uart_rx_in        (uart_rx_in),
        .rx_data           (rx_data),
        .frame_error       (frame_error),
        .frame_error_sticky(frame_error_sticky)
    );

    task automatic pulse_transmit();
        @(posedge clk);
        transmit = 1'b1;
        @(posedge clk);
        transmit = 1'b0;
    endtask

    initial begin
        repeat (10) @(posedge clk);
        rst = 1'b0;
        repeat (OVERSAMPLE) @(posedge tick_16x);

        // "U"
        tx_data = 8'h55;
        pulse_transmit();
        @(posedge busy);
        @(negedge busy);
        repeat (OVERSAMPLE) @(posedge tick_16x);
        if (rx_data != 8'h55) begin
            $error("Loopback mismatch for 'U': got 0x%0h", rx_data);
        end
        if (frame_error != 1'b0) begin
            $error("Unexpected frame_error for 'U'");
        end
        if (frame_error_sticky != 1'b0) begin
            $error("frame_error_sticky should stay low for valid frame 'U'");
        end

        // "A"
        tx_data = 8'h41;
        pulse_transmit();
        @(posedge busy);
        @(negedge busy);
        repeat (OVERSAMPLE) @(posedge tick_16x);
        if (rx_data != 8'h41) begin
            $error("Loopback mismatch for 'A': got 0x%0h", rx_data);
        end
        if (frame_error != 1'b0) begin
            $error("Unexpected frame_error for 'A'");
        end
        if (frame_error_sticky != 1'b0) begin
            $error("frame_error_sticky should stay low for valid frame 'A'");
        end

        // "R"
        tx_data = 8'h52;
        pulse_transmit();
        @(posedge busy);
        @(negedge busy);
        repeat (OVERSAMPLE) @(posedge tick_16x);
        if (rx_data != 8'h52) begin
            $error("Loopback mismatch for 'R': got 0x%0h", rx_data);
        end
        if (frame_error != 1'b0) begin
            $error("Unexpected frame_error for 'R'");
        end
        if (frame_error_sticky != 1'b0) begin
            $error("frame_error_sticky should stay low for valid frame 'R'");
        end

        $display("tb_uart_loopback completed successfully");
        $finish;
    end
endmodule
