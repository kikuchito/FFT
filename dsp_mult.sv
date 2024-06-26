`timescale 1ns / 1ps

  module dsp_mult#(parameter SIZE_OF_SIGNAL = 50, SIZE_OF_CONST = 36)(
    input  logic                           clk_i,
    input  logic                           rst_i,
    
    input  logic  [SIZE_OF_SIGNAL - 1 : 0] stage_i,
    input  logic  [SIZE_OF_CONST -  1 : 0] w_i,
    
    input  logic                           data_valid_i,
    output logic                           data_valid_o,
    
    output signed [SIZE_OF_SIGNAL - 1:0]   butterfly_stage_o
  );
  
  logic        [SIZE_OF_SIGNAL / 2 - 1 : 0] s_input_ff_re;
  logic        [SIZE_OF_CONST / 2 -  1 : 0] w_input_ff_re;
  logic        [SIZE_OF_SIGNAL / 2 - 1 : 0] s_input_ff_im;
  logic        [SIZE_OF_CONST / 2 -  1 : 0] w_input_ff_im;
  
  //regs for real part
  logic        [SIZE_OF_SIGNAL / 2 - 1 : 0] s_re_reg1;
  logic        [SIZE_OF_SIGNAL / 2 - 1 : 0] s_re_reg2;
  logic        [SIZE_OF_CONST / 2 -  1 : 0] w_re_reg1;
  logic        [SIZE_OF_CONST / 2 -  1 : 0] w_re_reg2;
  logic        [42:0]                       mult_re;
  logic        [42:0]                       mult_reg_re;
  logic signed [47:0]                       sum_re;
  logic signed [47:0]                       sum_reg_re;
  logic        [SIZE_OF_SIGNAL / 2 - 1 : 0] s_im_reg1;
  logic        [SIZE_OF_CONST / 2 -  1 : 0] w_im_reg1;
  logic        [42:0]                       mult_im;
  logic        [42:0]                       mult_reg_im1;
  logic        [42:0]                       mult_reg_im2;

  //regs for image part
  logic        [SIZE_OF_CONST / 2 -  1 : 0] w_im_reg2;
  logic        [42:0]                       mult_Ab;
  logic        [42:0]                       mult_aB;
  logic        [42:0]                       reg1_mult_aB;
  logic        [42:0]                       reg2_mult_aB;
  logic        [42:0]                       reg_mult_Ab;
  logic signed [47:0]                       sum_im;
  logic signed [47:0]                       sum_reg_im;

  logic                                     input_valid_ff;
  logic                                     data_valid_stage_1_ff;
  logic                                     data_valid_stage_2_ff;
  logic                                     data_valid_stage_3_ff;
  logic                                     data_valid_stage_4_ff;
  logic                                     output_valid_ff;


  assign s_input_ff_re = stage_i[SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2];
  assign w_input_ff_re = w_i[SIZE_OF_CONST - 1 : SIZE_OF_CONST / 2];
  assign s_input_ff_im = stage_i[SIZE_OF_SIGNAL / 2 - 1 : 0];
  assign w_input_ff_im = w_i[SIZE_OF_CONST / 2 - 1 : 0];
  

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
      output_valid_ff <= data_valid_stage_3_ff;

  always_ff @(posedge clk1) begin
    s_re_reg1 <= s_input_ff_re;
    w_re_reg1 <= w_input_ff_re;
    s_im_reg1 <= s_input_ff_im;
    w_im_reg1 <= w_input_ff_im;
  end
    
 

  always_ff @(posedge clk2) begin
    mult_reg_im1 <= mult_im;
    s_re_reg2 <= s_re_reg1;
    w_re_reg2 <= w_re_reg1;
    w_im_reg2 <= w_im_reg1;
    reg1_mult_aB <= mult_aB;
  end
  
  always_ff @(posedge clk3) begin
    mult_reg_im2 <= mult_reg_im1;
    mult_reg_re <= mult_re;
    reg2_mult_aB <= reg1_mult_aB;
    reg_mult_Ab <= mult_Ab;
  end
  
  assign mult_im = $signed(s_im_reg1) * $signed(w_im_reg1);
  assign mult_Ab = $signed(w_im_reg2) * $signed(s_re_reg2);
  assign mult_aB = $signed(s_im_reg1) * $signed(w_re_reg1);
  assign mult_re = $signed(s_re_reg2) * $signed(w_re_reg2);
  assign sum_re = $signed(mult_reg_re) - $signed(mult_reg_im2);
  assign sum_im = $signed(reg_mult_Ab) + $signed(reg2_mult_aB);

  always_ff @(posedge clk4) begin
    sum_reg_re <= sum_re;
    sum_reg_im <= sum_im;
  end

  // assign butterfly_stage_o = {sum_reg_re[47:23], sum_reg_im[47:23]};
  assign butterfly_stage_o = {sum_reg_re[40:16], sum_reg_im[40:16]};
  assign clk1 = data_valid_i && clk_i;
  assign clk2 = data_valid_stage_1_ff && clk_i;
  assign clk3 = data_valid_stage_2_ff && clk_i;
  assign clk4 = data_valid_stage_3_ff && clk_i;
  assign data_valid_o = butterfly_stage_o > 49'b0;
  // assign clk5 = data_valid_stage_4_ff && clk_i;

  endmodule
