module ALU #(DATA_WIDTH = 8, OP_CODE = 4) (
    input wire                       clk,
    input wire                       rst_n,
    input wire [DATA_WIDTH-1:0]      A,
    input wire [DATA_WIDTH-1:0]      B,
    input wire [OP_CODE-1:0]         ALU_FUNC,
    input wire                       Enable,
    output reg [(DATA_WIDTH<<1)-1:0] ALU_OUT,
    output reg                       OUT_VALID
);

    // ALU operation codes
    localparam ADD      = 4'b0000;
    localparam SUB      = 4'b0001;
    localparam MULT     = 4'b0010;
    localparam DIV      = 4'b0011;
    localparam AND      = 4'b0100;
    localparam OR       = 4'b0101;
    localparam NAND     = 4'b0110;
    localparam NOR      = 4'b0111;
    localparam XOR      = 4'b1000;
    localparam XNOR     = 4'b1001;
    localparam CMP_EQ   = 4'b1010;
    localparam CMP_GT   = 4'b1011;
    localparam CMP_LT   = 4'b1100;
    localparam SHIFT_RT = 4'b1101;
    localparam SHIFT_LT = 4'b1110;

    reg [(DATA_WIDTH<<1)-1:0] ALU_OUT_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ALU_OUT   <= {(DATA_WIDTH<<1){1'b0}};
            OUT_VALID <= 1'b0;
        end else begin
            if (Enable)
                ALU_OUT <= ALU_OUT_reg;
            OUT_VALID <= Enable;
        end 
    end

    always @(*) begin
        case (ALU_FUNC)
            ADD:      ALU_OUT_reg = A + B;
            SUB:      ALU_OUT_reg = A - B;
            MULT:     ALU_OUT_reg = A * B;
            DIV:      if (B != 0) ALU_OUT_reg = A / B; else ALU_OUT_reg = 'b0;
            AND:      ALU_OUT_reg = A & B;
            OR:       ALU_OUT_reg = A | B;
            NAND:     ALU_OUT_reg = ~(A & B);
            NOR:      ALU_OUT_reg = ~(A | B);
            XOR:      ALU_OUT_reg = A ^ B;
            XNOR:     ALU_OUT_reg = ~(A ^ B);
            CMP_EQ:   if (A == B) ALU_OUT_reg = 'b1; else ALU_OUT_reg = 'b0;
            CMP_GT:   if (A > B) ALU_OUT_reg = 'b1; else ALU_OUT_reg = 'b0;
            CMP_LT:   if (A < B) ALU_OUT_reg = 'b1; else ALU_OUT_reg = 'b0;
            SHIFT_RT: ALU_OUT_reg = A >> 1;
            SHIFT_LT: ALU_OUT_reg = A << 1;
            default:  ALU_OUT_reg = {DATA_WIDTH{1'b0}};
        endcase
    end
endmodule