module Data_Sampling(
    input wire       clk,
    input wire       rst_n,
    input wire       RX_IN,
    input wire       dat_samp_en,
    input wire [5:0] Prescale,
    input wire [4:0] edge_cnt,
    output reg       sampled_bit
);
    reg [1:0] data_temp;

    // Data Sampling Enable Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_temp <= 2'b11;
            sampled_bit <= 1'b1;
        end else if (dat_samp_en) begin
            if (edge_cnt == ((Prescale>>1)-2)) 
                data_temp[0] <= RX_IN;
            else if (edge_cnt == ((Prescale>>1)-1)) 
                data_temp[1] <= RX_IN;
            else if (edge_cnt == (Prescale>>1)) 
                sampled_bit <= (data_temp[0] & data_temp[1]) | (RX_IN & (data_temp[0] | data_temp[1])); // Majority Voting
        end
        else begin
            data_temp <= 2'b11;
            sampled_bit <= 1'b1;
        end
    end
    
endmodule