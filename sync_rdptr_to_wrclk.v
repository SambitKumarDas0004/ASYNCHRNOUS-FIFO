module sync_rdptr_to_wrclk #(parameter ADDR_WIDTH = 4)(
    input  [ADDR_WIDTH:0] rd_ptr_gray,
    input                 wr_clk,
    input                 wr_rst_n,
    output reg [ADDR_WIDTH:0] rdptr_sync
);

  reg [ADDR_WIDTH:0] rdptr_sync_ff;

  always @(posedge wr_clk or negedge wr_rst_n)
    if (!wr_rst_n)
      {rdptr_sync, rdptr_sync_ff} <= 0;
    else
      {rdptr_sync, rdptr_sync_ff} <= {rdptr_sync_ff, rd_ptr_gray};

endmodule