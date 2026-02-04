module ASYNC_FIFO #(ADDR_WIDTH = 3, DATA_WIDTH = 8) (
    input wire wclk,
    input wire wrst_n,
    input wire winc,
    input wire [DATA_WIDTH-1:0] wdata,
    output wire wfull,

    input wire rclk,
    input wire rrst_n,
    input wire rinc,
    output wire [DATA_WIDTH-1:0] rdata,
    output wire rempty
);

    wire [ADDR_WIDTH:0] wptr, sync_wptr;
    wire [ADDR_WIDTH:0] rptr, sync_rptr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire [ADDR_WIDTH-1:0] waddr;

    Dual_Port_RAM #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .DATA_DEPTH(8)) RAM_U0 (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .we(winc & !wfull),
        .waddr(waddr),
        .wdata(wdata),
        .raddr(raddr),
        .rdata(rdata)
    );

    FIFO_WR #(.ADDR_WIDTH(ADDR_WIDTH)) WR_U1 (
        .clk(wclk),
        .rst_n(wrst_n),
        .inc(winc),
        .rptr(sync_rptr),
        .addr(waddr),
        .wptr(wptr),
        .full(wfull)
    );

    FIFO_RD #(.ADDR_WIDTH(ADDR_WIDTH)) RD_U2 (
        .clk(rclk),
        .rst_n(rrst_n),
        .inc(rinc),
        .wptr(sync_wptr),
        .addr(raddr),
        .rptr(rptr),
        .empty(rempty)
    );

    BIT_SYNC #(.BUS_WIDTH(ADDR_WIDTH+1), .NUM_STAGES(2)) W_SYNC_U3 (
        .CLK(rclk),
        .RST(rrst_n),
        .ASYNC(wptr),
        .SYNC(sync_wptr)
    );

    BIT_SYNC #(.BUS_WIDTH(ADDR_WIDTH+1), .NUM_STAGES(2)) R_SYNC_U4 (
        .CLK(wclk),
        .RST(wrst_n),
        .ASYNC(rptr),
        .SYNC(sync_rptr)
    );

endmodule