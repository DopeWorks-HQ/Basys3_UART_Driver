read_verilog -sv "rtl/uart_echo.sv"
read_verilog -sv "rtl/uart_tx.sv"
read_verilog -sv "rtl/uart_rx.sv"
read_verilog -sv "rtl/cntr_cmp.sv"

read_xdc "constraints/basys3.xdc"

synth_design -top "uart_echo" -part "xc7a35ticpg236-1L"

opt_design
place_design
route_design

write_bitstream -force "uart_echo.bit"