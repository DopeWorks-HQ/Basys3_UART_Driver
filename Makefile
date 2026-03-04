SIM=iverilog
SIM_ARGS= -g2012 -o
LINT=verilator --lint-only -Wall -Irtl
GTK=/usr/bin/gtkwave
RTL_SRCS := $(wildcard rtl/*.sv)
TOP=top

ifeq ($(firstword $(MAKECMDGOALS)), lint)
TOP:= $(word 2, $(MAKECMDGOALS))
$eval($(TOP):;@:)
endif

ifeq ($(firstword $(MAKECMDGOALS)), sim)
TOP:= $(word 2, $(MAKECMDGOALS))
$eval($(TOP):;@:)
endif

ifeq ($(firstword $(MAKECMDGOALS)), wave)
TOP:= $(word 2, $(MAKECMDGOALS))
$eval($(TOP):;@:)
endif

.PHONY: lint sim wave synth clean flash $(TOP)

lint:
	$(LINT) rtl/$(TOP).sv

sim:
	$(SIM) $(SIM_ARGS) sim/tb_$(TOP)/$(TOP).vvp  $(RTL_SRCS) sim/tb_$(TOP)/tb_$(TOP).sv
	cd sim/tb_$(TOP) && vvp $(TOP).vvp
	
	@read -p "Open waveform for $(TOP)? (y/N): " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		gnome-terminal -e "$(GTK) sim/tb_$(TOP)/tb_$(TOP).vcd"; \
	else \
		echo "Aborted."; \
	fi

wave:
	$(GTK) sim/tb_$(TOP)/tb_$(TOP).gtkw

synth: 
	/tools/Xilinx/2025.1/Vivado/bin/vivado -mode batch -source build.tcl

flash:
	openFPGALoader -b basys3 uart_echo.bit

clean:
	rm -f vivado* clock*
	rm -rf .Xil


	