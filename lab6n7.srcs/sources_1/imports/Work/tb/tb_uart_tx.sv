`timescale 1ns/1ps

module tb_uart_tx;
    localparam int unsigned F_CLK_HZ   = 100_000_000;
    localparam int unsigned BAUD       = 9600;
    localparam int unsigned OVERSAMPLE = 16;

    logic clk = 1'b0;
    logic rst = 1'b1;
    logic tick_16x;
    logic [7:0] tx_data = 8'h00;
    logic transmit = 1'b0;
    logic uart_tx_out;
    logic busy;
    logic [7:0] captured;
    logic stop_bit_level;

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
    uart_tx #(
        .DATA_BITS (8),
        .OVERSAMPLE(OVERSAMPLE)
    ) dut (
        .clk        (clk),
        .rst        (rst),
        .tick_16x   (tick_16x),
        .tx_data    (tx_data),
        .transmit   (transmit),
        .uart_tx_out(uart_tx_out),
        .busy       (busy)
    );

    task automatic pulse_transmit();
        @(posedge clk);
        transmit = 1'b1;
        @(posedge clk);
        transmit = 1'b0;
    endtask

    task automatic capture_frame(output logic [7:0] captured_bits, output logic stop_bit);
        int i;
        captured_bits = '0;
        stop_bit = 1'b1;

        // Wait for start bit
        wait (uart_tx_out == 1'b0);
        if (!busy) begin
            $error("busy should assert at start bit");
        end

        // Start bit should remain low throughout the first symbol
        repeat (OVERSAMPLE/2) @(posedge tick_16x);
        if (uart_tx_out != 1'b0) begin
            $error("Start bit not held low at mid-bit");
        end
        repeat (OVERSAMPLE/2) @(posedge tick_16x);

        for (i = 0; i < 8; i++) begin
            repeat (OVERSAMPLE/2) @(posedge tick_16x);
            captured_bits[i] = uart_tx_out;
            repeat (OVERSAMPLE/2) @(posedge tick_16x);
        end

        repeat (OVERSAMPLE/2) @(posedge tick_16x);
        stop_bit = uart_tx_out;
        repeat (OVERSAMPLE/2) @(posedge tick_16x);

        // Allow line to return idle
        repeat (OVERSAMPLE) @(posedge tick_16x);
        if (busy) begin
            $error("busy should deassert after stop bit");
        end
    endtask

    initial begin
        // Reset sequence
        repeat (10) @(posedge clk);
        rst = 1'b0;
        repeat (OVERSAMPLE) @(posedge tick_16x);

        // 1) Transmit ASCII 'Z' (0x5A)
        tx_data = 8'h5A;
        pulse_transmit();
        capture_frame(captured, stop_bit_level);
        if (captured != 8'h5A) begin
            $error("Captured byte mismatch: expected 0x5A, got 0x%0h", captured);
        end
        if (stop_bit_level != 1'b1) begin
            $error("Stop bit should be high");
        end

        // 2) Ensure new transfer waits until previous completes
        tx_data = 8'h33;
        pulse_transmit();
        // Attempt to retrigger while busy
        @(posedge clk);
        if (busy) begin
            transmit = 1'b1;
            @(posedge clk);
            transmit = 1'b0;
        end
        capture_frame(captured, stop_bit_level);
        if (captured != 8'h33) begin
            $error("Second frame mismatch: expected 0x33, got 0x%0h", captured);
        end
        if (stop_bit_level != 1'b1) begin
            $error("Stop bit incorrect on second frame");
        end

        $display("tb_uart_tx completed successfully");
        $finish;
    end
endmodule
