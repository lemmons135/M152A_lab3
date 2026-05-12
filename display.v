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
            clk_blink       3Hz signal to blink on
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
    input clk_blink,
    output reg [6:0] seg,
    output reg [3:0] an
);

    //convert 6-bit binary to BCD, separate digits
    wire [3:0] s_ones, s_tens, m_ones, m_tens;
    reg  [3:0] current_digit;
    reg  [1:0] refresh_counter = 0;

    assign s_ones = seconds % 10;
    assign s_tens = seconds / 10;
    assign m_ones = minutes % 10;
    assign m_tens = minutes / 10;


    always @(posedge clk_fast) begin
        refresh_counter <= refresh_counter + 1;
    end

    always @(*) begin
        //activate current digit
        case(refresh_counter)
            2'b00: begin
                //activate Digit 1 (XX:XN)
                an = 4'b1110;
                current_digit = s_ones;
            end
            2'b01: begin
                //activate Digit 2 (XX:NX)
                an = 4'b1101;
                current_digit = s_tens;
            end
            2'b10: begin
                //activate Digit 3 (XN:XX)
                an = 4'b1011;
                current_digit = m_ones;
            end
            2'b11: begin
                //activate Digit 4 (NX:XX)
                an = 4'b0111;
                current_digit = m_tens;
            end
        endcase

        //handle blinking
        if (adjust) begin
            //blinking is done by setting the anodes for those digits to the current state of clk_blink
            if (select) begin
                //blink seconds
                an[0] = an[0] | clk_blink;  //using OR since anodes are reverse logic (0 = ON, 1 = OFF)
                an[1] = an[1] | clk_blink;
            end else begin
                an[2] = an[2] | clk_blink;
                an[3] = an[3] | clk_blink;
            end
        end
    end


    /*
     * encode segment mapping into binary
     *
     *        a (0)
     *       -------
     *   f  |       | b
     *   (5)|  g(6) | (1)
     *       -------
     *   e  |       | c
     *   (4)|       | (2)
     *       -------
     *        d (3)
     *
     * 0 = Segment ON, 1 = Segment OFF
     * seg = [g, f, e, d, c, b, a]
     */
    always @(*) begin
        case(current_digit)
            4'd0:
                seg = 7'b1000000;
            4'd1:
                seg = 7'b1111001;
            4'd2:
                seg = 7'b0100100;
            4'd3:
                seg = 7'b0110000;
            4'd4:
                seg = 7'b0011001;
            4'd5:
                seg = 7'b0010010;
            4'd6:
                seg = 7'b0000010;
            4'd7:
                seg = 7'b1111000;
            4'd8:
                seg = 7'b0000000;
            4'd9:
                seg = 7'b0010000;
            default:
                seg = 7'b1111111;
        endcase
    end


endmodule