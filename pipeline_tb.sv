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
    data_valid_i_tb = 0;
    
    #20
    rst = 0;
    
    #20
    data_valid_i_tb = 1;
    w_tb = { 18'b00_1011011000000000, 18'b10_1011011000000000 };
    stage_i_tb = 50'b00000000000000000000000101000000000000000000000010; 
    
    #40
    w_tb = {  18'b0, 18'b11_0000000000000000  };
    stage_i_tb = 50'b10000000000000000000000110000000000000000000000001;

    #40
    data_valid_i_tb = 0;
    w_tb = {  18'b10_1011011000000000, 18'b10_1011011000000000  };
    stage_i_tb = 50'b00000000000000000000000000000000000000000000000000;
  
  end
  
  endmodule
