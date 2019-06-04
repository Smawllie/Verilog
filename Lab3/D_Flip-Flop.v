module my_dff(clk, reset_n, d, q);
  input clk;
  input d;
  input reset_n;
  output q;

  reg q;

  // q follows d on the positive edge of the clock. Need to learn what the
  // clock is
  always @(posedge clk) begin
    // Reset is triggered when reset_n is low. Active-low synchronous reset
    if (reset_n == 1'b0)
      q <= 0;
    else
      // Use <= for sequential circuit assignments. Non-blocking assignments
      q <= d;
  end
endmodule

module lab_2_Part3(SW, LEDR, HEX4, HEX5);
  // A = 4 bits B = 4 bits
  input [10:0] SW;
  output [7:0] LEDR;
  output [6:0] HEX4;
  output [6:0] HEX5;


  wire [7:0] ALUout;
  // ALUunit
  mux7to1 aluUnit(
    .MuxSelect(SW[10:8]),
	 .Input(SW[7:0]),
    .Out(ALUout),
    );

  //HEX5
  hex_dis hex_five(
	.hex(HEX5),
	.in(ALUout[7:4]),
	);

  //HEX4
  hex_dis hex_four(
	 .hex(HEX4),
	 .in(ALUout[3:0]),
	 );

  //LEDR
  assign LEDR[7:0] = ALUout[7:0];


endmodule

// Full Adder
module  f_adder(LEDR, SW);
  input [7:0] SW;
  output [4:0] LEDR;

  wire carry1;
  wire carry2;
  wire carry3;

  full_adder fadd1(
    .a(SW[4]),
    .b(SW[0]),
    .cin(0),
    .s(LEDR[0]),
    .cout(carry1),
    );
  full_adder fadd2(
    .a(SW[5]),
    .b(SW[1]),
    .cin(carry1),
    .s(LEDR[1]),
    .cout(carry2),
    );
  full_adder fadd3(
    .a(SW[6]),
    .b(SW[2]),
    .cin(carry2),
    .s(LEDR[2]),
    .cout(carry3),
    );
  full_adder fadd4(
    .a(SW[7]),
    .b(SW[3]),
    .cin(carry3),
    .s(LEDR[3]),
    .cout(LEDR[4]),
    );

endmodule

module full_adder(a, b, cin, s, cout);
  input a;
  input b;
  input cin;
  output s;
  output cout;

  wire a_xor_b;

  assign a_xor_b = a ^ b;
  assign s = a_xor_b ^ cin;
  mux2to1 my_mux(
    .x(b),
    .y(cin),
    .s(a_xor_b),
    .m(cout),
    );
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output

    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;
endmodule

module mux7to1(MuxSelect, Input, Out);
  input [2:0] MuxSelect;
  input [7:0] Input;
  output [7:0] Out;

  wire [7:4] a;
  wire [3:0] b;
  assign a = Input[7:4];
  assign b = Input[3:0];
  wire [7:0] a_concat_b;
  // This will be used for 5), doesn't need to be done again
  assign a_concat_b = {a, b};


  // 0) Adder from Part II. We can include the carry bit because we have 8 bits available
  wire [4:0] adder_connection;
  f_adder full_adder(
    .LEDR(adder_connection),
    .SW(Input[7:0]),
    );

	// 1) Adder using Verilog addition. wire[4:0] instead of wire[3:0] to contain the carry bit
  wire [4:0] veri_add_connection;
  assign veri_add_connection = a + b;

  // 2) A XOR B in lower four bits and A OR B in upper four bits
  wire [7:0] a_xor_or_b;
  wire [3:0] a_xor_b;
  wire [7:4] a_or_b;
  assign a_xor_b = a ^ b;
  assign a_or_b = a | b;
  assign a_xor_or_b = {a_or_b, a_xor_b};

  // 3) OR reduction
  wire or_reduction;
  assign or_reduction = | a_concat_b;

  // 4) AND reduction
  wire and_reduction;
  assign and_reduction = & a_concat_b;

  // 5) Concat. Already done above


  reg [7:0] Out; // declare the output signal for the always block
  always @(*) // declare always block with sensitivity *
  begin
    case (MuxSelect[2:0]) // start case statement. 8 possibilities with 3 select wires
      3'b000: Out = adder_connection;
      3'b001: Out = veri_add_connection;
      3'b010: Out = a_xor_or_b;
      3'b011: Out = or_reduction;
      3'b100: Out = and_reduction;
      3'b101: Out = a_concat_b;
      default: Out = 1'b0; // Actually more than 8, so we need to make sure to have this default case
      endcase
  end
endmodule

// Hex
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
