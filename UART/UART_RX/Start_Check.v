module Start_Check(
    input wire clk,
    input wire rst_n,
    input wire strt_chk_en,
    input wire sampled_bit,
    output reg strt_glitch
);

    // Start Bit Check Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            strt_glitch <= 1'b0;
        else
            strt_glitch <= strt_chk_en & sampled_bit;
    end
endmodule