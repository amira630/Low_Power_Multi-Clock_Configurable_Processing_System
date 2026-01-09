module Parity_Check(
    input wire       clk,
    input wire       rst_n,
    input wire       par_chk_en,
    input wire       Par_Typ, // 0: Even, 1: Odd
    input wire [7:0] P_DATA,
    input wire       sampled_bit,
    output reg       par_err
);

    reg parity_bit;

    // Calculate Parity
    always @(*) begin
        if (Par_Typ) begin // Odd Parity
            parity_bit = ~^P_DATA;
        end else begin // Even Parity
            parity_bit = ^P_DATA;
        end
    end

    // Parity Check Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            par_err <= 1'b0;
        end else if (par_chk_en) begin
            if (sampled_bit != parity_bit) begin
                par_err <= 1'b1;
            end else begin
                par_err <= 1'b0;
            end
        end else begin
            par_err <= 1'b0;
        end
    end
endmodule