module UART_RX(
    input wire        clk,
    input wire        rst_n,
    input wire        RX_IN,
    input wire  [5:0] Prescale,
    input wire        Par_En,
    input wire        Par_Typ, // 0: Even, 1: Odd
    output wire [7:0] P_DATA,
    output wire       Data_Valid,
    output wire       Par_Error,
    output wire       Stop_Error
);

endmodule