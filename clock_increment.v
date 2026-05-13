// Take in the stable inputs and implement the clock
// increment logic for seconds and minutes
// --------------- INPUTS ---------------
// clk_1hz: 1 Hz clock for normal counting
// clk_2hz: 2 Hz clock for adjusting seconds/minutes
// reset: resets the clock to 00:00
// pause: stops the clock from incrementing
// select: when in adjust mode, select whether to adjust seconds (1) or minutes (0)
// adjust_mode: whether we are in adjust mode or not
// --------------- OUTPUTS ---------------
// seconds: current seconds value (0-59)
// minutes: current minutes value (0-59)

module clock_increment(
    input clk_1hz, // increment when adjust is off
    input clk_2hz, // increment when adjust is on
    input reset, // reset count to 0
    input pause, // pause counting when adjust is on
    input select, // specify whether we are adjusting seconds or minutes
    input adjust_mode, // whether we are in adjust mode or not
    output reg [5:0] seconds, // 0-59
    output reg [5:0] minutes // 0-59
);

    // Increment seconds and minutes based on the current mode
    always @(posedge clk_1hz or posedge clk_2hz or posedge reset) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
        // if we are in normal mode and the 1 Hz clock ticks, increment seconds
        end else if (clk_1hz && !adjust_mode) begin
            // Increment seconds in normal mode
            if (!pause) begin
                // if the seconds will overflow, reset to 0 and increment minutes
                if (seconds == 59) begin
                    seconds <= 0;
                    // if the minutes will overflow, reset to 0
                    if (minutes == 59) begin
                        minutes <= 0;
                    // otherwise, just increment minutes
                    end else begin
                        minutes <= minutes + 1;
                    end
                // otherwise, just increment seconds
                end else begin
                    seconds <= seconds + 1;
                end
            end
        // else if we are in adjust mode and the 2 Hz clock ticks, 
        // increment either seconds or minutes based on the select input
        end else if (clk_2hz && adjust_mode) begin
            // same logic but it increments at 2Hz when adjust mode is on
            if (!pause) begin
                if (select) begin
                    // Adjusting seconds
                    if (seconds == 59) begin
                        seconds <= 0;
                    end else begin
                        seconds <= seconds + 1;
                    end
                end else begin
                    // Adjusting minutes
                    if (minutes == 59) begin
                        minutes <= 0;
                    end else begin
                        minutes <= minutes + 1;
                    end
                end
            end
        end
    end

endmodule