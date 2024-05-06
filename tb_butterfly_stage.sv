`timescale 1ns / 1ps

module tb_butterfly();

logic [49:0] signal_store_tb      [7:0];
logic [49:0] final_stage_store_tb [7:0];
logic [49:0] signal_tb;
logic [ 2:0] num_of_signal_tb;
logic [49:0] final_stage_tb;
logic [2:0]  final_num_tb;
logic        clk;
logic        rst;

parameter CLK_PERIOD = 20; 

parameter FILE_PATH_IN = "E:/vivado/vivado_proj/FFT/mem_in.txt";
parameter FILE_PATH_OUT = "E:/vivado/vivado_proj/FFT/mem_out.txt";
// always begin
//     #10 clk_i = ~clk_i;
// end

initial begin
  clk = 0;
  forever #(CLK_PERIOD / 2) clk = ~clk;
end

butterfly_stage butterfly_stage_dut(
.clk_i( clk ),
.rst_i( rst ),
.signal( signal_tb ),
.final_stage( final_stage_tb ),
.num_of_signal(num_of_signal_tb),
.final_num(final_num_tb)
);

initial begin
  rst = 1;

  #20
  rst = 0;

  $readmemb(FILE_PATH_IN, signal_store_tb, 0);

  for (int i=0; i < 8; ++i) begin
    #20
    num_of_signal_tb = i;
    signal_tb = signal_store_tb[i];
  end

  if (final_num_tb >= '0) begin
  final_stage_store_tb[final_num_tb] = final_stage_tb;

  // #20
  // $writememb(FILE_PATH_OUT, , 0);

end


// #20
// num_of_signal_tb = 3'd0;
// signal_tb = signal_store_tb[0];
// #20
// num_of_signal_tb = 3'd1;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd2;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd3;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd4;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd5;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd6;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd7;
// signal_tb = ;





endmodule
