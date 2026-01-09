module Deserializer(
    input wire       clk,
    input wire       rst_n,
    input wire       deser_en,
    input wire       sampled_bit,
    output reg [7:0] P_DATA
);

    // Deserialization Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            P_DATA <= 8'b0;
        end else if (deser_en) begin
            P_DATA <= {sampled_bit, P_DATA[7:1]};
        end
    end

endmodule