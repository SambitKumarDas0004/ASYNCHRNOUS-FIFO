module sync_wrptr_to_rdclk #(parameter ADDR_WIDTH = 4)(
    input  [ADDR_WIDTH:0] wr_ptr_gray,
    input                 rd_clk,
    input                 rd_rst_n,
    output reg [ADDR_WIDTH:0] wrptr_sync
);

  reg [ADDR_WIDTH:0] wrptr_sync_ff;

  always @(posedge rd_clk or negedge rd_rst_n)
    if (!rd_rst_n)
      {wrptr_sync, wrptr_sync_ff} <= 0;
    else
      {wrptr_sync, wrptr_sync_ff} <= {wrptr_sync_ff, wr_ptr_gray};

endmodule