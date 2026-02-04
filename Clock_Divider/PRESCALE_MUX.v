module PRESCALE_MUX #(DATA_WIDTH = 8) (
    input wire clk,
    input wire rst_n,
    input wire [5:0] PRESCALE,
    output reg [DATA_WIDTH-1:0] DIV_RATIO
);

    always @(posedge clk or negedge rst_n) begin
        case (PRESCALE)
            6'd4: DIV_RATIO <= 8'd8;
            6'd8: DIV_RATIO <= 8'd4;
            6'd16: DIV_RATIO <= 8'd2;
            6'd32: DIV_RATIO <= 8'd1;
            default: DIV_RATIO <= 8'd1;
        endcase
    end

endmodule