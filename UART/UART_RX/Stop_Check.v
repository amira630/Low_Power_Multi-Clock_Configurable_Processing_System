module Stop_Check(
    input wire clk,
    input wire rst_n,
    input wire stp_chk_en,
    input wire sampled_bit,
    output reg stp_err
);

    // Stop Bit Check Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stp_err <= 1'b0;
        else
            stp_err <= stp_chk_en & (!sampled_bit);
    end

endmodule