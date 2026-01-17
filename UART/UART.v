module UART(
    input wire        TX_CLK,
    input wire        RX_CLK,
    input wire        rst_n,
    // Configuration
    input wire        Par_En,
    input wire        Par_Typ, // 0: Even, 1: Odd
    input wire  [5:0] Prescale,
    // UART RX Interface
    input wire        RX_IN_S,
    output wire [7:0] RX_OUT_P,
    output wire       RX_OUT_V,
    output wire       PAR_Err,
    output wire       STP_Err,
    // UART TX Interface
    input wire [7:0]  TX_IN_P,
    input wire        TX_IN_V,
    output wire       TX_OUT_S,
    output wire       TX_OUT_V
);

UART_TX TX_U0(
    .clk(TX_CLK),
    .rst_n(rst_n),
    .P_DATA(TX_IN_P),
    .Data_Valid(TX_IN_V),
    .Par_En(Par_En),
    .Par_Typ(Par_Typ), // 0: Even, 1: Odd
    .TX_OUT(TX_OUT_S),
    .Busy(TX_OUT_V)
);

UART_RX RX_U1(
    .clk(RX_CLK),
    .rst_n(rst_n),
    .RX_IN(RX_IN_S),
    .Prescale(Prescale),
    .Par_En(Par_En),
    .Par_Typ(Par_Typ), // 0: Even, 1: Odd
    .P_DATA(RX_OUT_P),
    .Data_Valid(RX_OUT_V),
    .PAR_Err(PAR_Err),
    .STP_Err(STP_Err)
);

endmodule