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
        if (Par_Typ) // Odd Parity
            parity_bit = ~^P_DATA;
        else // Even Parity
            parity_bit = ^P_DATA;
    end

    // Parity Check Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            par_err <= 1'b0;
        else if (par_chk_en) begin
            if (sampled_bit != parity_bit)
                par_err <= 1'b1;
            else
                par_err <= 1'b0;
        end else 
            par_err <= 1'b0;
    end
endmodule