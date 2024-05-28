`timescale 1ns / 1ps


  module iteration_butterfly #(parameter MAX_NUM_OF_SIGNALS = 3'd7, SIZE_OF_SIGNAL = 50, SIZE_OF_CONST = 36)(
    input  logic                         clk_i,
    input  logic                         rst_i,
    // input  logic                         tvalid,
    input  logic  [SIZE_OF_SIGNAL - 1:0] signal,
    input  logic  [ 2:0]                 num_of_signal,
    input  logic                         signal_flag,
    output signed [SIZE_OF_SIGNAL - 1:0] final_stage, 
    output logic  [ 2:0]                 final_num
  );

  //inner regs
 
  logic        [SIZE_OF_SIGNAL - 1:0] signal_reg       [MAX_NUM_OF_SIGNALS    :0];
  logic        [SIZE_OF_SIGNAL - 1:0] input_signal_reg [MAX_NUM_OF_SIGNALS    :0];
  logic signed [SIZE_OF_SIGNAL - 1:0] final_stage_reg  [MAX_NUM_OF_SIGNALS    :0];
  logic        [SIZE_OF_CONST  - 1:0] w                [3:0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage_reg        [MAX_NUM_OF_SIGNALS    :0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage1mutl       [MAX_NUM_OF_SIGNALS - 4:0];
  // logic        [43:0]                 im               [3:0];
  // logic        [43:0]                 re               [3:0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage1           [MAX_NUM_OF_SIGNALS    :0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage2           [MAX_NUM_OF_SIGNALS    :0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage2mutl       [MAX_NUM_OF_SIGNALS - 4:0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage2_reg       [MAX_NUM_OF_SIGNALS    :0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage3           [MAX_NUM_OF_SIGNALS    :0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage3mutl       [MAX_NUM_OF_SIGNALS - 4:0];
  logic signed [SIZE_OF_SIGNAL - 1:0] stage3_reg       [MAX_NUM_OF_SIGNALS    :0];
 
//   logic                               stage_num        [1:0];
  logic                               next_stage       [1:0];
 
  logic                               valid_reg_i      [11:0];
  logic                               valid_reg_o      [11:0];

  logic                               select;

  enum logic[1:0] { IDLE = 2'b00, STAGE1 = 2'b01, STAGE2 = 2'b10, STAGE3 = 2'b11 } stage_num;

  initial $readmemb("C:/Users/Yslavinsky/FFT_git/fft/mem/w_coef_data.mem", w);

  always_ff @(posedge clk_i) begin
    if (signal_flag == 0) 
      input_signal_reg[num_of_signal][SIZE_OF_SIGNAL - 1:0] <= signal;
    else if (signal_flag) 
      input_signal_reg[MAX_NUM_OF_SIGNALS][SIZE_OF_SIGNAL - 1:0] <= signal;
  end

  alwa

  assign signal_reg = select ? ( stage1 ):
                               ( input_signal_reg);

  always_ff @(posedge clk_i) begin
    if ( rst_i || !signal_flag )
      stage_num <= IDLE;
    else 
      stage_num <= next_stage;
  end

  always @(*) begin
    next_stage = state;
    
    case(stage_num)
      IDLE: 
        begin
         if (signal_flag)
           next_stage <= STAGE1
        end
      
      STAGE1:
        begin
          stage_reg[0] = { $signed(signal_reg[0][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[4][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[0][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[4][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[1] = { $signed(signal_reg[1][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[5][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[1][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[5][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[2] = { $signed(signal_reg[2][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[6][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[2][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[6][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[3] = { $signed(signal_reg[3][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[7][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[3][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[7][SIZE_OF_SIGNAL / 2 - 1:0]) };
          
          stage_reg[4] = { $signed(signal_reg[0][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[4][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[0][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[4][SIZE_OF_SIGNAL / 2 - 1:0]) }; 
          stage_reg[5] = { $signed(signal_reg[1][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[5][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[1][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[5][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[6] = { $signed(signal_reg[2][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[6][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[2][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[6][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[7] = { $signed(signal_reg[3][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[7][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[3][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[7][SIZE_OF_SIGNAL / 2 - 1:0]) };

          next_stage <= STAGE2;
        end
      
      STAGE2:
        begin
          stage_reg[0] = { $signed(signal_reg[0][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[2][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[0][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[2][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[1] = { $signed(signal_reg[1][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[3][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[1][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[3][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[2] = { $signed(signal_reg[0][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[2][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[0][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[2][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[3] = { $signed(signal_reg[1][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[3][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[1][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[3][SIZE_OF_SIGNAL / 2 - 1:0]) };
          
          stage_reg[4] = { $signed(signal_reg[4][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[6][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[4][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[6][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[5] = { $signed(signal_reg[5][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[7][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[5][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[7][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[6] = { $signed(signal_reg[4][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[6][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[4][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[6][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[7] = { $signed(signal_reg[5][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[7][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[5][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[7][SIZE_OF_SIGNAL / 2 - 1:0]) };
        
          next_stage <= STAGE3;
        end
      
      STAGE3:
        begin
          stage_reg[0] = { $signed(signal_reg[0][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[1][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[0][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[1][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[1] = { $signed(signal_reg[0][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[1][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[0][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[1][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[2] = { $signed(signal_reg[2][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[3][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[2][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[3][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[3] = { $signed(signal_reg[2][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[3][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[2][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[3][SIZE_OF_SIGNAL / 2 - 1:0]) };
          
          stage_reg[4] = { $signed(signal_reg[4][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[5][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[4][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[5][SIZE_OF_SIGNAL / 2 - 1:0]) }; 
          stage_reg[5] = { $signed(signal_reg[4][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[5][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[4][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[5][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[6] = { $signed(signal_reg[6][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) + $signed(signal_reg[7][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[6][SIZE_OF_SIGNAL / 2 - 1:0]) + $signed(signal_reg[7][SIZE_OF_SIGNAL / 2 - 1:0]) };
          stage_reg[7] = { $signed(signal_reg[6][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]) - $signed(signal_reg[7][SIZE_OF_SIGNAL - 1 : SIZE_OF_SIGNAL / 2]), $signed(signal_reg[6][SIZE_OF_SIGNAL / 2 - 1:0]) - $signed(signal_reg[7][SIZE_OF_SIGNAL / 2 - 1:0]) };
        
          next_stage <= IDLE;
        end
    
       default:
         begin
           next_stage = IDLE;
         end
    endcase
  end

  assign stage1[3:0] = stage_reg[3:0];

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst1(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[4]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[0]),
    .data_valid_o(valid_reg_o[0]),
    .butterfly_stage_o(stage1[4])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst2(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[5]),
    .w_i(w[1]),
    .data_valid_i(valid_reg_i[1]),
    .data_valid_o(valid_reg_o[1]),
    .butterfly_stage_o(stage1[5])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst3(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[6]),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i[2]),
    .data_valid_o(valid_reg_o[2]),
    .butterfly_stage_o(stage1[6])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst4(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[7]),
    .w_i(w[3]),
    .data_valid_i(valid_reg_i[3]),
    .data_valid_o(valid_reg_o[3]),
    .butterfly_stage_o(stage1[7])
  );

  
  
  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst5(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[2]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[4]),
    .data_valid_o(valid_reg_o[4]),
    .butterfly_stage_o(stage1[2])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst6(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[3]),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i[5]),
    .data_valid_o(valid_reg_o[5]),
    .butterfly_stage_o(stage1[3])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst7(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[6]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[6]),
    .data_valid_o(valid_reg_o[6]),
    .butterfly_stage_o(stage1[6])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst8(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[7]),
    .w_i(w[2]),
    .data_valid_i(valid_reg_i[7]),
    .data_valid_o(valid_reg_o[7]),
    .butterfly_stage_o(stage1[7])
  );

 
 
  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst9(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[1]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[8]),
    .data_valid_o(valid_reg_o[8]),
    .butterfly_stage_o(stage1[1])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst10(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[3]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[9]),
    .data_valid_o(valid_reg_o[9]),
    .butterfly_stage_o(stage1[3])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst11(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[5]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[10]),
    .data_valid_o(valid_reg_o[10]),
    .butterfly_stage_o(stage1[5])
  );

  dsp_mult #(SIZE_OF_SIGNAL, SIZE_OF_CONST) 
  dsp_mult_inst12(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stage_i(stage_reg[7]),
    .w_i(w[0]),
    .data_valid_i(valid_reg_i[11]),
    .data_valid_o(valid_reg_o[11]),
    .butterfly_stage_o(stage1[7])
  );

  

  always_ff @(posedge clk_i) begin
    if (rst_i || !signal_flag)
      select <= '0;
    else if (stage1[7] > 49'b0)
      select <= '1;
  end

  always_ff @(posedge clk_i) begin
    if (rst_i || !signal_flag)
      final_num <= '0;
    else if (valid_reg_o[11] && final_num != MAX_NUM_OF_SIGNALS)
      final_num <= final_num + 1'd1;
  end

  assign final_stage = final_stage_reg[final_num];
  endmodule
