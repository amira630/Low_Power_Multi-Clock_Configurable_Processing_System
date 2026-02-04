module Dual_Port_RAM #(DATA_WIDTH = 8, ADDR_WIDTH = 3, DATA_DEPTH = 8) (
    input wire                       wclk,
    input wire                       wrst_n,
    input wire                       we,
    input wire [ADDR_WIDTH-1:0]      waddr,
    input wire [DATA_WIDTH-1:0]      wdata,
    input wire [ADDR_WIDTH-1:0]      raddr,
    output reg [DATA_WIDTH-1:0]      rdata
);

    integer i;

    // Memory Declaration
    reg [DATA_WIDTH-1:0] mem [DATA_DEPTH-1:0];

    // Fast Clock Domain Operations (Write)
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            for (i = 0; i < DATA_DEPTH; i = i + 1)
                mem[i] <= {DATA_WIDTH{1'b0}};
        end else if (we)
                mem[waddr] <= wdata;
    end

    // Slow Clock Domain Operations (Read)
    always @(*) begin
        rdata = mem[raddr];
    end
endmodule