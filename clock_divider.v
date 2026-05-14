// Take in the master clock and divide it
// into the various slower clocks needed
// --------------- INPUTS ---------------
// master_clk: 100 MHz clock from pin V10
// --------------- OUTPUTS ---------------
// clk_1hz: 1 Hz clock for normal counting
// clk_2hz: 2 Hz clock for adjusting seconds/minutes
// clk_fast: 500 Hz clock for debouncing buttons/switches
// clk_blink: 3 Hz clock for blinking the display when paused in adjust mode

module clock_divider(
    input master_clk,    // 100 MHz from pin V10
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
always @(posedge master_clk) begin
    // if the counter reaches the terminal count for 1Hz, toggle the output clock and reset the counter
    if (count1 == 49_999_999) begin
        count1 <= 0;
        clk_1hz <= ~clk_1hz;
    end else begin
        count1 <= count1 + 1;
    end
end

always @(posedge master_clk) begin
    // Same logic for 2Hz
    if (count2 == 24_999_999) begin
        count2 <= 0;
        clk_2hz <= ~clk_2hz;
    end else begin
        count2 <= count2 + 1;
    end
end

always @(posedge master_clk) begin
    // Same logic for Fast Clock (500 Hz)
    if (count_fast == 99_999) begin
        count_fast <= 0;
        clk_fast <= ~clk_fast;
    end else begin
        count_fast <= count_fast + 1;
    end
end

always @(posedge master_clk) begin
    // Same logic for Blink Clock (3 Hz)
    if (count_blink == 16_666_666) begin
        count_blink <= 0;
        clk_blink <= ~clk_blink;
    end else begin 
        count_blink <= count_blink + 1;
    end
end

endmodule