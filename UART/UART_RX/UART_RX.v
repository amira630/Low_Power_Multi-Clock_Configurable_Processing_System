module UART_RX(
    input wire        clk,
    input wire        rst_n,
    input wire        RX_IN,
    input wire  [5:0] Prescale,
    input wire        Par_En,
    input wire        Par_Typ, // 0: Even, 1: Odd
    output wire [7:0] P_DATA,
    output wire       Data_Valid,
    output wire       PAR_Err,
    output wire       STP_Err
);

    wire [4:0] edge_cnt;
    wire       deser_en,
               dat_samp_en,
               enable,
               par_chk_en,
               strt_chk_en,
               stp_chk_en,
               strt_glitch,
               sampled_bit;
    wire [3:0] bit_cnt;


    FSM_RX FSM_U1 (
        .clk         (clk),
        .rst_n       (rst_n),
        .RX_IN       (RX_IN),
        .Par_En      (Par_En),
        .Prescale    (Prescale),    // Not in block diagram
        .edge_cnt    (edge_cnt),
        .bit_cnt     (bit_cnt),
        .par_err     (PAR_Err),
        .strt_glitch (strt_glitch),
        .stp_err     (STP_Err),
        .Data_Valid  (Data_Valid),
        .deser_en    (deser_en),
        .dat_samp_en (dat_samp_en),
        .enable      (enable),
        .par_chk_en  (par_chk_en),
        .strt_chk_en (strt_chk_en),
        .stp_chk_en  (stp_chk_en)
    );

    Edge_Bit_Counter EBC_U1 (
        .clk      (clk),
        .rst_n    (rst_n),
        .enable   (enable),
        .Prescale (Prescale),       // Not in block diagram
        .edge_cnt (edge_cnt),
        .bit_cnt  (bit_cnt)
    );

    Data_Sampling DS_U2 (
        .clk         (clk),
        .rst_n       (rst_n),
        .RX_IN       (RX_IN),
        .dat_samp_en (dat_samp_en),
        .Prescale    (Prescale),
        .edge_cnt    (edge_cnt),
        .sampled_bit (sampled_bit)
    );

    Parity_Check PC_U3 (
        .clk         (clk),
        .rst_n       (rst_n),
        .par_chk_en  (par_chk_en),
        .Par_Typ     (Par_Typ),
        .P_DATA      (P_DATA),      // Not in block diagram
        .sampled_bit (sampled_bit),
        .par_err     (PAR_Err)
    );

    Start_Check SC_U4 (
        .clk          (clk),
        .rst_n        (rst_n),
        .strt_chk_en  (strt_chk_en),
        .sampled_bit  (sampled_bit),
        .strt_glitch  (strt_glitch)
    );

    Stop_Check STPC_U5 (
        .clk          (clk),
        .rst_n        (rst_n),
        .stp_chk_en   (stp_chk_en),
        .sampled_bit  (sampled_bit),
        .stp_err      (STP_Err)
    );

    Deserializer DESER_U6 (
        .clk         (clk),
        .rst_n       (rst_n),
        .deser_en    (deser_en),
        .sampled_bit (sampled_bit),
        .P_DATA      (P_DATA)
    );
endmodule