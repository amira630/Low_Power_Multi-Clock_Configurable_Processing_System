vlib work
vlog FSM.v Serializer.v Parity_Calc.v MUX4x1.v UART_TX.v UART_TX_tb.v +cover -covercells
vsim -voptargs=+acc work.UART_TX_tb -cover -l sim.log
add wave *
add wave -position insertpoint  \
sim:/UART_TX_tb/DUT/FSM_U0/current_state \
sim:/UART_TX_tb/DUT/FSM_U0/next_state
run -all