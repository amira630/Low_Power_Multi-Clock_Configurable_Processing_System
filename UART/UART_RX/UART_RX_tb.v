`timescale 1ns/1fs
module UART_RX_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter PRESCALE = 8; // Prescale value
    parameter CLOCK_FREQ_TX = 115.2; // Clock frequency in KHz
    parameter CLOCK_PERIOD_TX = 1000/CLOCK_FREQ_TX; // Transmission Clock period in ns
    parameter CLOCK_PERIOD = 1000/(CLOCK_FREQ_TX * PRESCALE); // Receiver Clock period in ns
    integer correct, error;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    reg clk_TX;

    reg        clk_tb, rst_n_tb;
    reg        RX_IN_tb;
    reg  [5:0] Prescale_tb;
    reg        Par_En_tb, Par_Typ_tb; // 0: Even, 1: Odd
    wire [7:0] P_DATA_tb;
    wire       Data_Valid_tb, PAR_Err_tb, STP_Err_tb;

    reg [7:0] data_temp;
    reg [2:0] error_type;
    reg [2:0] STAGE; // 0: Idle, 1: Start Bit, 2: Data Bits, 3: Parity Bit, 4: Stop Bit

    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    UART_RX DUT (
        .clk(clk_tb),
        .rst_n(rst_n_tb),
        .RX_IN(RX_IN_tb),
        .Prescale(Prescale_tb),
        .Par_En(Par_En_tb),
        .Par_Typ(Par_Typ_tb), // 0: Even, 1: Odd
        .P_DATA(P_DATA_tb),
        .Data_Valid(Data_Valid_tb),
        .PAR_Err(PAR_Err_tb),
        .STP_Err(STP_Err_tb)
    );

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(CLOCK_PERIOD_TX/2) clk_TX = ~clk_TX;

    always #(CLOCK_PERIOD/2) clk_tb = ~clk_tb;

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    initial begin
        // System Functions
        $dumpfile("UART_RX.vcd");
        $dumpvars;

        // initialization
        initialize();
        // check_out();

        $display("Start of Odd Parity Testing at %0t", $time);
        
        repeat(100) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b1, 3'b0); // Parity enabled, Odd Parity, no errors
            check_out(0);
        end

        $display("Start of Even Parity Testing at %0t", $time);

        repeat(100) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b0, 3'b0); // Parity enabled, Even Parity, no errors
            check_out(0); 
        end

        $display("Start of no Parity Testing at %0t", $time);
        
        repeat(100) begin
            @(negedge clk_tb);
            input_stimulus(1'b0, 1'b1, 3'b0); // Parity Disabled, Odd Parity, no errors
            check_out(0); 
        end

        repeat(100) begin
            @(negedge clk_tb);
            input_stimulus(1'b0, 1'b0, 3'b0); // Parity Disabled, Even Parity, no errors
            check_out(0); 
        end

        $display("Start of No Transmission Testing at %0t", $time);

        repeat(100 * PRESCALE) begin
            #(CLOCK_PERIOD);
            if (Data_Valid_tb || PAR_Err_tb || STP_Err_tb) begin
                $display("ERROR: Data Valid asserted incorrectly at time %0t during IDLE state", $time);
                error = error + 1;
            end
            else begin
                $display("Correctly remained idle at time %0t", $time);
                correct = correct + 1;
            end
        end
        $display("Start of Odd Parity Testing with issues at %0t", $time);
        
        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b1, 3'b10); // Parity enabled, Odd Parity, Stop error
            check_out(1); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b1, 3'b1); // Parity enabled, Odd Parity, Start error
            check_out(1); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b1, 3'b100); // Parity enabled, Odd Parity, Parity error
            check_out(1); 
        end

        $display("Start of Even Parity Testing with issues at %0t", $time);

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b0, 3'b1); // Parity enabled, Even Parity, Start error
            check_out(1); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b0, 3'b10); // Parity enabled, Even Parity, Stop error
            check_out(1); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b1, 1'b0, 3'b100); // Parity enabled, Even Parity, Parity error
            check_out(1); 
        end

        $display("Start of no Parity Testing with issues at %0t", $time);

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b0, 1'b1, 3'b1); // Parity Disabled, Odd Parity, Start error
            check_out(1); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b0, 1'b1, 3'b10); // Parity Disabled, Odd Parity, Stop error
            check_out(1); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b0, 1'b0, 3'b1); // Parity Disabled, Even Parity, Start error
            check_out(1); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            input_stimulus(1'b0, 1'b0, 3'b10); // Parity Disabled, Even Parity, Stop error
            check_out(1); 
        end

        $display("Start of Randomized Testing with random issues at %0t", $time);

        repeat(100) begin
            @(negedge clk_tb);
            error_type = $random;
            input_stimulus($random, $random, error_type); // Random Parity and Random Errors
            check_out(|error_type); 
        end

        #(20*CLOCK_PERIOD)
        $display("Simulation Ended with %0d correct and %0d errors", correct, error);
        $stop;
    end

    ////////////////////////////////////////////////////////
    /////////////////////// TASKS //////////////////////////
    ////////////////////////////////////////////////////////

    /////////////// Signals Initialization //////////////////

    task initialize;
        begin
            correct = 0;
            error = 0;
            STAGE = 3'b0;
            clk_TX  	= 1'b0;
            clk_tb  	= 1'b0;
            RX_IN_tb    = 1'b1; // Idle State
            Prescale_tb = PRESCALE;
            Par_En_tb   = 1'b0; // Parity Disabled
            Par_Typ_tb  = 1'b0; // Even Parity
            data_temp = 8'b0;
            error_type = 3'b0;
            reset();
        end	
    endtask

    ///////////////////////// RESET /////////////////////////

    task reset;
        begin
            rst_n_tb = 1'b1;
            @(negedge clk_tb)
            rst_n_tb = 1'b0;
            @(negedge clk_tb)
            rst_n_tb = 1'b1;
        end
    endtask

    ///////////////////////// RESET /////////////////////////

    task input_stimulus;
        input reg par_en, par_typ;
        input reg [2:0] errors_to_introduce; // [2] - Parity Error, [1] - Stop Bit Error, [0] - Start Bit Glitch
        begin
            @(negedge clk_TX);
            Par_En_tb = par_en;
            Par_Typ_tb = par_typ;
            STAGE = 3'b1; // Start Bit Stage
            if (errors_to_introduce[0]) begin
                RX_IN_tb = 1'b0; // Start Bit
                #(CLOCK_PERIOD*(PRESCALE/2)-1);
                RX_IN_tb = 1'b1; // Start Bit Glitch
            end
            else begin
                RX_IN_tb = 1'b0; // Start Bit
            end
            // Data Bits
            repeat (8) begin
                @(negedge clk_TX);
                if (errors_to_introduce[0])
                    RX_IN_tb = 1'b1;
                else
                    RX_IN_tb = $random;
                data_temp = {RX_IN_tb, data_temp[7:1]};
                STAGE = 3'd2; // Data Bits Stage
            end
            // Parity Bit
            if (par_en) begin
                @(negedge clk_TX);
                if (errors_to_introduce[2]) begin
                    RX_IN_tb = par_typ ? ^data_temp : ~(^data_temp); // Introduce Parity Error
                end
                else begin
                    RX_IN_tb = par_typ ? ~(^data_temp) : ^data_temp; // Odd or Even Parity
                end
                STAGE = 3'd3; // Parity Bit Stage
            end
            // Stop Bit
            @(negedge clk_TX);
            if (errors_to_introduce[1]) begin
                RX_IN_tb = 1'b0; // Introduce Stop Bit Error
            end
            else begin
                RX_IN_tb = 1'b1; // Stop Bit
            end
            STAGE = 3'd4; // Stop Bit Stage
            // Return to Idle
        end
    endtask

    ////////////////// Check Out Response  ////////////////////

    task check_out;
        input error_flag;
        begin
            #(7*CLOCK_PERIOD);
            if (!error_flag) begin
                if (Data_Valid_tb) begin
                    if (P_DATA_tb === data_temp) begin
                        $display("Input Data: %b. Data Valid at time %0t with P_DATA = %b", data_temp, $time, P_DATA_tb);
                        correct = correct + 1;
                    end
                    else begin
                        $display("ERROR: Mismatch! Input Data: %b. Received P_DATA = %b at time %0t", data_temp, P_DATA_tb, $time);
                        error = error + 1;
                    end
                end
                else 
                    $display("Input Data: %b. Start, Stop or Parity Error at: %0t", data_temp, $time);
            end
            else begin
                if (Data_Valid_tb) begin
                    $display("ERROR: Data Valid asserted incorrectly at time %0t with P_DATA = %b", $time, P_DATA_tb);
                    error = error + 1;
                end
                else begin
                    $display("Correctly detected Start, Stop or Parity Error at time %0t", $time);
                    correct = correct + 1;
                end
            end
        end
    endtask

endmodule