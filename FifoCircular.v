module RingBuffer(
  input        clk,
  input        rst,
  input        wr_enable,
  output       wr_full,
  input  [7:0] wr_data,
  input        wr_data_valid,
  input        rd_enable,
  output       rd_empty,
  output [7:0] rd_data,
  output       rd_data_valid
);

`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT

  reg [1:0] read_ptr; // Read pointer
  wire [2:0] decrement_value = 3'h4 - 3'h1; // 3-1
  wire [2:0] read_ptr_ext = {{1'd0}, read_ptr};
  wire [1:0] read_ptr_next = read_ptr_ext == decrement_value ? 2'h0 : read_ptr + 2'h1;
  reg [1:0] buffer_state; // Buffer state
  wire  is_idle = buffer_state == 2'h0;
  wire  has_data_to_read = buffer_state == 2'h2 & rd_enable;
  wire  read_increment = buffer_state == 2'h0 ? 1'h0 : (buffer_state == 2'h1 ? rd_enable : has_data_to_read);
  reg [1:0] write_ptr; // Write pointer
  wire [2:0] write_ptr_ext = {{1'd0}, write_ptr};
  wire [1:0] write_ptr_next = write_ptr_ext == decrement_value ? 2'h0 : write_ptr + 2'h1;
  wire  write_condition = wr_enable & wr_data_valid;
  wire  write_increment = buffer_state == 2'h0 ? write_condition : (buffer_state == 2'h1 ? write_condition : buffer_state == 2'h2 ? write_condition : 1'b0);
  reg [7:0] buffer_0; // Data storage
  reg [7:0] buffer_1;
  reg [7:0] buffer_2;
  reg [7:0] buffer_3;
  wire [7:0] write_buffer_0 = 2'h0 == write_ptr ? wr_data : buffer_0;
  wire [7:0] write_buffer_1 = 2'h1 == write_ptr ? wr_data : buffer_1;
  wire [7:0] write_buffer_2 = 2'h2 == write_ptr ? wr_data : buffer_2;
  wire [7:0] write_buffer_3 = 2'h3 == write_ptr ? wr_data : buffer_3;
  wire [7:0] updated_buffer_0 = wr_enable & wr_data_valid ? write_buffer_0 : buffer_0;
  wire [7:0] updated_buffer_1 = wr_enable & wr_data_valid ? write_buffer_1 : buffer_1;
  wire [7:0] updated_buffer_2 = wr_enable & wr_data_valid ? write_buffer_2 : buffer_2;
  wire [7:0] updated_buffer_3 = wr_enable & wr_data_valid ? write_buffer_3 : buffer_3;
  wire [1:0] state_after_write = read_ptr == write_ptr_next ? 2'h2 : buffer_state;
  wire [1:0] state_after_read = rd_enable ? 2'h1 : state_after_write;
  wire [1:0] next_state = (read_ptr == write_ptr) ? 2'h0 : (write_condition ? state_after_write : state_after_read);
  wire [7:0] read_data_temp = (2'h1 == read_ptr) ? buffer_1 : (2'h2 == read_ptr ? buffer_2 : (2'h3 == read_ptr ? buffer_3 : buffer_0));
  assign wr_full = buffer_state == 2'h2;
  assign rd_empty = buffer_state == 2'h0;
  assign rd_data = read_data_temp;
  assign rd_data_valid = is_idle ? 1'h0 : 1'h1;

  always @(posedge clk) begin
    if (rst) begin
      read_ptr <= 2'h0;
    end else if (read_increment) begin
      read_ptr <= (read_ptr_ext == decrement_value) ? 2'h0 : read_ptr + 2'h1;
    end

    if (rst) begin
      buffer_state <= 2'h0;
    end else case (buffer_state)
      2'h0: if (wr_enable & wr_data_valid) buffer_state <= 2'h1;
      2'h1: buffer_state <= rd_enable ? next_state : state_after_write;
      2'h2: buffer_state <= rd_enable ? 2'h1 : state_after_read;
    endcase

    if (rst) begin
      write_ptr <= 2'h0;
    end else if (write_increment) begin
      write_ptr <= (write_ptr_ext == decrement_value) ? 2'h0 : write_ptr + 2'h1;
    end

    if (buffer_state == 2'h0 || buffer_state == 2'h1) begin
      buffer_0 <= updated_buffer_0;
      buffer_1 <= updated_buffer_1;
      buffer_2 <= updated_buffer_2;
      buffer_3 <= updated_buffer_3;
    end
  end

  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  `define RANDOMIZE
  `endif
  `ifdef RANDOMIZE_INVALID_ASSIGN
  `define RANDOMIZE
  `endif
  `ifdef RANDOMIZE_REG_INIT
  `define RANDOMIZE
  `endif
  `ifdef RANDOMIZE_MEM_INIT
  `define RANDOMIZE
  `endif
  `ifndef RANDOM
  `define RANDOM $random
  `endif
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
  `endif
  `ifndef SYNTHESIS
  `ifdef FIRRTL_BEFORE_INITIAL
  `FIRRTL_BEFORE_INITIAL
  `endif
  initial begin
    `ifdef RANDOMIZE
      `ifdef INIT_RANDOM
        `INIT_RANDOM
      `endif
      `ifndef VERILATOR
        `ifdef RANDOMIZE_DELAY
          #`RANDOMIZE_DELAY begin end
        `else
          #0.002 begin end
        `endif
      `endif
  `ifdef RANDOMIZE_REG_INIT
    _RAND_0 = {1{`RANDOM}};
    read_ptr = _RAND_0[1:0];
    _RAND_1 = {1{`RANDOM}};
    buffer_state = _RAND_1[1:0];
    _RAND_2 = {1{`RANDOM}};
    write_ptr = _RAND_2[1:0];
    _RAND_3 = {1{`RANDOM}};
    buffer_0 = _RAND_3[7:0];
    _RAND_4 = {1{`RANDOM}};
    buffer_1 = _RAND_4[7:0];
    _RAND_5 = {1{`RANDOM}};
    buffer_2 = _RAND_5[7:0];
    _RAND_6 = {1{`RANDOM}};
    buffer_3 = _RAND_6[7:0];
  `endif // RANDOMIZE_REG_INIT
    `endif // RANDOMIZE
  end // initial
  `ifdef FIRRTL_AFTER_INITIAL
  `FIRRTL_AFTER_INITIAL
  `endif
  `endif // SYNTHESIS
endmodule
