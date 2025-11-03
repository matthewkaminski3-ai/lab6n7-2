`timescale 1ns/1ps

module sync_2ff (
    input  logic clk,
    input  logic rst,
    input  logic async_in,
    output logic sync_out
);
    (* async_reg = "true" *) logic meta_q;
    logic sync_q;

    always_ff @(posedge clk) begin
        if (rst) begin
            meta_q <= 1'b1;
            sync_q <= 1'b1;
        end else begin
            meta_q <= async_in;
            sync_q <= meta_q;
        end
    end

    assign sync_out = sync_q;
endmodule
