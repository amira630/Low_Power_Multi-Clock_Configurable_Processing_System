module FSM_RX(
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
    reg [3:0] bit_count;
    reg parity_error_flag, stop_error_flag;

    // State Transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            parity_error_flag <= 1'b0;
            stop_error_flag   <= 1'b0;
        end else begin
            current_state <= next_state;
            if (edge_cnt == ((Prescale>>1)+2)) begin
                if (current_state == STOP_BIT)
                    stop_error_flag <= stp_err;
                if (current_state == PARITY_BIT)
                    parity_error_flag <= par_err;
            end else if (current_state == IDLE) begin
                parity_error_flag <= 1'b0;
                stop_error_flag   <= 1'b0;
            end
        end
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
                if (!RX_IN && (edge_cnt == 'b0)) 
                    next_state = START_BIT;
                else begin
                    dat_samp_en = 1'b0;
                    enable      = 1'b0;
                    next_state = IDLE;
                end
                bit_count = 1'b0;
            end
            START_BIT: begin
                if (edge_cnt == ((Prescale>>1)+1))
                    strt_chk_en = 1'b1;
                else if (bit_cnt == 4'd1) 
                    next_state = DATA_BITS;
                else
                    next_state = START_BIT;
                bit_count   = 1'b0;
            end
            DATA_BITS: begin
                if (bit_count != bit_cnt) begin
                    deser_en    = 1'b1;
                    bit_count   = bit_cnt;
                end
                if (bit_cnt == 4'd9) begin
                    if (Par_En)
                        next_state = PARITY_BIT;
                    else
                        next_state = STOP_BIT;
                end else
                    next_state = DATA_BITS;
            end
            PARITY_BIT:begin
                if (edge_cnt == ((Prescale>>1)+1))
                    par_chk_en = 1'b1;
                else if (edge_cnt == 4'd0) 
                    next_state = STOP_BIT;
                else
                    next_state = PARITY_BIT;
                bit_count   = 1'b0;
            end
            STOP_BIT: begin
                if (edge_cnt == ((Prescale>>1)+1))
                    stp_chk_en = 1'b1;
                else if (edge_cnt == (Prescale-2)) begin
                    next_state = IDLE;
                    if (!parity_error_flag && !stop_error_flag)
                        Data_Valid = 1'b1;
                end else
                    next_state = STOP_BIT;
                bit_count   = 1'b0;
            end
            default: begin next_state = IDLE; bit_count = 1'b0; end
        endcase
        if (strt_glitch) begin
            next_state  = IDLE;
            dat_samp_en = 1'b0;
            enable      = 1'b0;
            Data_Valid  = 1'b0;
        end
    end
endmodule