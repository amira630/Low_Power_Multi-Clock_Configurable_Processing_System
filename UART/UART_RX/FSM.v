module FSM(
    input wire        clk,
    input wire        rst_n,
    input wire        RX_IN,
    input wire        Par_En,
    input wire [4:0]  edge_cnt,
    input wire [3:0]  bit_cnt,
    input wire        par_err,
    input wire        strt_glitch,
    input wire        stp_err,
    output wire       Data_Valid,
    output wire       deser_en,
    output wire       data_samp_en,
    output wire       enable,
    output wire       par_chk_en,
    output wire       strt_chk_en,
    output wire       stp_chk_en
);

    // State Encoding
    localparam [2:0] IDLE      = 3'b000, // 0
                     START_BIT = 3'b001, // 1
                     DATA_BITS = 3'b011, // 3
                     PARITY_BIT= 3'b010, // 2
                     STOP_BIT  = 3'b110; // 6

    reg [2:0] current_state, next_state;

    // State Transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        Capture = 1'b0;
        case (current_state)
            IDLE: begin
                
            end
            START_BIT: begin

            end
            DATA_BITS: begin

            end
            PARITY_BIT:begin

            end
            STOP_BIT: begin
                
            end
            default: next_state = IDLE;
        endcase
    end
endmodule