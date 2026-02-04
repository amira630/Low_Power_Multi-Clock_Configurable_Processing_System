module RST_SYNC #(ACTIVE = 0, NUM_STAGES = 2) (
    input wire clk,
    input wire rst,
    output reg sync_rst
);

    //internal connections
    reg [NUM_STAGES-1:0] rst_sync;
                        
    //----------------- Double flop synchronizer --------------

    generate
        if (!ACTIVE) begin : ACTIVE_LOW
            always @(posedge clk or negedge rst) begin
                if(!rst)
                    rst_sync <= 1'b0 ;
                else
                    rst_sync <= {rst_sync[NUM_STAGES-2:0], 1'b1};
            end
        end else begin : ACTIVE_HIGH
            always @(posedge clk or posedge rst) begin
                if(rst)
                    rst_sync <= 1'b1 ;
                else
                    rst_sync <= {rst_sync[NUM_STAGES-2:0], 1'b0};
            end
        end
    endgenerate

    always @(*) begin
        sync_rst = rst_sync[NUM_STAGES-1];
    end
endmodule