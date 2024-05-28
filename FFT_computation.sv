  module FFT_computation #(parameter MAX_NUM_OF_SIGNALS = 8, SIZE_OF_SIGNAL = 50, SIZE_OF_CONST = 36)(
    input  logic                         clk_i,
    input  logic                         rst_i,
    // input  logic                         tvalid,
    input  logic  [SIZE_OF_SIGNAL - 1:0] signal_1,
    input  logic  [SIZE_OF_SIGNAL - 1:0] signal_2,

    output signed [SIZE_OF_SIGNAL - 1:0] transformed_signal_1,
    output signed [SIZE_OF_SIGNAL - 1:0] transformed_signal_2,  
  );

  logic signed [SIZE_OF_SIGNAL - 1:0] transformed_signal_2_reg;

  logic        [SIZE_OF_CONST  - 1:0] w           [MAX_NUM_OF_SIGNALS/2-1:0];

  logic                               valid_reg_i [MAX_NUM_OF_SIGNALS/2-1:0];
  logic                               valid_reg_o [MAX_NUM_OF_SIGNALS/2-1:0];

  initial $readmemb("C:/Users/Yslavinsky/FFT_git/fft/mem/w_coef_data.mem", w);
  
  assign transformed_signal_1     = $signed(signal_1) + $signed(signal_2);
  assign transformed_signal_2_reg = $signed(signal_1) - $signed(signal_2);
  
  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst1(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(transformed_signal_2_reg),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[0]),
    .data_valid_o(valid_reg_o[0]),
    .butterfly_stage_o(transformed_signal_2)
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst2(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(transformed_signal_2_reg),
    .w_i(w[1]),
    .data_valid_i(valid_reg_i[1]),
    .data_valid_o(valid_reg_o[1]),
    .butterfly_stage_o(transformed_signal_2)
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst3(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(transformed_signal_2_reg),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i[2]),
    .data_valid_o(valid_reg_o[2]),
    .butterfly_stage_o(transformed_signal_2)
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst4(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(transformed_signal_2_reg),
    .w_i(w[3]),
    .data_valid_i(valid_reg_i[3]),
    .data_valid_o(valid_reg_o[3]),
    .butterfly_stage_o(transformed_signal_2)
  );

  endmodule