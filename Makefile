IVERILOG ?= iverilog
VVP      ?= vvp

.PHONY: all sim clean

all: sim

sim:
	$(IVERILOG) -o booth_sim booth_nxn.v booth_nxn_tb.v
	$(VVP) booth_sim

clean:
	rm -f booth_sim dump.vcd *.vvp
