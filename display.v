/*
 * == Four-Digit Seven-Segment Controller Module ==
 * Takes MM:SS and displays it accordingly on the Basys 3 4-digit seven-segment LED display.
 *
 * Inputs:  seconds[5:0]    BCD for number of seconds from 0-59 (60-63 handled as 0)
            minutes[5:0]    BCD for number of minutes from 0-59 (60-63 handled as 0
            )
            select          0 = minutes should blink, 1 = seconds should blink
            adjust          0 = normal operation, 1 = adjust mode
            clk_fast        the clock signal for refreshing (~500 Hz)
 *
 * Outputs: seg[6:0]        Represents the current state of the seven segments
            an[3:0]         Represents the "on switch" for each of the four digits
 */

module display (
    input [5:0] seconds,
    input [5:0] minutes,
    input select,
    input adjust,
    input clk_fast,
    output reg [6:0] seg,
    output reg [3:0] an
);




endmodule