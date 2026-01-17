`timescale 1ns/1fs
module UART_tb();

    /////////////////////////////////////////////////////////
    ///////////////////// Parameters ////////////////////////
    /////////////////////////////////////////////////////////

    parameter PRESCALE = 32; // Prescale value
    parameter CLOCK_FREQ_TX = 115.2; // Clock frequency in KHz
    parameter CLOCK_PERIOD_TX = 1000000/CLOCK_FREQ_TX; // Transmission Clock period in ns
    parameter CLOCK_PERIOD = CLOCK_PERIOD_TX/PRESCALE; // Receiver Clock period in ns
    reg [3:0] count;
    integer correct, error;

    /////////////////////////////////////////////////////////
    /////////// Testbench Signal Declaration ////////////////
    /////////////////////////////////////////////////////////

    reg        clk_tb, rst_n_tb, clk_RX;
    reg [7:0]  P_DATA_tb;
    reg [5:0]  Prescale_tb;
    reg        Data_Valid_tb, Par_En_tb, Par_Typ_tb;
    wire       TX_OUT_tb, Busy_tb;

    wire       RX_OUT_V_tb, PAR_Err_tb, STP_Err_tb;
    wire [7:0] RX_OUT_P_tb;

    reg        TX_OUT_expec, Busy_expec, Busy_expec_temp, done;
    reg [7:0]  P_DATA_reg;

    ////////////////////////////////////////////////////////
    /////////////////// DUT Instantation ///////////////////
    ////////////////////////////////////////////////////////

    UART DUT(
        .TX_CLK(clk_tb),
        .RX_CLK(clk_RX),
        .rst_n(rst_n_tb),
        .Par_En(Par_En_tb),
        .Par_Typ(Par_Typ_tb), // 0: Even, 1: Odd
        .Prescale(Prescale_tb),
        .RX_IN_S(TX_OUT_tb),
        .RX_OUT_P(RX_OUT_P_tb),
        .RX_OUT_V(RX_OUT_V_tb),
        .PAR_Err(PAR_Err_tb),
        .STP_Err(STP_Err_tb),
        .TX_IN_P(P_DATA_tb),
        .TX_IN_V(Data_Valid_tb),
        .TX_OUT_S(TX_OUT_tb),
        .TX_OUT_V(Busy_tb)
    );

    ////////////////////////////////////////////////////////
    ////////////////// Clock Generator  ////////////////////
    ////////////////////////////////////////////////////////

    always #(CLOCK_PERIOD_TX/2) clk_tb = ~clk_tb;
    always #(CLOCK_PERIOD/2) clk_RX = ~clk_RX;

    ////////////////////////////////////////////////////////
    /////////// Applying Stimulus on Inputs //////////////// 
    ////////////////////////////////////////////////////////

    initial begin
        // System Functions
        $dumpfile("UART_TX.vcd");
        $dumpvars;

        // initialization
        initialize();
        check_out();

        $display("Start of Odd Parity Testing at %0t", $time);
        
        repeat(50) begin
            @(negedge clk_tb);
            Data_Valid_tb = $random;
            P_DATA_tb = $random;
            Par_En_tb = 1'b1; // Parity enabled
            Par_Typ_tb = 1'b1; // Odd Parity
            if (Data_Valid_tb && !Busy_tb) 
                $display("Data Valid at time %0t with P_DATA = %0h", $time, P_DATA_tb);
            // @(negedge clk_tb);
            check_out(); 
        end

        $display("Start of Even Parity Testing at %0t", $time);
                
        repeat(50) begin
            @(negedge clk_tb);
            Data_Valid_tb = $random;
            P_DATA_tb = $random;
            Par_En_tb = 1'b1; // Parity enabled
            Par_Typ_tb = 1'b0; // Even Parity
            // @(negedge clk_tb);
            if (Data_Valid_tb && !Busy_tb) 
                $display("Data Valid at time %0t with P_DATA = %0h", $time, P_DATA_tb);
            check_out(); 
        end

        $display("Start of no Parity Testing at %0t", $time);
        
        repeat(25) begin
            @(negedge clk_tb);
            Data_Valid_tb = $random;
            P_DATA_tb = $random;
            Par_En_tb = 1'b0; // Parity Disabled
            Par_Typ_tb = 1'b1; // Odd Parity
            // @(negedge clk_tb);
            if (Data_Valid_tb && !Busy_tb) 
                $display("Data Valid at time %0t with P_DATA = %0h", $time, P_DATA_tb);
            check_out(); 
        end

        repeat(25) begin
            @(negedge clk_tb);
            Data_Valid_tb = $random;
            P_DATA_tb = $random;
            Par_En_tb = 1'b0; // Parity Disabled
            Par_Typ_tb = 1'b0; // Even Parity
            // @(negedge clk_tb);
            if (Data_Valid_tb) 
                $display("Data Valid at time %0t with P_DATA = %0h", $time, P_DATA_reg);
            check_out(); 
        end
        Data_Valid_tb = 1'b0;
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
            count = 0;
            correct = 0;
            error = 0;
            done = 1'b0;
            clk_tb  	  = 1'b0;
            clk_RX  	  = 1'b0;
            Data_Valid_tb = 1'b0;
            P_DATA_tb     = 8'hFF;
            Prescale_tb = PRESCALE;
            Par_En_tb     = 1'b0; // Parity Disabled
            Par_Typ_tb    = 1'b0; // Even Parity
            TX_OUT_expec = 1'b1; // Assuming TX_OUT is high during reset
            Busy_expec = 1'b0; // Not busy during reset
            Busy_expec_temp = 1'b0;
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

    ////////////////// Check Out Response  ////////////////////

    task check_out;
        begin
            if(!rst_n_tb) begin
                // During Reset
                TX_OUT_expec = 1'b1; // Assuming TX_OUT is high during reset
                Busy_expec = 1'b0; // Not busy during reset
                Busy_expec_temp = 1'b0;
                P_DATA_reg = 8'b0; // Clear stored data
                count = 0; // Reset count for next transmission
                done = 1'b0; // Reset done for next transmission
            end else if (Data_Valid_tb && !Busy_expec) begin
                // When Data is Valid, TX_OUT should start transmitting
                P_DATA_reg = P_DATA_tb; // Store the data for calculation
                Busy_expec_temp = 1'b1; // Indicate start of transmission
            end else if (Busy_expec_temp) begin
                TX_OUT_expec = 1'b0; // Start bit
                if (count == 9) begin// After sending all data bits
                    if (Par_En_tb && !done) begin
                        if (Par_Typ_tb) // Odd Parity
                            TX_OUT_expec = ~^P_DATA_reg; // Calculate odd parity
                        else          // Even Parity
                            TX_OUT_expec = ^P_DATA_reg; // Calculate even parity
                        done = 1'b1; // Indicate transmission done
                    end else if (!Par_En_tb || done)  begin
                        TX_OUT_expec = 1'b1; // Stop bit
                        Busy_expec_temp = 1'b0;
                        done = 1'b0; // Reset done for next transmission
                        count = 0; // Reset count for next transmission
                        if (Data_Valid_tb) begin
                            P_DATA_reg = P_DATA_tb; // Store the data for calculation
                            Busy_expec_temp = 1'b1;
                        end
                    end
                end else begin
                    if (count != 0) 
                        TX_OUT_expec = P_DATA_reg[count-1]; // Serial state
                    count = count + 1; // Increment count for next bit
                end
            end else begin
                // Idle State
                TX_OUT_expec = 1'b1; // Idle state
                Busy_expec_temp = 1'b0; // Not busy
                count = 0; // Reset count for next transmission
            end
            // Check if the outputs match the expected values
            if(TX_OUT_tb === TX_OUT_expec && Busy_tb === Busy_expec && !PAR_Err_tb && !STP_Err_tb) begin
                $display("Test Case has succeeded");
                correct = correct + 1;
            end else begin
                $display("Test Case has failed at %0t", $time);
                error = error + 1;
            end
            Busy_expec = Busy_expec_temp; // Update Busy_expec for next cycle
        end
    endtask

endmodule