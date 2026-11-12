`timescale 1ns/1ps
module tb_serial_twos_comp;
    parameter N = 8;
    reg clk = 0, rst = 1, load = 0;
    reg [N-1:0] data_in;
    wire [N-1:0] data_out;
    wire serial_out, serial_in, flag, done;
    integer i, errors = 0;
    reg [N-1:0] expected;
 
    serial_twos_comp #(N) dut (.clk(clk), .rst(rst), .load(load), .data_in(data_in),
        .data_out(data_out), .serial_out(serial_out), .serial_in(serial_in),
        .flag(flag), .done(done));
 
    always #5 clk = ~clk;
 
    task run(input [N-1:0] val);
        begin
            data_in = val; load = 1; @(posedge clk); #1; load = 0;
            wait (done); #1;
            expected = (~val) + 1'b1;
            if (data_out === expected) $display("PASS: in=%b (%0d)  2's comp=%b  expected=%b", val, val, data_out, expected);
            else begin $display("FAIL: in=%b out=%b expected=%b", val, data_out, expected); errors = errors + 1; end
            @(posedge clk);
        end
    endtask
 
    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0, tb_serial_twos_comp);
        #12 rst = 0;
        run(8'b0000_0000);
        run(8'b0000_0001);
        run(8'b0101_1000);
        run(8'b1010_1100);
        run(8'b1000_0000);
        run(8'b1111_1111);
        run(8'b0011_0110);
        for (i = 0; i < 6; i = i + 1) run($random);
        if (errors == 0) $display("ALL TESTS PASSED"); else $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
