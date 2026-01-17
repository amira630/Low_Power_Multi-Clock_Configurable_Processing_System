module Edge_Bit_Counter(
    input wire       clk,
    input wire       rst_n,
    input wire       enable,
    input wire [5:0] Prescale,
    output reg [4:0] edge_cnt,
    output reg [3:0] bit_cnt
);

    reg first_edge, enable_reg;

    // Edge Bit Counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_reg <= 1'b1;
            edge_cnt <= 5'd0;
            bit_cnt <= 4'd0;
            first_edge <= 1'b1;
        end else if (enable) begin
            enable_reg <= 1'b1;
            if (edge_cnt == (Prescale - 1'b1)) begin
                edge_cnt <= 5'd0;
                bit_cnt <= bit_cnt + 4'd1;
            end
            else if (first_edge) begin
                first_edge <= 1'b0;
                edge_cnt <= 5'd0;
            end else
                edge_cnt <= edge_cnt + 5'd1;
        end else begin
            if (!enable_reg)
                first_edge <= 1'b1;
            enable_reg <= 1'b0;
            edge_cnt <= 5'd0;
            bit_cnt <= 4'd0;
        end
    end
endmodule