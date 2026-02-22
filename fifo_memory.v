module fifo_memory #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    output [DATA_WIDTH-1:0] rd_data,
    input  [DATA_WIDTH-1:0] wr_data,
    input  [ADDR_WIDTH-1:0] wr_addr,
    input  [ADDR_WIDTH-1:0] rd_addr,
    input                   wr_en,
    input                   fifo_full,
    input                   wr_clk
);

  localparam DEPTH = 1 << ADDR_WIDTH;
  reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  assign rd_data = mem[rd_addr];

  always @(posedge wr_clk)
    if (wr_en && !fifo_full)
      mem[wr_addr] <= wr_data;

endmodule