module FIFO_RD #(ADDR_WIDTH = 3) (
    input wire                  clk,
    input wire                  rst_n,
    input wire                  inc,
    input wire [ADDR_WIDTH:0]   wptr,
    output reg [ADDR_WIDTH-1:0] addr,
    output reg [ADDR_WIDTH:0]   rptr,
    output reg                  empty
);

    reg [ADDR_WIDTH:0] ptr, gray_ptr;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rptr <= 'b0;
            ptr <= 'b0;
        end else begin
            if(inc && !empty) 
                ptr <= ptr + 1;
            rptr <= gray_ptr;
        end
    end

    always @(*) begin
        addr = ptr[ADDR_WIDTH-1:0];
        gray_ptr = ptr ^ (ptr >> 1);
        if (wptr == gray_ptr)
            empty = 1'b1;
        else
            empty = 1'b0;
    end
endmodule