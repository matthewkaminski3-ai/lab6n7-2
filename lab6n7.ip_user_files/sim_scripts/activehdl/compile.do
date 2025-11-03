transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../lab6n7.gen/sources_1/ip/clk_wiz_0" -l xpm -l xil_defaultlib \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../lab6n7.gen/sources_1/ip/clk_wiz_0" -l xpm -l xil_defaultlib \
"../../../lab6n7.srcs/sources_1/imports/Work/third_party/baud_gen.sv" \
"../../../lab6n7.srcs/sources_1/imports/Work/src/uart_rx.sv" \
"../../../lab6n7.srcs/sources_1/imports/Work/tb/tb_uart_rx.sv" \

vlog -work xil_defaultlib \
"glbl.v"

