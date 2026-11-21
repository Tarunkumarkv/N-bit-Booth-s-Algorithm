// =============================================================================
// Testbench:   booth_nxn_tb
// Description: Self-Checking Signed Testbench for Parameterized Booth Multiplier
// =============================================================================
`timescale 1ns/1ps

module booth_nxn_tb();
    localparam N = 6;

    reg  signed [N-1:0]   multiplicand;
    reg  signed [N-1:0]   multiplier;
    wire signed [2*N-1:0] product;

    integer pass_count;
    integer fail_count;
    reg signed [2*N-1:0] expected;

    // Instantiate Parameterized Booth Multiplier (6-bit signed operands -> 12-bit signed product)
    booth_nxn #(.n(N)) vut (
        .multiplicand (multiplicand),
        .multiplier   (multiplier),
        .product      (product)
    );

    task apply_and_check(
        input signed [N-1:0] m_in,
        input signed [N-1:0] q_in
    );
    begin
        multiplicand = m_in;
        multiplier   = q_in;
        expected     = m_in * q_in;
        #10;
        if (product === expected) begin
            pass_count = pass_count + 1;
            $display("[PASS] t=%0t ns | M=%4d (%b) * Q=%4d (%b) => Product=%5d (%b)",
                     $time, multiplicand, multiplicand, multiplier, multiplier, product, product);
        end else begin
            fail_count = fail_count + 1;
            $display("[FAIL] t=%0t ns | M=%4d * Q=%4d => Got=%5d (%b), Expected=%5d (%b)",
                     $time, multiplicand, multiplier, product, product, expected, expected);
        end
    end
    endtask

    initial begin
        // Generate VCD waveform dump for GTKWave inspection
        $dumpfile("dump.vcd");
        $dumpvars(0, booth_nxn_tb);

        pass_count = 0;
        fail_count = 0;

        $display("-------------------------------------------------------------------------");
        $display(" Starting Self-Checking Verification: %0d-Bit Signed Radix-2 Booth Multiplier", N);
        $display("-------------------------------------------------------------------------");

        // 1. Original baseline vectors (+21 * -22 = -462, +26 * +26 = +676)
        apply_and_check( 6'sd21, -6'sd22);
        apply_and_check( 6'sd26,  6'sd26);

        // 2. Signed quadrant & boundary vectors
        apply_and_check(-6'sd15, -6'sd12); // Negative * Negative = +180
        apply_and_check(-6'sd31,  6'sd19); // Negative * Positive = -589
        apply_and_check( 6'sd0,  -6'sd25); // Zero multiplicand   = 0
        apply_and_check( 6'sd18,  6'sd0 ); // Zero multiplier     = 0
        apply_and_check(-6'sd1,  -6'sd1 ); // Unity negative      = +1
        apply_and_check( 6'sd31, -6'sd31); // Max magnitude       = -961

        $display("-------------------------------------------------------------------------");
        $display(" Verification Summary: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("-------------------------------------------------------------------------");

        #10 $finish;
    end

endmodule
