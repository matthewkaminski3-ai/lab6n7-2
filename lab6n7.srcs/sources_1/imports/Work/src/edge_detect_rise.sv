`timescale 1ns/1ps

module edge_detect_rise (
    input  logic clk,
    input  logic rst,
    input  logic sig_in,
    output logic rise_pulse
);
    logic sig_d;

    always_ff @(posedge clk) begin
        if (rst) begin
            sig_d <= 1'b0;
        end else begin
            sig_d <= sig_in;
        end
    end

    assign rise_pulse = sig_in & ~sig_d;
endmodule
