module SYS_CTRL #(DATA_WIDTH = 8, OP_CODE = 4, ADDR_WIDTH = 4) (
    input wire clk,
    input wire rst_n,
    // ALU Signals
    input wire [(DATA_WIDTH<<1)-1:0] ALU_OUT,
    input wire                       OUT_VALID,
    output reg [OP_CODE-1:0]         ALU_FUNC,
    output reg                       Enable,
    output reg                       CLK_EN,
    // Register File Signals
    input wire [DATA_WIDTH-1:0] RdData,
    input wire                  RdData_Valid,
    output reg [ADDR_WIDTH-1:0] Address,
    output reg                  WrEn,
    output reg                  RdEn,
    output reg [DATA_WIDTH-1:0] WrData,
    // Data_sync (UART RX) Signals
    input wire [DATA_WIDTH-1:0] RX_P_DATA,
    input wire                  RX_D_VLD,
    // Async_fifo (UART TX) Signals
    output reg [DATA_WIDTH-1:0] TX_P_DATA,
    output reg                  TX_D_VLD,

    output reg                  clk_div_en,
    // ASYNC FIFO Signals
    input wire                  fifo_full
);

    reg [2:0] current_state, next_state;
    reg [ADDR_WIDTH-1:0] Address_reg;
    reg ALU_Result_Wait;

    // FSM States
    localparam IDLE         = 3'b000,
               READ_ADDR_R  = 3'b001,
               READ_ADDR_W  = 3'b011,
               READ_DATA    = 3'b010,
               READ_OP_A    = 3'b110,
               READ_OP_B    = 3'b111,
               READ_ALU_FUN = 3'b101;

    // Command Definitions
    localparam RF_Wr_CMD          = 8'hAA, // Register File Write Command
               RF_Rd_CMD          = 8'hBB, // Register File Read
               ALU_OPER_W_OP_CMD  = 8'hCC, // ALU Operation with Operands Command
               ALU_OPER_W_NOP_CMD = 8'hDD; // ALU Operation with No Operands Command
    // System Control Logic Here

    // FSM Sequential Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            current_state <= IDLE;
            Address_reg <= 'b0;
            ALU_Result_Wait <= 1'b0;
        end else begin
            current_state <= next_state;
            if ((current_state == READ_ADDR_W) && RX_D_VLD) 
                Address_reg <= RX_P_DATA;
            else if (current_state == READ_ALU_FUN)
                ALU_Result_Wait <= 1'b1;
            else if (OUT_VALID)
                ALU_Result_Wait <= 1'b0;
        end
    end

    // FSM Combinational Logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (RX_D_VLD) begin
                    case (RX_P_DATA)
                        RF_Wr_CMD: next_state = READ_ADDR_W;
                        RF_Rd_CMD: next_state = READ_ADDR_R;
                        ALU_OPER_W_OP_CMD: next_state = READ_OP_A;
                        ALU_OPER_W_NOP_CMD: next_state = READ_ALU_FUN;
                        default: next_state = IDLE;
                    endcase
                end else begin
                    next_state = IDLE;
                end
            end
            READ_ADDR_W: begin
                if (RX_D_VLD)
                    next_state = READ_DATA;
                else
                    next_state = READ_ADDR_W;
            end
            READ_ADDR_R: begin
                if (RX_D_VLD)
                    next_state = IDLE;
                else
                    next_state = READ_ADDR_R;
            end
            READ_DATA: begin
                if (RX_D_VLD)
                    next_state = IDLE;
                else
                    next_state = READ_DATA;
            end
            READ_OP_A: begin
                if (RX_D_VLD)
                    next_state = READ_OP_B;
                else
                    next_state = READ_OP_A;
            end
            READ_OP_B: begin
                if (RX_D_VLD)
                    next_state = READ_ALU_FUN;
                else
                    next_state = READ_OP_B;
            end
            READ_ALU_FUN: begin
                if (RX_D_VLD)
                    next_state = IDLE;
                else
                    next_state = READ_ALU_FUN;
            end
        endcase
    end

    // Output Logic
    always @(*) begin
        ALU_FUNC  = 'b0;
        Enable    = 'b0;
        CLK_EN    = 'b0;
        Address   = 'b0;
        WrEn      = 'b0;
        RdEn      = 'b0;
        WrData    = 'b0;
        clk_div_en = 1'b1;
        case (current_state)
            // IDLE: begin
            //     // No operation
            //     if(RX_D_VLD && (RX_P_DATA == RF_Rd_CMD))
            //         CLK_EN = 1'b1;
            // end
            READ_ADDR_R: begin
                if (RX_D_VLD) begin
                    Address = RX_P_DATA;
                    RdEn = 1'b1;
                end
            end
            READ_DATA: begin
                if (RX_D_VLD) begin
                    Address = Address_reg;
                    WrData = RX_P_DATA;
                    WrEn = 1'b1;
                end 
            end
            READ_OP_A: begin
                if (RX_D_VLD) begin
                    Address = 'd0; // REG0
                    WrData = RX_P_DATA;
                    WrEn = 1'b1;
                end
            end
            READ_OP_B: begin
                if (RX_D_VLD) begin
                    Address = 'd1; // REG1
                    WrData = RX_P_DATA;
                    WrEn = 1'b1;
                end
            end
            READ_ALU_FUN: begin
                if (RX_D_VLD) begin
                    ALU_FUNC = RX_P_DATA;
                    Enable = 1'b1;
                end
            end
        endcase
        if (ALU_Result_Wait) begin
            CLK_EN = 1'b1;
        end
    end

    always @(*) begin
        TX_P_DATA = 'b0;
        TX_D_VLD  = 1'b0;
        if (!fifo_full) begin
            if (RdData_Valid) 
                TX_P_DATA = RdData;
            else if (OUT_VALID) 
                TX_P_DATA = ALU_OUT;
            TX_D_VLD  = RdData_Valid | OUT_VALID;
        end
    end
endmodule