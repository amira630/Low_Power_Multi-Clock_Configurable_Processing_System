module BIT_SYNC #(BUS_WIDTH = 1, NUM_STAGES = 2) (
    input wire                 CLK,
    input wire                 RST,
    input wire [BUS_WIDTH-1:0] ASYNC,
    output reg [BUS_WIDTH-1:0] SYNC
);

    reg [BUS_WIDTH-1:0] sync_regs [0: NUM_STAGES-1];

    integer j;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            for (j = 0; j < NUM_STAGES; j = j + 1) 
                sync_regs[j] <= 'b0;
        end else begin
            sync_regs[0] <= ASYNC;
            for (j = 1; j < NUM_STAGES; j = j + 1) 
                sync_regs[j] <= sync_regs[j-1];
        end    
    end
    always @(*) begin
        SYNC = sync_regs[NUM_STAGES-1];
    end
endmodule