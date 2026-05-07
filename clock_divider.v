module clock_divider(
    input master_clk,    // 100 MHz from pin V10
    input reset,         // Button input
    output reg clk_1hz,
    output reg clk_2hz,
    output reg clk_fast, // 500 Hz
    output reg clk_blink  // 3 Hz
);

// Define counters here (size them based on terminal counts)
reg [26:0] count1; 
reg [25:0] count2;
reg [19:0] count_fast;
reg [19:0] count_blink;

// activate on the positive edge of the master clock or when reset is pressed
always @(posedge master_clk or posedge reset) begin
    // if reset is pressed, reset the counter and output clock
    if (reset) begin
        count1 <= 0;
        clk_1hz <= 0;
        count2 <= 0;
        clk_2hz <= 0;
        count_fast <= 0;
        clk_fast <= 0;
        count_blink <= 0;
        clk_blink <= 0;
    // if the counter reaches the terminal count for 1Hz, toggle the output 
    // clock and reset the counter
    end else if (count1 == 49_999_999) begin
        count1 <= 0;
        clk_1hz <= ~clk_1hz;
    // Same logic for 2Hz
    end else if (count2 == 24_999_999) begin
        count2 <= 0;
        clk_2hz <= ~clk_2hz;
    // Same logic for Fast Clock (500 Hz)
    end else if (count_fast == 19_999) begin
        count_fast <= 0;
        clk_fast <= ~clk_fast;
    // Same logic for Blink Clock (3 Hz)
    end else if (count_blink == 16_666_666) begin
        count_blink <= 0;
        clk_blink <= ~clk_blink;
    end else begin
        count1 <= count1 + 1;
        count2 <= count2 + 1;
        count_fast <= count_fast + 1;
        count_blink <= count_blink + 1;
    end
end

endmodule