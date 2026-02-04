module CLK_GATE (
    input wire clk,
    input wire clk_en,
    output reg gated_clk
);

    reg q;

    always @(clk or clk_en) begin
        if(!clk)
            q <= clk_en; // active low latch for +ve edge clock gating
    end

    always @(*) begin
        gated_clk = clk & q;
    end
endmodule