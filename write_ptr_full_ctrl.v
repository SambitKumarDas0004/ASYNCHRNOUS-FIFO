module write_ptr_full_ctrl #(parameter ADDR_WIDTH = 4)(
    output reg                fifo_full,
    output     [ADDR_WIDTH-1:0] wr_addr,
    output reg [ADDR_WIDTH:0]  wr_ptr_gray,
    input      [ADDR_WIDTH:0]  rdptr_sync,
    input                      wr_en,
    input                      wr_clk,
    input                      wr_rst_n
);

  reg  [ADDR_WIDTH:0] wr_bin;
  wire [ADDR_WIDTH:0] wr_bin_next, wr_gray_next;

  assign wr_addr     = wr_bin[ADDR_WIDTH-1:0];
  assign wr_bin_next = wr_bin + (wr_en & ~fifo_full);
  assign wr_gray_next = (wr_bin_next >> 1) ^ wr_bin_next;

  always @(posedge wr_clk or negedge wr_rst_n)
    if (!wr_rst_n)
      {wr_bin, wr_ptr_gray} <= 0;
    else
      {wr_bin, wr_ptr_gray} <= {wr_bin_next, wr_gray_next};

  always @(posedge wr_clk or negedge wr_rst_n)
    if (!wr_rst_n)
      fifo_full <= 1'b0;
    else
      fifo_full <= (wr_gray_next ==
                   {~rdptr_sync[ADDR_WIDTH:ADDR_WIDTH-1],
                     rdptr_sync[ADDR_WIDTH-2:0]});

endmodule