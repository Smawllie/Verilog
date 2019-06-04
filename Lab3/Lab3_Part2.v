module Lab3_Part2();

endmodule

// ShifterEightBit
module ShifterEightBit(d, shift, load_n, reset_n, ASR, clk, q);
  input [7:0] d;
  input shift, load_n, reset_n, ASR, clk;
  output [7:0] q;

  // ShifterBit w/ ASR modification for most significant bit
  // When ASR is high, then replicate the most significant bit
  if (ASR == 1'b1)
    shifterBit shiftBit7(
      .d(d[7]),
      .load_val(d[7]),
      .shift(shift),
      .load_n(load_n),
      .reset_n(reset_n),
      .clk(clk),
      .out(q[7]),
      );
  else
    shifterBit shiftBit7(
      .d(0),
      .load_val(d[7]),
      .shift(shift),
      .load_n(load_n),
      .reset_n(reset_n),
      .clk(clk),
      .out(q[7]),
      );

  shifterBit shiftBit6(
    .d(q[7]),
    .load_val(d[6]),
    .shift(shift),
    .load_n(load_n),
    .reset_n(reset_n),
    .clk(clk),
    .out(q[6]),
    );
  shifterBit shiftBit5(
    .d(q[6]),
    .load_val(d[5]),
    .shift(shift),
    .load_n(load_n),
    .reset_n(reset_n),
    .clk(clk),
    .out(q[5]),
    );
  shifterBit shiftBit4(
    .d(q[5]),
    .load_val(d[4]),
    .shift(shift),
    .load_n(load_n),
    .reset_n(reset_n),
    .clk(clk),
    .out(q[4]),
    );
  shifterBit shiftBit3(
    .d(q[4]),
    .load_val(d[3]),
    .shift(shift),
    .load_n(load_n),
    .reset_n(reset_n),
    .clk(clk),
    .out(q[3]),
    );
  shifterBit shiftBit2(
    .d(q[3]),
    .load_val(d[2]),
    .shift(shift),
    .load_n(load_n),
    .reset_n(reset_n),
    .clk(clk),
    .out(q[2]),
    );
  shifterBit shiftBit1(
    .d(q[2]),
    .load_val(d[1]),
    .shift(shift),
    .load_n(load_n),
    .reset_n(reset_n),
    .clk(clk),
    .out(q[1]),
    );
  shifterBit shiftBit0(
    .d(q[1]),
    .load_val(d[0]),
    .shift(shift),
    .load_n(load_n),
    .reset_n(reset_n),
    .clk(clk),
    .out(q[0]),
    );

endmodule

// ShifterBit
module shifterBit(d, load_val, shift, load_n, reset_n, clk, out);
  input d, load_val, shift, load_n, reset_n, clk;
  output out;

  // Shiftmux
  wire outShift;
  mux2to1 shiftMux(
    .x(out),
    .y(d),
    .s(shift),
    .m(outShift),
  );

  // Loadmux
  wire outLoad;
  mux2to1 loadMux(
    .x(load_val),
    .y(outShift),
    .s(load_n),
    .m(outLoad),
  );

  // Flip-flop
  flip_flop my_ff(
    .clk(clk),
    .reset_n(reset_n),
    .d(outLoad),
    .q(out),
  );

endmodule
// ShifterBit ASR. Might not need this part actually, might be better to do the
// ASR bit with the entire thing
module shifterBitASR(d, load_val, shift, load_n, reset_n, ASR, clk, out);
  input d, load_val, shift, load_n, reset_n, ASR, clk;
  output out;

  // Shiftmux
  wire outShift;
  mux2to1 shiftMux(
    .x(out),
    .y(d),
    .s(shift),
    .m(outShift),
  );

  // Loadmux
  wire outLoad;
  mux2to1 loadMux(
    .x(load_val),
    .y(outShift),
    .s(load_n),
    .m(outLoad),
  );

  // Flip-flop
  flip_flop my_ff(
    .clk(clk),
    .reset_n(reset_n),
    .d(outLoad),
    .q(out),
  );
endmodule



// D Flip-flop
module flip_flop(clk, reset_n, d, q);
  input clk;
  input d;
  input reset_n;
  output q;

  reg q;

  // q follows d on the positive edge of the clock
  always @(posedge clk) begin
    // Reset is triggered when reset_n is low. Active-low synchronous reset
    if (reset_n == 1'b0)
      q <= 0;
    else
      // Use <= for sequential circuit assignments. Non-blocking assignments
      q <= d;
  end

endmodule

// Mux 2to1
module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output

    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;
endmodule
