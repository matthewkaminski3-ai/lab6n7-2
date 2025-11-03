transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../lab6n7.gen/sources_1/ip/clk_wiz_0" -l xpm -l xil_defaultlib \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  -incr \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr "+incdir+../../../lab6n7.gen/sources_1/ip/clk_wiz_0" -l xpm -l xil_defaultlib \
"../../../lab6n7.srcs/sources_1/imports/Work/third_party/baud_gen.sv" \
"../../../lab6n7.srcs/sources_1/imports/Work/src/uart_rx.sv" \
"../../../lab6n7.srcs/sources_1/imports/Work/tb/tb_uart_rx.sv" \

vlog -work xil_defaultlib \
"glbl.v"

