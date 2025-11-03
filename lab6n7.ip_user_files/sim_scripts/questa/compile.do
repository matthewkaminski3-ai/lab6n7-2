vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+../../../lab6n7.gen/sources_1/ip/clk_wiz_0" \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  -sv "+incdir+../../../lab6n7.gen/sources_1/ip/clk_wiz_0" \
"../../../lab6n7.srcs/sources_1/imports/Work/third_party/baud_gen.sv" \
"../../../lab6n7.srcs/sources_1/imports/Work/src/uart_rx.sv" \
"../../../lab6n7.srcs/sources_1/imports/Work/tb/tb_uart_rx.sv" \

vlog -work xil_defaultlib \
"glbl.v"

