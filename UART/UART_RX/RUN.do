vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.UART_RX_tb -cover -l sim.log
add wave *
add wave -position insertpoint  \
sim:/UART_RX_tb/DUT/FSM_U0/current_state \
sim:/UART_RX_tb/DUT/FSM_U0/next_state \
sim:/UART_RX_tb/DUT/strt_glitch \
sim:/UART_RX_tb/DUT/sampled_bit \
sim:/UART_RX_tb/DUT/par_chk_en \
sim:/UART_RX_tb/DUT/stp_chk_en \
sim:/UART_RX_tb/DUT/strt_chk_en \
sim:/UART_RX_tb/DUT/edge_cnt \
sim:/UART_RX_tb/DUT/bit_cnt \
sim:/UART_RX_tb/DUT/enable \
sim:/UART_RX_tb/DUT/deser_en \
sim:/UART_RX_tb/DUT/FSM_U0/bit_count
run -all