`timescale 1ns / 1ps


  module FFT_wrapper #(parameter MAX_NUM_OF_SIGNALS = 8, SIZE_OF_SIGNAL = 50)(
    input  logic                                 clk_i,
    input  logic                                 reset_i,
                 
    input  logic                                 ss_tvalid,
    input  logic                                 ss_tlast,
    output logic                                 ss_tready,

    output  logic                                ms_tvalid,
    output  logic                                ms_tlast,
    
    input  logic  [SIZE_OF_SIGNAL - 1:0]         signal_i,
    output signed [SIZE_OF_SIGNAL - 1:0]         signal_o,
    
    output logic  [MAX_NUM_OF_SIGNALS / 2 - 2:0] final_num_top
  );


  logic [MAX_NUM_OF_SIGNALS / 2 - 2:0] num_of_signal_top;
  logic                                signal_flag_top;

  logic                                nullification;

  logic                                handshake;

  assign nullification = reset_i || ( final_num_top == MAX_NUM_OF_SIGNALS );
  assign handshake = ss_tvalid & ss_tready;

  always_ff @(posedge clk_i) begin
    if (nullification) begin 
      tready <= '1;
      num_of_signal_top <= '0;
      signal_flag_top <= '0;
    end
    
    else if (( handshake ) && ( num_of_signal_top != MAX_NUM_OF_SIGNALS - 1)) begin
      num_of_signal_top <= num_of_signal_top + 1'd1;
    end
    
    else if (( ss_tlast && handshake ) || ( num_of_signal_top == MAX_NUM_OF_SIGNALS - 1 )) begin
      tready <= '0;  
      //num_of_signal_top <= '0;
      signal_flag_top <= '1;
    end
  end

  butterfly_stage #(MAX_NUM_OF_SIGNALS, SIZE_OF_SIGNAL) 
  butterfly_stage_inst(
    .clk_i(clk_i),
    .rst_i(reset_i),
    .signal(signal_i),
    .signal_flag(signal_flag_top),
    .num_of_signal(num_of_signal_top),
    .final_stage(final_stage),
    .final_num(final_num_top)
  );

    // FFT_mem_in #(SIZE_OF_SIGNAL, MAX_NUM_OF_SIGNALS / 2 - 1)
    // FFT_mem_in_inst(
    //   .clk_i(clk_i),
    //   .addr_i(num_of_signal_top),
    //   .data_i_1(signal_i),
    //   .data_i_2(),
    //   .we_i(),
    //   .en_i(~signal_flag_top),
    //   .data_o_1(signal_o),
    //   .data_o_2()
    // );
endmodule
