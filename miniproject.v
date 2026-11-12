// Serial 2's Complementer using a Shift Register and a D Flip-Flop
// The number is shifted out LSB first; its 2's complement is shifted in at the MSB end.
// Rule: copy bits up to and including the first '1', invert every bit after it.
module serial_twos_comp #(parameter N = 8) (
    input              clk,
    input              rst,       // synchronous, active high
    input              load,      // load parallel data into the shift register
    input  [N-1:0]     data_in,
    output [N-1:0]     data_out,  // shift register contents (2's complement after N clocks)
    output             serial_out,// bit shifted out (LSB of original number)
    output             serial_in, // bit shifted in (complemented bit)
    output reg         flag,      // flip-flop: 1 once the first '1' has been seen
    output reg         done
);
    reg [N-1:0] sr;
    reg [$clog2(N+1)-1:0] cnt;
 
    assign serial_out = sr[0];
    assign serial_in  = sr[0] ^ flag;   // XOR with flag: pass until first 1, invert after
    assign data_out   = sr;
 
    always @(posedge clk) begin
        if (rst) begin
            sr   <= {N{1'b0}};
            flag <= 1'b0;
            cnt  <= 0;
            done <= 1'b0;
        end else if (load) begin
            sr   <= data_in;
            flag <= 1'b0;
            cnt  <= 0;
            done <= 1'b0;
        end else if (!done) begin
            sr   <= {serial_in, sr[N-1:1]};  // shift right, new bit enters at MSB
            flag <= flag | sr[0];            // flip-flop sets after first 1 leaves
            cnt  <= cnt + 1'b1;
            if (cnt == N-1) done <= 1'b1;
        end
    end
endmodule

 