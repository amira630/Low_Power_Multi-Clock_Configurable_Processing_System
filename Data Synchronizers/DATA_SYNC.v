module DATA_SYNC # (NUM_STAGES = 2, BUS_WIDTH = 8) (
    input wire                  clk,
    input wire                  rst_n,
    input wire [BUS_WIDTH-1:0]  unsync_bus,
    input wire                  bus_enable,
    output reg [BUS_WIDTH-1:0]  sync_bus,
    output reg                  enable_pulse_d
);

    //internal connections
    reg   [NUM_STAGES-1:0]    en;
    reg                       prev_en;
    wire                      enable;
                        
    //----------------- Multi flop synchronizer --------------

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            en <= 'b0 ;
        else
            en <= {en[NUM_STAGES-2:0], bus_enable};
    end

    //----------------- pulse generator --------------------

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            prev_en <= 1'b0 ;	
        else
            prev_en <= en[NUM_STAGES-1];
    end

    always @(*) begin
        enable = en[NUM_STAGES-1] && !prev_en;
    end

    //----------- destination domain flop ---------------

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)     
            sync_bus <= 'b0 ;	
        else begin
            if (enable)
                sync_bus <= unsync_bus;
            else
                sync_bus <= sync_bus;
        end
    end
    
    //--------------- delay generated pulse ------------

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)     
            enable_pulse_d <= 1'b0;	
        else
            enable_pulse_d <= enable;
    end

endmodule