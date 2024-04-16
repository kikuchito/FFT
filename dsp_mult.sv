`timescale 1ns / 1ps

  module dsp_mult(
    input  logic        clk_i,
    input  logic        reset_i,
    input  logic [49:0] stage_i,
    input  logic [35:0] w_i,
    input  logic        data_valid_i,
    output logic        data_valid_o,
    output logic [87:0] butterfly_stage_o
  );
  
  logic [24:0] s_input_ff_re;
  logic [17:0] w_input_ff_re;
  logic [24:0] s_input_ff_im;
  logic [17:0] w_input_ff_im;
  
  //regs for real part
  logic [24:0] s_re_reg1;
  logic [24:0] s_re_reg2;
  logic [17:0] w_re_reg1;
  logic [17:0] w_re_reg2;
  logic [43:0] mult_re;
  logic [43:0] mult_reg_re;
  logic [43:0] sum_re;
  logic [43:0] sum_reg_re;
  logic [24:0] s_im_reg1;
  logic [24:0] s_im_reg2;
  logic [43:0] mult_im;
  logic [43:0] mult_reg_im1;
  logic [43:0] mult_reg_im2;

  //regs for image part
  
  
  logic input_valid_ff;
  logic data_valid_stage_1_ff;
  logic data_valid_stage_2_ff;
  logic data_valid_stage_3_ff;
  logic data_valid_stage_4_ff;
  logic output_valid_ff;


  assign s_input_ff_re = stage_i[49:25];
  assign w_input_ff_re = w_i[35:18];
  assign s_input_ff_im = stage_i[24:0];
  assign w_input_ff_im = w_i[17:0];

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      input_valid_ff <= '0;
    else
      input_valid_ff <= data_valid_i;
  
  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i) begin
      data_valid_stage_1_ff <= '0;
      data_valid_stage_2_ff <= '0;
      data_valid_stage_3_ff <= '0;
    end
    else begin
      data_valid_stage_1_ff <= input_valid_ff;
      data_valid_stage_2_ff <= data_valid_stage_1_ff;
      data_valid_stage_3_ff <= data_valid_stage_2_ff;
      // data_valid_stage_4_ff <= data_valid_stage_3_ff;
    end

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      output_valid_ff <= '0;
    else
      output_valid_ff <= data_valid_stage_4_ff;

  always_ff @(posedge clk1) begin
    s_re_reg1 <= s_input_ff_re;
    w_re_reg1 <= w_input_ff_re;
    s_im_reg1 <= s_input_ff_im;
    w_im_reg1 <= w_input_ff_im;

  end
    
  assign mult_im = s_im_reg1 * w_im_reg1;

  always_ff @(posedge clk3) 
    mult_reg_im1 <= mult_im;

  always_ff @(posedge clk3) 
    mult_reg_im2 <= mult_reg_im1;

  always_ff @(posedge clk2) begin
    s_re_reg2 <= s_re_reg1;
    w_re_reg2 <= w_re_reg1;
  end

  assign mult_re = s_re_reg2 * w_re_reg2;

  always_ff @(posedge clk3)
    mult_reg_re <= mult_re;

  assign sum_re = mult_reg_re + mult_reg_im2;

  always_ff @(posedge clk4)
    sum_reg_re = sum_re

  assign butterfly_stage_o = {sum_reg_re, sum_reg_im};
  assign clk1 = data_valid_i && clk_i;
  assign clk2 = data_valid_stage_1_ff && clk_i;
  assign clk3 = data_valid_stage_2_ff && clk_i;
  assign clk4 = data_valid_stage_3_ff && clk_i;
  // assign clk5 = data_valid_stage_4_ff && clk_i;

  endmodule
