`timescale 1ns / 1ps

  module pipeline_tb();
  
  logic [35:0] w_tb;
  logic [49:0] stage_i_tb;
  logic        clk;
  logic        rst;
  logic        data_valid_i_tb;
  logic        data_valid_o_tb;
  logic [49:0] butterfly_stage_tb;

  dsp_mult dsp_inst(
    .clk_i(clk),
    .rst_i(rst),
    .stage_i(stage_i_tb),
    .w_i(w_tb),
    .data_valid_i(data_valid_i_tb),
    .data_valid_o(data_valid_o_tb),
    .butterfly_stage_o(butterfly_stage_tb)
  );

  parameter CLK_PERIOD = 10;
  
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end
  
  initial begin
    #20
    rst = 1;

    #20
    rst = 0;

    #10
    data_valid_i_tb = 1;

  end
  
  endmodule
