module FSM(
    input wire       clk,
    input wire       rst_n,
    input wire       RX_IN,
    input wire       Par_En,
    input wire [5:0] Prescale,
    input wire [4:0] edge_cnt,
    input wire [3:0] bit_cnt,
    input wire       par_err,
    input wire       strt_glitch,
    input wire       stp_err,
    output reg       Data_Valid,
    output reg       deser_en,
    output reg       dat_samp_en,
    output reg       enable,
    output reg       par_chk_en,
    output reg       strt_chk_en,
    output reg       stp_chk_en
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
        // Default Outputs
        strt_chk_en = 1'b0;
        par_chk_en  = 1'b0;
        stp_chk_en  = 1'b0;
        deser_en    = 1'b0;
        dat_samp_en = 1'b1;
        enable      = 1'b1;
        Data_Valid  = 1'b0;
        
        case (current_state)
            IDLE: begin
                dat_samp_en = 1'b0;
                enable      = 1'b0;
                if (!RX_IN) 
                    next_state = START_BIT;
                else 
                    next_state = IDLE;
            end
            START_BIT: begin
                if (edge_cnt == (Prescale>>1)) begin
                    strt_chk_en = 1'b1;
                end else if (bit_cnt == 4'd1) begin
                    next_state = DATA_BITS;
                end
                else
                    next_state = START_BIT;
            end
            DATA_BITS: begin
                deser_en    = 1'b1;
                if (bit_cnt == 4'd9) begin
                    if (Par_En)
                        next_state = PARITY_BIT;
                    else
                        next_state = STOP_BIT;
                end
                else
                    next_state = DATA_BITS;
            end
            PARITY_BIT:begin
                if (edge_cnt == (Prescale>>1)) begin
                    par_chk_en = 1'b1;
                end else if (bit_cnt == 4'd10) 
                    next_state = STOP_BIT;
                else
                    next_state = PARITY_BIT;
            end
            STOP_BIT: begin
                if (edge_cnt == (Prescale>>1)) begin
                    stp_chk_en = 1'b1;
                end else if ((bit_cnt == 4'd11 && Par_En) || (bit_cnt == 4'd10 && !Par_En)) begin
                    next_state = IDLE;
                    Data_Valid  = 1'b1;
                end else
                    next_state = STOP_BIT;
            end
            default: next_state = IDLE;
        endcase
        if (strt_glitch | stp_err | par_err) 
            next_state  = IDLE;
    end
endmodule