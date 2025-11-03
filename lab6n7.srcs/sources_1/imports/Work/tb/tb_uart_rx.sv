`timescale 1ns/1ps

module tb_uart_rx;
    localparam int unsigned F_CLK_HZ   = 100_000_000;
    localparam int unsigned BAUD       = 9600;
    localparam int unsigned OVERSAMPLE = 16;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic tick_16x;
    logic uart_rx_in = 1'b1;
    logic [7:0] rx_data;
    logic frame_error;
    logic frame_error_sticky;
    logic [7:0] last_valid;
    logic       saw_frame_error;

    // Generate 100 MHz clock
    always #5 clk = ~clk;

    // Instantiate baud generator
    baud_gen #(
        .F_CLK_HZ  (F_CLK_HZ),
        .BAUD      (BAUD),
        .OVERSAMPLE(OVERSAMPLE)
    ) baud_gen_i (
        .clk     (clk),
        .rst     (rst),
        .tick_16x(tick_16x)
    );

    // Device under test
    uart_rx #(
        .DATA_BITS (8),
        .OVERSAMPLE(OVERSAMPLE)
    ) dut (
        .clk        (clk),
        .rst        (rst),
        .tick_16x   (tick_16x),
        .uart_rx_in (uart_rx_in),
        .rx_data    (rx_data),
        .frame_error(frame_error),
        .frame_error_sticky(frame_error_sticky)
    );

    localparam int STOP_MID = (OVERSAMPLE/2) - 1;

    property stop_low_triggers_frame_error;
        @(posedge clk) disable iff (rst)
        (dut.state_q == dut.STOP && tick_16x && dut.tick_count_q == STOP_MID && !uart_rx_in)
        |=> frame_error;
    endproperty

    property frame_error_preserves_data;
        @(posedge clk) disable iff (rst)
        (dut.state_q == dut.STOP && tick_16x && dut.tick_count_q == STOP_MID && !uart_rx_in)
        |=> rx_data == $past(rx_data);
    endproperty

    property frame_error_sets_sticky;
        @(posedge clk) disable iff (rst)
        (dut.state_q == dut.STOP && tick_16x && dut.tick_count_q == STOP_MID && !uart_rx_in)
        |=> frame_error_sticky;
    endproperty

    property good_stop_clears_sticky;
        @(posedge clk) disable iff (rst)
        (dut.state_q == dut.STOP && tick_16x && dut.tick_count_q == STOP_MID && uart_rx_in)
        |=> !frame_error_sticky;
    endproperty

    assert property (stop_low_triggers_frame_error)
        else $error("frame_error did not assert following a low stop bit sample");

    assert property (frame_error_preserves_data)
        else $error("rx_data changed during framing error");

    assert property (frame_error_sets_sticky)
        else $error("frame_error_sticky failed to latch on framing error");

    assert property (good_stop_clears_sticky)
        else $error("frame_error_sticky failed to clear on clean stop bit");

    // Helper task: hold the RX line for the specified number of oversample ticks
    task automatic drive_uart_bit (input logic level);
        uart_rx_in = level;
        repeat (OVERSAMPLE) @(posedge tick_16x);
    endtask

    task automatic drive_uart_frame (input logic [7:0] data, input logic inject_stop_error);
        int idx;
        drive_uart_bit(1'b0); // start bit
        for (idx = 0; idx < 8; idx++) begin
            drive_uart_bit(data[idx]);
        end
        drive_uart_bit(inject_stop_error ? 1'b0 : 1'b1); // stop bit
        // idle for one bit time before next frame
        drive_uart_bit(1'b1);
    endtask

    initial begin
        // Apply reset
        repeat (10) @(posedge clk);
        rst = 1'b0;

        // Allow baud generator to settle
        repeat (OVERSAMPLE * 2) @(posedge tick_16x);

        // 1) Valid frame: ASCII 'A'
        drive_uart_frame(8'h41, 1'b0);
        repeat (OVERSAMPLE * 2) @(posedge tick_16x);
        if (rx_data != 8'h41) begin
            $error("RX data mismatch: expected 0x41, got 0x%0h", rx_data);
        end
        if (frame_error != 1'b0) begin
            $error("Unexpected frame_error after valid frame");
        end
        if (frame_error_sticky != 1'b0) begin
            $error("frame_error_sticky should remain low after valid frame");
        end

        // 2) Stop-bit error frame: ASCII 'U' with low stop bit
        last_valid = rx_data;
        saw_frame_error = 1'b0;

        fork
            drive_uart_frame(8'h55, 1'b1);
            begin
                repeat (OVERSAMPLE * 12) begin
                    @(posedge tick_16x);
                    if (frame_error) saw_frame_error = 1'b1;
                end
            end
        join

        // Allow FSM to return to IDLE
        repeat (OVERSAMPLE) @(posedge tick_16x);

        if (!saw_frame_error) begin
            $error("Did not observe frame_error pulse during bad stop bit");
        end else begin
            $display("Observed frame_error pulse during bad stop bit.");
        end

        if (rx_data != last_valid) begin
            $error("rx_data should hold last valid value when frame error occurs (expected 0x%0h, got 0x%0h)",
                   last_valid, rx_data);
        end else begin
            $display("rx_data held previous valid byte (0x%0h) during framing error.", rx_data);
        end

        if (frame_error_sticky != 1'b1) begin
            $error("frame_error_sticky should latch high after framing error");
        end

        // 3) Next valid frame should clear sticky bit
        drive_uart_frame(8'h52, 1'b0);
        repeat (OVERSAMPLE * 2) @(posedge tick_16x);
        if (frame_error_sticky != 1'b0) begin
            $error("frame_error_sticky should clear after next valid frame");
        end

        $display("tb_uart_rx completed successfully");
        $finish;
    end
endmodule
