`timescale 1ns / 1ps

module display_tb;

    // inputs
    reg [5:0] seconds;
    reg [5:0] minutes;
    reg clk_fast;

    // outputs
    wire [6:0] seg;
    wire [3:0] an;

    display uut (
        .seconds(seconds), 
        .minutes(minutes),
        .select(1'b0),
        .adjust(1'b0),
        .clk_fast(clk_fast), 
        .clk_blink(1'b0),
        .seg(seg),
        .an(an)
    );

    integer i, j;

    initial clk_fast = 0;
    always #2 clk_fast = ~clk_fast;

    initial begin
        $display("Testing Multiplexing Logic...");
        $display("Time  | Anode | Segments | Digit Value");
        $display("---------------------------------------");

        // Let's test a specific time: 12:34
        minutes = 12;
        seconds = 34;

        // We need to wait for 4 positive edges of clk_fast 
        // to see all 4 digits cycle through.
        repeat (4) begin
            @(posedge clk_fast); 
            #1; // Small delay to let combinational logic settle
            
            case(an)
                4'b1110: $display("%02d:%02d | 1110  | %b | (S-Ones: 4)", minutes, seconds, seg);
                4'b1101: $display("%02d:%02d | 1101  | %b | (S-Tens: 3)", minutes, seconds, seg);
                4'b1011: $display("%02d:%02d | 1011  | %b | (M-Ones: 2)", minutes, seconds, seg);
                4'b0111: $display("%02d:%02d | 0111  | %b | (M-Tens: 1)", minutes, seconds, seg);
            endcase
        end

        $finish;
    end
      
endmodule