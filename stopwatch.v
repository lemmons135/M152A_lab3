// Top level module that calles all other 
// modules and connects them together

module stopwatch(
    input master_clk, // 100 MHz clock from pin V10
    input btnL, // left button input for reset
    input btnR, // right button input for pause
    input sw [1:0], // 2-bit switch input for select and adjust
    output [6:0] seg, // 7-segment display output
    output [3:0] an // 7-segment display anode control
);

    // Internal signals
    wire clk_1hz; // 1 Hz clock for counting seconds
    wire clk_2hz; // 2 Hz clock for adjusting seconds/minutes
    wire clk_fast; // 500 Hz clock for debouncing buttons/switches
    wire clk_blink; // 3 Hz clock for blinking the display when paused in adjust mode
    wire [5:0] seconds; // seconds count (0-59)
    wire [5:0] minutes; // minutes count (0-59)
    wire select; // Select signal for adjusting digits
    wire adjust; // Adjust signal for incrementing selected digit
    wire reset; // Reset signal for stopwatch
    wire pause; // Pause signal for stopwatch

    // Clock divider to generate slower clocks from master clock
    clock_divider clk_div (
        .master_clk(master_clk),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_fast(clk_fast),
        .clk_blink(clk_blink)
    );

    // debounce and stablize the inputs
    clean_inputs cln_in (
        .clk_fast(clk_fast),
        .sw(sw),
        .btnL(btnL),
        .btnR(btnR),
        .select(select),
        .adjust(adjust),
        .reset(reset),
        .pause(pause)
    );

    // Button debouncer and control logic
    clock_increment clk_inc (
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .reset(reset),
        .pause(pause)
        .select(select),
        .adjust(adjust),
        .seconds(seconds),
        .minutes(minutes)
    );

    // 7-segment display driver to convert digits to segment outputs
    display dis (
        .seconds(seconds),
        .minutes(minutes),
        .select(select),
        .adjust(adjust),
        .clk_fast(clk_fast),
        .clk_blink(clk_blink),
        .seg(seg),
        .an(an)
    );