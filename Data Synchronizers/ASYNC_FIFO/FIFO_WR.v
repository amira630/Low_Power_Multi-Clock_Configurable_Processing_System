module FIFO_WR #(ADDR_WIDTH = 3) (
    input wire                  clk,
    input wire                  rst_n,
    input wire                  inc,
    input wire [ADDR_WIDTH:0]   rptr,
    output reg [ADDR_WIDTH-1:0] addr,
    output reg [ADDR_WIDTH:0]   wptr,
    output reg                  full
);

    reg [ADDR_WIDTH:0] ptr, gray_ptr;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wptr <= 'b0;
            ptr <= 'b0;
        end else begin
            if(inc && !full)
                ptr <= ptr + 1;
            wptr <= gray_ptr;
        end
    end

    always @(*) begin
        addr = ptr[ADDR_WIDTH-1:0];
        gray_ptr = ptr ^ (ptr >> 1);
        if ((rptr[3] != gray_ptr[3]) && (rptr[2] != gray_ptr[2]) && (rptr[1:0]==gray_ptr[1:0]))
            full = 1'b1;
        else
            full = 1'b0;
    end
endmodule