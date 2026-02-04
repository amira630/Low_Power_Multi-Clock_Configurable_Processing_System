module Reg_File #(ADDR_WIDTH = 4, DATA_WIDTH = 8) (
    input wire                  clk,
    input wire                  rst_n,
    input wire [ADDR_WIDTH-1:0] Address,
    input wire                  WrEn,
    input wire                  RdEn,
    input wire [DATA_WIDTH-1:0] WrData,
    output reg [DATA_WIDTH-1:0] RdData,
    output reg                  RdData_Valid,
    output reg [DATA_WIDTH-1:0] REG0,   // ALU Operand A
    output reg [DATA_WIDTH-1:0] REG1,   // ALU Operand B
    output reg [DATA_WIDTH-1:0] REG2,   // UART Config
    output reg [DATA_WIDTH-1:0] REG3    // Div Ratio
);

    reg [DATA_WIDTH-1:0] REG4_15 [(1<<ADDR_WIDTH)-5:0]; // Registers 4 to 15

    reg [3:0] i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            REG0 <= {DATA_WIDTH{1'b0}};
            REG1 <= {DATA_WIDTH{1'b0}};
            REG2 <= 100000_01; // Default UART Config: 32 Prescaler, Even Parity, Parity Enabled
            REG3 <= 100000_00; // Default Div Ratio: 32
            RdData <= {DATA_WIDTH{1'b0}};
            RdData_Valid <= 1'b0;
            for (i = 0; i < ((1<<ADDR_WIDTH) - 4); i = i + 1) begin
                REG4_15[i] <= {DATA_WIDTH{1'b0}};
            end
        end else begin
            // Write Operation
            if (WrEn) begin
                case (Address)
                    'd0: REG0 <= WrData;
                    'd1: REG1 <= WrData;
                    'd2: REG2 <= WrData;
                    'd3: REG3 <= WrData;
                    'd4: REG4_15[0] <= WrData;
                    'd5: REG4_15[1] <= WrData;
                    'd6: REG4_15[2] <= WrData;
                    'd7: REG4_15[3] <= WrData;
                    'd8: REG4_15[4] <= WrData;
                    'd9: REG4_15[5] <= WrData;
                    'd10: REG4_15[6] <= WrData;
                    'd11: REG4_15[7] <= WrData;
                    'd12: REG4_15[8] <= WrData;
                    'd13: REG4_15[9] <= WrData;
                    'd14: REG4_15[10] <= WrData;
                    'd15: REG4_15[11] <= WrData;
                endcase
            end
            // Read Operation
            if (RdEn) begin
                RdData_Valid <= 1'b1;
                case (Address)
                    'd0: RdData <= REG0;
                    'd1: RdData <= REG1;
                    'd2: RdData <= REG2;
                    'd3: RdData <= REG3;
                    'd4: RdData <= REG4_15[0];
                    'd5: RdData <= REG4_15[1];      
                    'd6: RdData <= REG4_15[2];
                    'd7: RdData <= REG4_15[3];
                    'd8: RdData <= REG4_15[4];
                    'd9: RdData <= REG4_15[5];
                    'd10: RdData <= REG4_15[6];
                    'd11: RdData <= REG4_15[7];
                    'd12: RdData <= REG4_15[8];
                    'd13: RdData <= REG4_15[9];
                    'd14: RdData <= REG4_15[10];
                    'd15: RdData <= REG4_15[11];
                endcase
            end else
                RdData_Valid <= 1'b0;
        end
    end
endmodule