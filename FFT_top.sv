`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2024 15:08:25
// Design Name: 
// Module Name: FFT_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


  module FFT_top(
    input  logic         clk_i,
    input  logic         reset,
    input  logic         tvalid,
    input  logic         tlast,
    input  logic  [49:0] signal,
    output logic         tready,
    output signed [49:0] final_stage, 
    );

  logic [49:0] signal_reg [7:0];

  always_ff @(posedge clk_i) begin
    if (tvalid && tready)
  end
  
endmodule
