module Lab4_Part1(SW, HEX0, HEX1);
  // 8 LEDR for 8-bit counter
  input [2:0] SW;
  output [6:0] HEX0;
  output [6:0] HEX1;

  // HEX
  hex_dis my_hex0(
    .hex(HEX0),
    .in(wire_hex[3:0]),
    );
  hex_dis my_hex1(
    .hex(HEX1),
    .in(wire_hex[7:4]),
    );

  wire [7:0] wire_hex;
  // Bit 0
  wire q0;
  t_ff my_t0(
    .enable(SW[0]),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q0),
    );
  assign wire_hex[0] = q0;

  // Bit 1
  wire q1;
  t_ff my_t1(
    .enable(SW[0] && q0),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q1),
    );
  assign wire_hex[1] = q1;

  // Bit 2
  wire q2;
  t_ff my_t2(
    .enable(q0 && q1),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q2),
    );
  assign wire_hex[2] = q2;

  // Bit 3
  wire q3;
  t_ff my_t3(
    .enable(q1 && q2),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q3),
    );
  assign wire_hex[3] = q3;

  // Bit 4
  wire q4;
  t_ff my_t4(
    .enable(q2 && q3),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q4),
    );
  assign wire_hex[4] = q4;

  // Bit 5
  wire q5;
  t_ff my_t5(
    .enable(q3 && q4),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q5),
    );
  assign wire_hex[5] = q5;

  // Bit 6
  wire q6;
  t_ff my_t6(
    .enable(q4 && q5),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q6),
    );
  assign wire_hex[6] = q6;

  // Bit 7
  wire q7;
  t_ff my_t7(
    .enable(q5 && q6),
    .clock(SW[1]),
    .clear_b(SW[2]),
    .q(q7),
    );
  assign wire_hex[7] = q7;

endmodule

module t_ff(enable, clock, clear_b, q);
  input enable, clock, clear_b;
  output q;

  reg q;
  // For asynchronous resest
  always @(posedge clock, negedge clock)
  begin
    if (clear_b == 1'b0)
      q <= 1'b0;
    else
      // 1 ^ 1 = 0; 1 ^ 0 = 1; 0 ^ 0 = 0; 1 ^ 0 = 1;
      // Want it to change only on the positive edge of the clock
      q <= (q ^ enable) & clock;
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
