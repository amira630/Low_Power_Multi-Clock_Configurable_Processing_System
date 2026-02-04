module CLK_DIV #(DATA_WIDTH = 8) (
    input wire i_ref_clk,
    input wire i_rst_n,
    input wire i_clk_en,
    input wire [DATA_WIDTH-1:0] i_div_ratio,
    output reg o_div_clk
);

    reg [DATA_WIDTH-2:0] counter, half_ratio;
    reg div_clk;

    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            div_clk <= 1'b0;
            counter <= 'd0;
        end else begin
            if ((i_div_ratio == 0) | (i_div_ratio == 1) | !i_clk_en) begin
                div_clk <= 1'b0;
                counter <= 'd0;
            end else if (i_clk_en) begin
                if (!i_div_ratio[0]) begin // Even Division Ratio
                    if (counter < (half_ratio - 1))
                        counter <= counter + 1;
                    else begin
                        counter <= 'd0;
                        div_clk <= ~div_clk; 
                    end
                end else begin // Odd Division Ratio
                    if ((counter == (half_ratio - 1)) | (counter == (i_div_ratio - 1)))
                        div_clk <= ~div_clk; 
                    if (counter == (i_div_ratio - 1))
                        counter <= 'd0;
                    else
                        counter <= counter + 1;
                end
            end
        end
    end

    always @(*) begin
        half_ratio = (i_div_ratio >> 1);
        if (i_clk_en) begin
            if (i_div_ratio == 1) 
                o_div_clk = i_ref_clk;
            else
                o_div_clk = div_clk;
        end else
            o_div_clk = i_ref_clk;
    end
endmodule