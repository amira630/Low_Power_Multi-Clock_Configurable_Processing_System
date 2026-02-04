module PULSE_GEN(
    input wire clk,
    input wire rst_n,
    input wire lvl_sig,
    output reg pulse_sig
);

    reg lvl_reg, prev_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lvl_reg <= 1'b0;
            prev_reg <= 1'b0;
        end else begin
            lvl_reg <= lvl_sig;
            prev_reg <= lvl_reg;
        end
    end

    always @(*) begin
        pulse_sig = !prev_reg & lvl_reg;
    end

endmodule