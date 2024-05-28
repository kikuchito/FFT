module FFT_mem_in
#(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 10
)
(
  input  logic                     clk_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_i,
  input  logic [RAM_WIDTH-1:0]     data_i_1,
  input  logic [RAM_WIDTH-1:0]     data_i_2,
  input  logic                     we_i,
  input  logic                     en_i,
  output logic [RAM_WIDTH-1:0]     data_o_1,
  output logic [RAM_WIDTH-1:0]     data_o_2,
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;
  localparam MAX_NUM_OF_SIGNALS = 8;
  localparam SIZE_OF_SIGNAL = 50;
  localparam SIZE_OF_CONST = 36;

  logic [RAM_WIDTH-1:0] bram1 [RAM_DEPTH/2-1:0];
  logic [RAM_WIDTH-1:0] bram2 [RAM_DEPTH-1:RAM_DEPTH/2];
  logic [RAM_WIDTH-1:0] data_out_ff;
  
  logic [2:0]           stage;
  logic [2:0]           counter_stage_1;
  logic [2:0]           counter_stage_2;
  logic [2:0]           counter_stage_3;

  always_ff @(posedge clk_i) begin
    if (en_i && ( addr_i[RAM_WIDTH/2-1] == '0 )) 
      bram1[addr_i] <= data_i;
    else if (en_i && ( addr_i[RAM_WIDTH/2-1] == '1 )) 
      bram2[addr_i] <= data_i;
  end

//   always_ff @(posedge clk_i) begin
//     if (en_i) begin
//       if (we_i)
//         bram[addr_i] <= data_i;
//       else
//         data_out_ff  <= bram[addr_i];
//     end
//   end
  
  assign data_o = data_out_ff;

  
  FFT_computation #()

endmodule