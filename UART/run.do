vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.UART_tb -cover -l sim.log
add wave *
add wave -position insertpoint  \
sim:/UART_tb/DUT/TX_U0/FSM_U0/current_state \
sim:/UART_tb/DUT/TX_U0/FSM_U0/next_state \
sim:/UART_tb/DUT/RX_U1/FSM_U1/current_state \
sim:/UART_tb/DUT/RX_U1/FSM_U1/next_state \
sim:/UART_tb/DUT/RX_U1/strt_glitch \
sim:/UART_tb/DUT/RX_U1/dat_samp_en \
sim:/UART_tb/DUT/RX_U1/sampled_bit \
sim:/UART_tb/DUT/RX_U1/par_chk_en \
sim:/UART_tb/DUT/RX_U1/stp_chk_en \
sim:/UART_tb/DUT/RX_U1/strt_chk_en \
sim:/UART_tb/DUT/RX_U1/edge_cnt \
sim:/UART_tb/DUT/RX_U1/bit_cnt \
sim:/UART_tb/DUT/RX_U1/enable \
sim:/UART_tb/DUT/RX_U1/deser_en \
sim:/UART_tb/DUT/RX_U1/FSM_U1/bit_count
run -all