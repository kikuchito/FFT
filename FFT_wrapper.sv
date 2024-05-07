`timescale 1ns / 1ps


  module FFT_wrapper #(parameter MAX_NUM_OF_SIGNALS = 3'd7, SIZE_OF_SIGNAL = 50)(
    input  logic                         clk_i,
    input  logic                         reset,
    input  logic                         tvalid,
    input  logic                         tlast,
    input  logic  [SIZE_OF_SIGNAL - 1:0] signal,
    output logic                         tready,
    output signed [SIZE_OF_SIGNAL - 1:0] final_stage,
    output logic  [ 2:0]                 final_num_top
  );

  logic [2:0] num_of_signal_top;
  logic       signal_flag_top;

  
  always_ff @(posedge clk_i) begin
    if (reset || ( final_num_top == MAX_NUM_OF_SIGNALS )) begin 
      tready <= '1;
      num_of_signal_top <= '0;
      signal_flag_top <= '0;
    end
    
    else if (( tvalid && tready ) && ( num_of_signal_top != MAX_NUM_OF_SIGNALS )) begin
      num_of_signal_top <= num_of_signal_top + 1'd1;
    end
    
    else if (tlast || ( num_of_signal_top == MAX_NUM_OF_SIGNALS )) begin
      tready <= '0;  
      //num_of_signal_top <= '0;
      signal_flag_top <= '1;
    end
  end

  butterfly_stage #(MAX_NUM_OF_SIGNALS) 
  butterfly_stage_inst(
    .clk_i(clk_i),
    .rst_i(reset),
    .signal(signal),
    .signal_flag(signal_flag_top),
    .num_of_signal(num_of_signal_top),
    .final_stage(final_stage),
    .final_num(final_num_top)
  );

endmodule
