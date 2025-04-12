# Сalculating the FFT in system verilog

The calculation is performed from eight input signals. A reference model has also been written in python to compare the results with the hardware implementation.

## rtl

1. *FFT_wrapper* - written to connect to the axi bus.
2. *dsp_mult* - pipeline multiplication of complex numbers is implemented.
3. *butterfly_stage* - the main module of the FFT calculator.

## tb

1. *pipeline_tb.sv* - testbench for *dsp_mult*.
2. *tb_butterfly_stage.sv* - testbench for main calculation. Connecting to *FFT_wrapper*.

## scripts

1. *fft.ipynb* - ethalon python model.
2. parser.ipynb - parses binary to signed decimal.