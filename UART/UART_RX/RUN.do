vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.UART_RX_tb -cover -l sim.log
add wave *
add wave -position insertpoint  \
sim:/UART_RX_tb/DUT/FSM_U0/current_state \
sim:/UART_RX_tb/DUT/FSM_U0/next_state \
sim:/UART_RX_tb/DUT/strt_glitch
run -all