module Lab4_Part2(SW, CLOCK_50, HEX0);
  // SW[1:0] for clock speed. SW[2] for clear. SW[3] for enable
  input [3:0] SW;
  input CLOCK_50;
  output [6:0] HEX0;

  // Rate Divider
  wire [28:0] rateDivider;
  rateDivider my_rd(
    .select(SW[1:0]),
    .Clear_b(SW[2]),
    .Enable(SW[3]),
    .clock(CLOCK_50),
    .q(rateDivider),
    );

  // Display Counter
  wire [3:0] hexCounter;
  wire clockDisplay;
  assign clockDisplay = (rateDivider == 28'b0000000000000000000000000000) ? 1 : 0;
  DisplayCounter my_dc(
    .enable(SW[3]),
    .clock(clockDisplay),
    .clear_b(SW[2]),
    .q(hexCounter),
    );

  // Hex 0
  hex_dis my_hex0(
    .hex(HEX0),
    .in(hexCounter),
    );
endmodule


module rateDivider(select, Clear_b, Enable, clock, q);
  input [1:0] select;
  input Clear_b;
  input Enable;
  output [28:0] q;

  wire ParLoad;
  assign ParLoad = 1'b1;
  // Set the amount of clock pulses we want based on the switches
  // Need 28 bits so that we get 268435456 > 200000000 values to store .25 Hz
  reg [28:0] q;
  always @(posedge clock) begin
    // If clear_b is on, reset the counter to the top by turning on ParLoad
    if (Clear_b == 1'b0)
      ParLoad = 1'b1;
    // Else if lowest value is hit, reset the counter to the top by turning on ParLoad
    else if (q = 28'b0000000000000000000000000000)
      ParLoad = 1'b1;
    // If ParLoad is on, set the value of the counter based on the switches.
    // Then turn ParLoad off so it doesn't keep resetting
    if (ParLoad == 1'b1) begin
      begin
        case (select[1:0])
          2'b00: q <= 0;
          // 50 million - 1 because we need one clock pulse to parallel load
          2'b01: q <= 28'b0010111110101111000001111111;
          // 100 million - 1 because we need one clock pulse to parallel load
          2'b10: q <= 28'b0101111101011110000011111111;
          // 200 million - 1
          2'b11: q <= 28'b1011111010111100000111111111;
        default: q <= 1'b0;
        endcase
      end
      ParLoad = 1'b0;
    end
    // Otherwise check if Enable is on and if it, decrement the counter
    else if (Enable == 1'b1)
      q <= q-1'b1;
  end
endmodule

// 4-bit counter that will be connected to Hex display
module DisplayCounter(enable, clock, clear_b, q);
  input enable, clock, clear_b;
  output [3:0] q;

  // Bit 0
  wire q0;
  t_ff my_t0(
    .enable(enable),
    .clock(clock),
    .clear_b(clear_b),
    .q(q0),
    );
  assign q[0] = q0;

  // Bit 1
  wire q1;
  t_ff my_t1(
    .enable(enable && q0),
    .clock(clock),
    .clear_b(clear_b),
    .q(q1),
    );
  assign q[1] = q1;

  // Bit 2
  wire q2;
  t_ff my_t2(
    .enable(q0 && q1),
    .clock(clock),
    .clear_b(clear_b),
    .q(q2),
    );
  assign q[2] = q2;

  // Bit 3
  wire q3;
  t_ff my_t3(
    .enable(q1 && q2),
    .clock(clock),
    .clear_b(clear_b),
    .q(q3),
    );
  assign q[3] = q3;
endmodule

// T-flip flop
module t_ff(enable, clock, clear_b, q);
  input enable, clock, clear_b;
  output q;

  reg q;
  always @(posedge clock, negedge clock)
  begin
    if (clear_b == 1'b0)
      q <= 1'b0;
    else
      // 1 ^ 1 = 0; 1 ^ 0 = 1; 0 ^ 0 = 0; 1 ^ 0 = 1;
      q <= q ^ enable;
  end
endmodule


// HEX
module hex_dis(hex, in);
    input [3:0] in;
    output [6:0] hex;

	zero_hex my_zero(
			.c3(in[3]),
			.c2(in[2]),
			.c1(in[1]),
			.c0(in[0]),
			.m(hex[0])
			);
	one_hex my_one(
			.c3(in[3]),
			.c2(in[2]),
			.c1(in[1]),
			.c0(in[0]),
			.m(hex[1])
			);

	two_hex my_two(
			.c3(in[3]),
			.c2(in[2]),
			.c1(in[1]),
			.c0(in[0]),
			.m(hex[2])
			);

	three_hex my_three(
			.c3(in[3]),
			.c2(in[2]),
			.c1(in[1]),
			.c0(in[0]),
			.m(hex[3])
			);
	four_hex my_four(
			.c3(in[3]),
			.c2(in[2]),
			.c1(in[1]),
			.c0(in[0]),
			.m(hex[4])
			);
	five_hex my_five(
			.c3(in[3]),
			.c2(in[2]),
			.c1(in[1]),
			.c0(in[0]),
			.m(hex[5])
			);

	six_hex my_six(
			.c3(in[3]),
			.c2(in[2]),
			.c1(in[1]),
			.c0(in[0]),
			.m(hex[6])
			);

endmodule



module zero_hex(c3, c2, c1, c0, m);
	input c3, c2, c1, c0;
	output m;

	assign m = ((~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (c3 & c2 & ~c1 & c0) | (c3 & ~c2 & c1 & c0));

endmodule

module one_hex(c3, c2, c1, c0, m);
	input c3, c2, c1, c0;
	output m;

	assign m = ((c3 & c1 & c0) | (c2 & c1 & ~c0) | (c3 & c2 & ~c0) | (~c3 & c2 & ~c1 & c0));

endmodule

module two_hex(c3, c2, c1, c0, m);
	input c3, c2, c1, c0;
	output m;

	assign m = ((~c3 & ~c2 & c1 & ~c0) | (c3 & c2 & ~c0) | (c3 & c2 & c1));

endmodule

module three_hex(c3, c2, c1, c0, m);
	input c3, c2, c1, c0;
	output m;

	assign m = ((~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (c2 & c1 & c0) | (c3 & ~c2 & c1 & ~c0));

endmodule

module four_hex(c3, c2, c1, c0, m);
	input c3, c2, c1, c0;
	output m;

	assign m = ((~c3 & c0) | (~c3 & c2 & ~c1) | (~c2 & ~c1 & c0));

endmodule

module five_hex(c3, c2, c1, c0, m);
	input c3, c2, c1, c0;
	output m;

	assign m = ((~c3 & ~c2 & c0) | (~c3 & c1 & c0) | (~c3 & ~c2 & c1) | (c3 & c2 & ~c1 & c0));

endmodule

module six_hex(c3, c2, c1, c0, m);
	input c3, c2, c1, c0;
	output m;

	assign m = ((~c3 & ~c2 & ~c1)|(~c3 & c2 &c1 & c0)|(c3 & c2 & ~c1 & ~c0));

endmodule
