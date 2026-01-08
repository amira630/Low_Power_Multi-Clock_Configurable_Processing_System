module Edge_Bit_Counter(
    input wire       clk,
    input wire       rst_n,
    input wire       enable,
    input wire [5:0] Prescale,
    output reg [4:0] edge_cnt,
    output reg [3:0] bit_cnt
);

    // Edge Bit Counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_cnt <= 5'd0;
            bit_cnt <= 4'd0;
        end else if (enable) begin
            if (edge_cnt == (Prescale - 1'b1)) begin
                edge_cnt <= 5'd0;
                bit_cnt <= bit_cnt + 4'd1;
            end
            else
                edge_cnt <= edge_cnt + 5'd1;
        end else begin
            edge_cnt <= 5'd0;
            bit_cnt <= 4'd0;
        end
    end
endmodule