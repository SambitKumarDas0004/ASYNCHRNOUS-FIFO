module read_ptr_empty_ctrl #(parameter ADDR_WIDTH = 4)(
    output reg                fifo_empty,
    output     [ADDR_WIDTH-1:0] rd_addr,
    output reg [ADDR_WIDTH:0]  rd_ptr_gray,
    input      [ADDR_WIDTH:0]  wrptr_sync,
    input                      rd_en,
    input                      rd_clk,
    input                      rd_rst_n
);

  reg  [ADDR_WIDTH:0] rd_bin;
  wire [ADDR_WIDTH:0] rd_bin_next, rd_gray_next;

  assign rd_addr     = rd_bin[ADDR_WIDTH-1:0];
  assign rd_bin_next = rd_bin + (rd_en & ~fifo_empty);
  assign rd_gray_next = (rd_bin_next >> 1) ^ rd_bin_next;

  always @(posedge rd_clk or negedge rd_rst_n)
    if (!rd_rst_n)
      {rd_bin, rd_ptr_gray} <= 0;
    else
      {rd_bin, rd_ptr_gray} <= {rd_bin_next, rd_gray_next};

  always @(posedge rd_clk or negedge rd_rst_n)
    if (!rd_rst_n)
      fifo_empty <= 1'b1;
    else
      fifo_empty <= (rd_gray_next == wrptr_sync);

endmodule