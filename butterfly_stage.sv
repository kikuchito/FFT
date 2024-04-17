`timescale 1ns / 1ps


  module butterfly_stage(
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic  [49:0] signal [7:0],
    output signed [49:0] stage1 [7:0]
  );

  //inner regs
  logic        [35:0] w         [3:0];
  logic signed [49:0] stage_reg [7:0];
  logic        [43:0] im        [3:0];
  logic        [43:0] re        [3:0];

  //regs for dsp_mult
  logic       valid_reg_i;
  logic       valid_reg_o;
  // logic [2:0] stage_counter_i;
  // logic [2:0] stage_counter_o;
  // logic [2:0] w_counter;
  // logic [2:0] num_i;
  // logic [2:0] num_o;
  // logic [2:0] w_num;

  // always_ff @(posedge clk_i) begin
  //   if (rst_i || stage_counter_i == 3'd7)
  //     stage_counter_i <= 3'd4;
    
  //   else if (valid_reg_o)
  //     stage_counter_i <= stage_counter_i + '1;
  // end

  // assign num_i = stage_counter_i;

  // always_ff @(posedge clk_i) begin
  //   if (rst_i || stage_counter_o == 3'd7)
  //     stage_counter_o <= 3'd4;
    
  //   else if (valid_reg_o)
  //     stage_counter_o <= stage_counter_o + '1;
  // end

  // assign num_o = stage_counter_i;

  // always_ff @(posedge clk_i) begin
  //   if (rst_i || w_counter == 3'd3)
  //     w_counter <= 3'd0;
    
  //   else if (valid_reg_o)
  //     w_counter <= w_counter + '1;
  // end

  // assign w_num = w_counter;

  always_comb begin
    w[0] = { 18'b01_0000000000000000, 18'b0 };
    
    w[1] = { 18'b00_1011011000000000, 18'b10_1011011000000000 };
    
    w[2] = { 18'b0, 18'b11_0000000000000000 };
    
    w[3] = { 18'b10_1011011000000000, 18'b10_1011011000000000 };
  end
      
  assign valid_reg_i = '1;

  assign stage_reg[0] = { $signed(signal[0][49:25]) + $signed(signal[4][49:25]), $signed(signal[0][24:0]) + $signed(signal[4][24:0]) };
  assign stage_reg[1] = { $signed(signal[1][49:25]) + $signed(signal[6][49:25]), $signed(signal[1][24:0]) + $signed(signal[6][24:0]) };
  assign stage_reg[2] = { $signed(signal[2][49:25]) + $signed(signal[7][49:25]), $signed(signal[2][24:0]) + $signed(signal[7][24:0]) };
  assign stage_reg[3] = { $signed(signal[3][49:25]) + $signed(signal[5][49:25]), $signed(signal[3][24:0]) + $signed(signal[5][24:0]) };

  assign stage_reg[4] = { $signed(signal[0][49:25]) - $signed(signal[4][49:25]), $signed(signal[0][24:0]) - $signed(signal[4][24:0]) }; 
  assign stage_reg[5] = { $signed(signal[1][49:25]) - $signed(signal[5][49:25]), $signed(signal[1][24:0]) - $signed(signal[5][24:0]) };
  assign stage_reg[6] = { $signed(signal[2][49:25]) - $signed(signal[6][49:25]), $signed(signal[2][24:0]) - $signed(signal[6][24:0]) };
  assign stage_reg[7] = { $signed(signal[3][49:25]) - $signed(signal[7][49:25]), $signed(signal[3][24:0]) - $signed(signal[7][24:0]) };


  assign stage1[3:0] = stage_reg[3:0];

  dsp_mult dsp_mult_inst1(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[4]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i),
    .data_valid_o(valid_reg_o),
    .butterfly_stage_o(stage1[4])
  );

  dsp_mult dsp_mult_inst2(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[5]),
    .w_i(w[1]),
    .data_valid_i(valid_reg_i),
    .data_valid_o(valid_reg_o),
    .butterfly_stage_o(stage1[5])
  );

  dsp_mult dsp_mult_inst3(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[6]),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i),
    .data_valid_o(valid_reg_o),
    .butterfly_stage_o(stage1[6])
  );

  dsp_mult dsp_mult_inst4(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[7]),
    .w_i(w[3]),
    .data_valid_i(valid_reg_i),
    .data_valid_o(valid_reg_o),
    .butterfly_stage_o(stage1[7])
  );

  

  // assign stage1[4] = { stage_reg[4][49:25] * $signed(w[0][36:18]) - stage_reg[4][24:0] * $signed(w[0][36:18]), stage_reg[4][49:25] * w[0][36:18] + stage_reg[4][24:0] * w[0][36:18] };
  // assign stage1[5] = { stage_reg[5][49:25] * $signed(w[1][36:18]) - stage_reg[5][24:0] * $signed(w[1][17:0]), stage_reg[5][49:25] * w[1][36:18] + stage_reg[5][24:0] * w[1][17:0] };
  // assign stage1[6] = { stage_reg[6][49:25] * $signed(w[2][17:0]) - stage_reg[6][24:0] * $signed(w[2][17:0]), stage_reg[6][49:25] * w[2][17:0] + stage_reg[6][24:0] * w[2][17:0] };
  // assign stage1[7] = { stage_reg[7][49:25] * $signed(w[3][36:18]) - stage_reg[7][24:0] * $signed(w[3][17:0]), stage_reg[7][49:25] * w[3][36:18] + stage_reg[7][24:0] * w[3][17:0] };


  endmodule
