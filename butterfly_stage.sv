`timescale 1ns / 1ps


  module butterfly_stage(
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic  [49:0] signal,
    input  logic  [ 2:0] num_of_signal,
    output signed [49:0] final_stage, 
    output logic  [ 2:0] final_num
  );

  //inner regs
 
  logic        [49:0] signal_reg      [7:0];
  logic signed [49:0] final_stage_reg [7:0];
  logic        [35:0] w               [3:0];
  logic signed [49:0] stage_reg       [7:0];
  logic        [43:0] im              [3:0];
  logic        [43:0] re              [3:0];
  logic signed [49:0] stage1          [7:0];
  logic signed [49:0] stage2          [7:0];
  logic signed [49:0] stage2_reg      [7:0];
  logic signed [49:0] stage3          [7:0];
  logic signed [49:0] stage3_reg      [7:0];

  logic  [ 2:0] final_num;

  //regs for dsp_mult
  logic       valid_reg_i [11:0];
  logic       valid_reg_o [11:0];
  // logic [2:0] num_of_signal;
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

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      signal_reg[0] <= '0;
      signal_reg[1] <= '0; 
      signal_reg[2] <= '0; 
      signal_reg[3] <= '0;
      signal_reg[4] <= '0; 
      signal_reg[5] <= '0; 
      signal_reg[6] <= '0;
      signal_reg[8] <= '0;    
    end

    else begin
      signal_reg[num_of_signal][49:0] <= signal;
    end
  end



  always_comb begin
    w[0] = { 18'b01_0000000000000000, 18'b0 };
    
    w[1] = { 18'b00_1011011000000000, 18'b10_1011011000000000 };
    
    w[2] = { 18'b0, 18'b11_0000000000000000 };
    
    w[3] = { 18'b10_1011011000000000, 18'b10_1011011000000000 };
  end
      
  // assign valid_reg_i = '1;

  assign stage_reg[0] = { $signed(signal_reg[0][49:25]) + $signed(signal_reg[4][49:25]), $signed(signal_reg[0][24:0]) + $signed(signal_reg[4][24:0]) };
  assign stage_reg[1] = { $signed(signal_reg[1][49:25]) + $signed(signal_reg[6][49:25]), $signed(signal_reg[1][24:0]) + $signed(signal_reg[6][24:0]) };
  assign stage_reg[2] = { $signed(signal_reg[2][49:25]) + $signed(signal_reg[7][49:25]), $signed(signal_reg[2][24:0]) + $signed(signal_reg[7][24:0]) };
  assign stage_reg[3] = { $signed(signal_reg[3][49:25]) + $signed(signal_reg[5][49:25]), $signed(signal_reg[3][24:0]) + $signed(signal_reg[5][24:0]) };

  assign stage_reg[4] = { $signed(signal_reg[0][49:25]) - $signed(signal_reg[4][49:25]), $signed(signal_reg[0][24:0]) - $signed(signal_reg[4][24:0]) }; 
  assign stage_reg[5] = { $signed(signal_reg[1][49:25]) - $signed(signal_reg[5][49:25]), $signed(signal_reg[1][24:0]) - $signed(signal_reg[5][24:0]) };
  assign stage_reg[6] = { $signed(signal_reg[2][49:25]) - $signed(signal_reg[6][49:25]), $signed(signal_reg[2][24:0]) - $signed(signal_reg[6][24:0]) };
  assign stage_reg[7] = { $signed(signal_reg[3][49:25]) - $signed(signal_reg[7][49:25]), $signed(signal_reg[3][24:0]) - $signed(signal_reg[7][24:0]) };


  assign stage1[3:0] = stage_reg[3:0];

  assign valid_reg_i [0] = '1;
  assign valid_reg_i [1] = '1;
  assign valid_reg_i [2] = '1;
  assign valid_reg_i [3] = '1;

  dsp_mult dsp_mult_inst1(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[4]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[0]),
    .data_valid_o(valid_reg_o[0]),
    .butterfly_stage_o(stage1[4])
  );

  dsp_mult dsp_mult_inst2(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[5]),
    .w_i(w[1]),
    .data_valid_i(valid_reg_i[1]),
    .data_valid_o(valid_reg_o[1]),
    .butterfly_stage_o(stage1[5])
  );

  dsp_mult dsp_mult_inst3(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[6]),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i[2]),
    .data_valid_o(valid_reg_o[2]),
    .butterfly_stage_o(stage1[6])
  );

  dsp_mult dsp_mult_inst4(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[7]),
    .w_i(w[3]),
    .data_valid_i(valid_reg_i[3]),
    .data_valid_o(valid_reg_o[3]),
    .butterfly_stage_o(stage1[7])
  );

  
  assign stage2_reg[0] = { $signed(stage1[0][49:25]) + $signed(stage1[2][49:25]), $signed(stage1[0][24:0]) + $signed(stage1[2][24:0]) };
  assign stage2_reg[1] = { $signed(stage1[1][49:25]) + $signed(stage1[3][49:25]), $signed(stage1[1][24:0]) + $signed(stage1[3][24:0]) };
  assign stage2_reg[2] = { $signed(stage1[0][49:25]) - $signed(stage1[2][49:25]), $signed(stage1[0][24:0]) - $signed(stage1[2][24:0]) };
  assign stage2_reg[3] = { $signed(stage1[1][49:25]) - $signed(stage1[3][49:25]), $signed(stage1[1][24:0]) - $signed(stage1[3][24:0]) };

  assign stage2_reg[4] = { $signed(stage1[4][49:25]) + $signed(stage1[6][49:25]), $signed(stage1[4][24:0]) + $signed(stage1[4][24:0]) }; 
  assign stage2_reg[5] = { $signed(stage1[5][49:25]) + $signed(stage1[7][49:25]), $signed(stage1[5][24:0]) + $signed(stage1[5][24:0]) };
  assign stage2_reg[6] = { $signed(stage1[4][49:25]) - $signed(stage1[6][49:25]), $signed(stage1[4][24:0]) - $signed(stage1[6][24:0]) };
  assign stage2_reg[7] = { $signed(stage1[5][49:25]) - $signed(stage1[7][49:25]), $signed(stage1[5][24:0]) - $signed(stage1[7][24:0]) };

  assign stage2[1:0] = stage2_reg[1:0];
  assign stage2[5:4] = stage2_reg[1:0];

  assign valid_reg_i [4] = '1;
  assign valid_reg_i [5] = '1;
  assign valid_reg_i [6] = '1;
  assign valid_reg_i [7] = '1;

  dsp_mult dsp_mult_inst5(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage2_reg[2]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[4]),
    .data_valid_o(valid_reg_o[4]),
    .butterfly_stage_o(stage2[2])
  );

  dsp_mult dsp_mult_inst6(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage2_reg[3]),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i[5]),
    .data_valid_o(valid_reg_o[5]),
    .butterfly_stage_o(stage2[3])
  );

  dsp_mult dsp_mult_inst7(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage2_reg[6]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[6]),
    .data_valid_o(valid_reg_o[6]),
    .butterfly_stage_o(stage2[6])
  );

  dsp_mult dsp_mult_inst8(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage2_reg[7]),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i[7]),
    .data_valid_o(valid_reg_o[7]),
    .butterfly_stage_o(stage2[7])
  );

  assign stage3_reg[0] = { $signed(stage2[0][49:25]) + $signed(stage2[1][49:25]), $signed(stage2[0][24:0]) + $signed(stage2[1][24:0]) };
  assign stage3_reg[1] = { $signed(stage2[0][49:25]) - $signed(stage2[1][49:25]), $signed(stage2[0][24:0]) - $signed(stage2[1][24:0]) };
  assign stage3_reg[2] = { $signed(stage2[2][49:25]) + $signed(stage2[3][49:25]), $signed(stage2[2][24:0]) + $signed(stage2[3][24:0]) };
  assign stage3_reg[3] = { $signed(stage2[2][49:25]) - $signed(stage2[3][49:25]), $signed(stage2[2][24:0]) - $signed(stage2[3][24:0]) };

  assign stage3_reg[4] = { $signed(stage2[4][49:25]) + $signed(stage2[5][49:25]), $signed(stage2[4][24:0]) + $signed(stage2[5][24:0]) }; 
  assign stage3_reg[5] = { $signed(stage2[4][49:25]) - $signed(stage2[5][49:25]), $signed(stage2[4][24:0]) - $signed(stage2[5][24:0]) };
  assign stage3_reg[6] = { $signed(stage2[6][49:25]) + $signed(stage2[7][49:25]), $signed(stage2[6][24:0]) + $signed(stage2[7][24:0]) };
  assign stage3_reg[7] = { $signed(stage2[6][49:25]) - $signed(stage2[7][49:25]), $signed(stage2[6][24:0]) - $signed(stage2[7][24:0]) };

  assign final_stage_reg[0] = stage3_reg[0];
  assign final_stage_reg[2] = stage3_reg[2];
  assign final_stage_reg[4] = stage3_reg[4];
  assign final_stage_reg[6] = stage3_reg[5];

  assign valid_reg_i [8] = '1;
  assign valid_reg_i [9] = '1;
  assign valid_reg_i [10] = '1;
  assign valid_reg_i [11] = '1;

  dsp_mult dsp_mult_inst9(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage3_reg[1]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[8]),
    .data_valid_o(valid_reg_o[8]),
    .butterfly_stage_o(final_stage_reg[1])
  );

  dsp_mult dsp_mult_inst10(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage3_reg[3]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[9]),
    .data_valid_o(valid_reg_o[9]),
    .butterfly_stage_o(final_stage_reg[3])
  );

  dsp_mult dsp_mult_inst11(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage3_reg[5]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[10]),
    .data_valid_o(valid_reg_o[10]),
    .butterfly_stage_o(final_stage_reg[5])
  );

  dsp_mult dsp_mult_inst12(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage3_reg[7]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[11]),
    .data_valid_o(valid_reg_o[11]),
    .butterfly_stage_o(final_stage_reg[7])
  );

  always_ff @(posedge clk_i) begin
    if (rst_i)
      final_num <= '0;
    else if (final_stage_reg[7] != 49'bx)
      final_num <= final_num + 1'd1;
  end

  assign final_stage = final_stage_reg[final_num];
  
  // assign stage1[4] = { stage_reg[4][49:25] * $signed(w[0][36:18]) - stage_reg[4][24:0] * $signed(w[0][36:18]), stage_reg[4][49:25] * w[0][36:18] + stage_reg[4][24:0] * w[0][36:18] };
  // assign stage1[5] = { stage_reg[5][49:25] * $signed(w[1][36:18]) - stage_reg[5][24:0] * $signed(w[1][17:0]), stage_reg[5][49:25] * w[1][36:18] + stage_reg[5][24:0] * w[1][17:0] };
  // assign stage1[6] = { stage_reg[6][49:25] * $signed(w[2][17:0]) - stage_reg[6][24:0] * $signed(w[2][17:0]), stage_reg[6][49:25] * w[2][17:0] + stage_reg[6][24:0] * w[2][17:0] };
  // assign stage1[7] = { stage_reg[7][49:25] * $signed(w[3][36:18]) - stage_reg[7][24:0] * $signed(w[3][17:0]), stage_reg[7][49:25] * w[3][36:18] + stage_reg[7][24:0] * w[3][17:0] };


  endmodule
