`timescale 1ns / 1ps


  module butterfly_stage(
    input  logic        clk_i,
    input  logic        reset_i,
    input  logic [49:0] signal [7:0],
    output logic [87:0] stage1 [7:0]
      );

  logic [35:0] w [3:0];
  logic [49:0] stage_reg [7:0];
  logic [43:0] im [3:0];
  logic [43:0] re [3:0];

    // w[0][35:18] = 1;
    // w[0][17:0 ] = 0;
    // w[1][35:18] = $signed(18'b00_1011011000000000)
    // w[1][17:0 ] = $signed(18'b10_1011011000000000)
    // w[2][35:18] = 0;
    // w[2][17:0 ] = 1;
    // w[3][35:18] = $signed(18'b10_1011011000000000)
    // w[3][17:0 ] = $signed(18'b10_1011011000000000)
    always_comb begin
      w[0] = { 18'b01_0000000000000000, 18'd0 };
      
      w[1] = { 18'b00_1011011000000000, 18'b10_1011011000000000 };
      
      w[2] = { 18'd0, 1'd11_0000000000000000 };
      
      w[3] = { 18'b10_1011011000000000, 18'b10_1011011000000000 };
    
    end
      
 

  always_ff @( posedge clk_i ) begin
    if (reset_i) begin
      stage_reg[0] <= 0;
      stage_reg[1] <= 0;
      stage_reg[2] <= 0;
      stage_reg[3] <= 0;
      stage_reg[4] <= 0;
      stage_reg[5] <= 0;  
      stage_reg[6] <= 0;
      stage_reg[7] <= 0;
    end
    
    else begin
      stage_reg[0] <= {( $signed(signal[0][49:25]) + $signed(signal[4][49:25]) + 1 ) >> 1, ( $signed(signal[0][24:0]) + $signed(signal[4][24:0]) + 1 ) >> 1}; //спросить, можно ли так складывать !!!
      stage_reg[2] <= {( $signed(signal[1][49:25]) + $signed(signal[6][49:25]) + 1 ) >> 1, ( $signed(signal[1][24:0]) + $signed(signal[6][24:0]) + 1 ) >> 1};
      stage_reg[3] <= {( $signed(signal[2][49:25]) + $signed(signal[7][49:25]) + 1 ) >> 1, ( $signed(signal[2][24:0]) + $signed(signal[7][24:0]) + 1 ) >> 1};
      stage_reg[1] <= {( $signed(signal[3][49:25]) + $signed(signal[5][49:25]) + 1 ) >> 1, ( $signed(signal[3][24:0]) + $signed(signal[5][24:0]) + 1 ) >> 1};
      
      stage_reg[4] <= {( $signed(signal[0][49:25]) - $signed(signal[4][49:25]) + 1 ) >> 1, ( $signed(signal[0][24:0]) - $signed(signal[4][24:0]) + 1 ) >> 1}; //спросить, можно ли так складывать !!!
      stage_reg[5] <= {( $signed(signal[1][49:25]) - $signed(signal[5][49:25]) + 1 ) >> 1, ( $signed(signal[1][24:0]) - $signed(signal[5][24:0]) + 1 ) >> 1};
      stage_reg[6] <= {( $signed(signal[2][49:25]) - $signed(signal[6][49:25]) + 1 ) >> 1, ( $signed(signal[2][24:0]) - $signed(signal[6][24:0]) + 1 ) >> 1};
      stage_reg[7] <= {( $signed(signal[3][49:25]) - $signed(signal[7][49:25]) + 1 ) >> 1, ( $signed(signal[3][24:0]) - $signed(signal[7][24:0]) + 1 ) >> 1};
    end
  
  end

  assign stage1[3:0] = stage_reg[3:0];
  
  assign stage1[4] = {( stage_reg[4][49:25] * $signed(w[0][36:18]) - stage_reg[4][24:0] * $signed(w[0][36:18]) + 1 ) >> 1, ( stage_reg[4][49:25] * w[0][36:18] + stage_reg[4][24:0] * w[0][36:18] + 1 ) >> 1};
  assign stage1[5] = {( stage_reg[5][49:25] * $signed(w[1][36:18]) - stage_reg[5][24:0] * $signed(w[1][17:0]) + 1 ) >> 1, ( stage_reg[5][49:25] * w[1][36:18] + stage_reg[5][24:0] * w[1][17:0] + 1 ) >> 1};
  assign stage1[6] = {( stage_reg[6][49:25] * $signed(w[2][17:0]) - stage_reg[6][24:0] * $signed(w[2][17:0]) + 1 ) >> 1, ( stage_reg[6][49:25] * w[2][17:0] + stage_reg[6][24:0] * w[2][17:0] + 1 ) >> 1};
  assign stage1[7] = {( stage_reg[7][49:25] * $signed(w[3][36:18]) - stage_reg[7][24:0] * $signed(w[3][17:0]) + 1 ) >> 1, ( stage_reg[7][49:25] * w[3][36:18] + stage_reg[7][24:0] * w[3][17:0] + 1 ) >> 1};
  // assign stage1[4] = stage_reg[4][49:25] * w[0][35:18] + 

  endmodule
