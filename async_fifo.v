`timescale 1ns/1ns

module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    output [DATA_WIDTH-1:0] rd_data,
    output                  fifo_full,
    output                  fifo_empty,

    input  [DATA_WIDTH-1:0] wr_data,
    input                   wr_en,
    input                   wr_clk,
    input                   wr_rst_n,

    input                   rd_en,
    input                   rd_clk,
    input                   rd_rst_n
);

  wire [ADDR_WIDTH-1:0] wr_addr, rd_addr;
  wire [ADDR_WIDTH:0]   wr_ptr_gray, rd_ptr_gray;
  wire [ADDR_WIDTH:0]   rdptr_sync_wr, wrptr_sync_rd;

  // Read pointer synchronized into write clock domain
  sync_rdptr_to_wrclk #(ADDR_WIDTH) u_sync_r2w (
    .rd_ptr_gray (rd_ptr_gray),
    .wr_clk      (wr_clk),
    .wr_rst_n    (wr_rst_n),
    .rdptr_sync  (rdptr_sync_wr)
  );

  // Write pointer synchronized into read clock domain
  sync_wrptr_to_rdclk #(ADDR_WIDTH) u_sync_w2r (
    .wr_ptr_gray (wr_ptr_gray),
    .rd_clk      (rd_clk),
    .rd_rst_n    (rd_rst_n),
    .wrptr_sync  (wrptr_sync_rd)
  );

  // FIFO memory
  fifo_memory #(DATA_WIDTH, ADDR_WIDTH) u_mem (
    .rd_data (rd_data),
    .wr_data (wr_data),
    .wr_addr (wr_addr),
    .rd_addr (rd_addr),
    .wr_en   (wr_en),
    .fifo_full (fifo_full),
    .wr_clk  (wr_clk)
  );

  // Read pointer and empty control
  read_ptr_empty_ctrl #(ADDR_WIDTH) u_rd_ctrl (
    .fifo_empty   (fifo_empty),
    .rd_addr      (rd_addr),
    .rd_ptr_gray  (rd_ptr_gray),
    .wrptr_sync   (wrptr_sync_rd),
    .rd_en        (rd_en),
    .rd_clk       (rd_clk),
    .rd_rst_n     (rd_rst_n)
  );

  // Write pointer and full control
  write_ptr_full_ctrl #(ADDR_WIDTH) u_wr_ctrl (
    .fifo_full    (fifo_full),
    .wr_addr      (wr_addr),
    .wr_ptr_gray  (wr_ptr_gray),
    .rdptr_sync   (rdptr_sync_wr),
    .wr_en        (wr_en),
    .wr_clk       (wr_clk),
    .wr_rst_n     (wr_rst_n)
  );

endmodule