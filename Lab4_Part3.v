module Lab4_Part3(SW, LEDR, CLOCK_50);
  // SW [2:0] for morse code. SW[3] for morse code display. SW[4] asynchronous reset
  input [4:0] SW;
  input CLOCK_50;
  output [1:0] LEDR;

  // .5 sec clock
  wire clockHalfSec;
  assign clockHalfSec = (rateDivider == 28'b0000000000000000000000000000) ? 1 : 0;
  wire [28:0] rateDivider;
  rateDivider my_rd(
    .select(2'b10),
    .Clear_b(SW[4]),
    .Enable(1),
    .clock(CLOCK_50),
    .q(rateDivider),
    );

  // Obtain letter in binary morse code
  wire [11:0] morseCode;
  morse_8to1mux my_mux(
    .select(SW[2:0]),
    .out(morseCode),
    );

  // Load it into the 12-bit shifter and hook it up to the .5 second clock
  // Use SW[3] to toggle when to shift or not
  shift_12bit my_shift(
    .d(morseCode),
    .shift(SW[3]),
    .Load_n(~SW[3]), // Do not want to load when shift is toggled
    .Reset_n(SW[4]),
    .Clk(clockHalfSec),
    .q(LEDR[0]),
    );

endmodule

// 8to1 Mux with encoded morse code patterns for A-H
module morse_8to1mux(select, out);
  input [2:0] select
  output [11:0] out;
  reg [11:0] out; // declare the output signal for the always block
  always @(*) // declare always block with sensitivity *
  begin
    case (select[2:0]) // start case statement. 8 possibilities with 3 select wires
      3'b000: out = 12'b101110000000;
      3'b001: out = 12'b111010101000;
      3'b010: out = 12'b111010111010;
      3'b011: out = 12'b111010100000;
      3'b100: out = 12'b100000000000;
      3'b101: out = 12'b101011101000;
      3'b110: out = 12'b111011100000;
      3'b111: out = 12'b101010100000;
      default: out = 1'b0; // Actually more than 8, so we need to make sure to have this default case
      endcase
  end
endmodule

// 12-bit shift register
module shift_12bit(d, shift, Load_n, Reset_n, Clk, o);
  input [11:0] d;
  input shift, Load_n, Reset_n, Clk;
  // Want a modified output where it only outputs the last bit. Need to make
  // sure to load the morse code in properly
  output o;
  assign o = q[0];
  wire [11:0] q;

  shifterBit shiftBit11(
    .d(0), // Want to shift in 0's at the end
    .load_val(d[11]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[11]),
  );
  shifterBit shiftBit10(
    .d(q[11]),
    .load_val(d[10]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[10]),
  );
  shifterBit shiftBit9(
    .d(q[10]),
    .load_val(d[9]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[9]),
  );
  shifterBit shiftBit8(
    .d(q[9]),
    .load_val(d[8]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[8]),
  );
  shifterBit shiftBit7(
    .d(q[8]),
    .load_val(d[7]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[7]),
  );

  shifterBit shiftBit6(
    .d(q[7]),
    .load_val(d[6]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[6]),
    );
  shifterBit shiftBit5(
    .d(q[6]),
    .load_val(d[5]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[5]),
    );
  shifterBit shiftBit4(
    .d(q[5]),
    .load_val(d[4]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[4]),
    );
  shifterBit shiftBit3(
    .d(q[4]),
    .load_val(d[3]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[3]),
    );
  shifterBit shiftBit2(
    .d(q[3]),
    .load_val(d[2]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[2]),
    );
  shifterBit shiftBit1(
    .d(q[2]),
    .load_val(d[1]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
    .out(q[1]),
    );
  shifterBit shiftBit0(
    .d(q[1]),
    .load_val(d[0]),
    .shift(shift),
    .load_n(Load_n),
    .reset_n(Reset_n),
    .clk(Clk),
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

// .5 second clock. Use switch = 10 for .5 second clock
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
