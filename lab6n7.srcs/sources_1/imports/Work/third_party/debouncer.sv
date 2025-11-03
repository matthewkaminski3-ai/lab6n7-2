`timescale 1ns / 1ps

module debouncer #(parameter int unsigned DEBOUNCE_COUNT = 500_000) (
    input logic clk,
    input logic rst,
    input logic btn_in,
    output logic btn_out
    );

    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/

    localparam int unsigned COUNTER_WIDTH = $clog2(DEBOUNCE_COUNT);

    logic [COUNTER_WIDTH-1:0] cnt;
    (* async_reg = "true" *) logic sync0, sync1;
    
    always_ff @(posedge clk) begin
        sync0 <= btn_in;
        sync1 <= sync0;
    end

    always_ff @(posedge clk) begin
        if (sync1 != btn_out) begin

            cnt <= cnt + 1;

            if (cnt >= DEBOUNCE_COUNT) begin
                btn_out <= sync1;
                cnt <= 16'd0;
            end
        end else begin
            cnt <= 16'd0;
        end

        if (rst) begin
            cnt <= 16'd0;
            btn_out <= 1'b0;
        end
    end

    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/


endmodule