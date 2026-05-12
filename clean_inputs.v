// Take the raw inputs and debounce and stabilize them
// --------------- INPUTS ---------------
// clk_fast: 500 Hz (lower frequency for debouncing) clock input
// sw [1:0]: 2-bit switch input for select and adjust
// btnL: left button input for reset
// btnR: right button input for pause
// --------------- OUTPUTS ---------------
// select: select between seconds and minutes for adjustment
// adjust_mode: whether we are in adjust mode or not
// reset: reset count to 0
// pause: pause counting when adjust is on

module inputs(
    input clk_fast, // 500 Hz (lower frequency for debouncing) clock input
    input sw [1:0], // 2-bit switch input for select and adjust
    input btnL,
    input btnR,
    output select, // select between seconds and minutes for adjustment
    output adjust_mode, // whether we are in adjust mode or not
    output reset, // reset count to 0
    output pause // pause counting when adjust is on
);

reg [1:0] sw_hold, sw_sync; // 2-bit register to hold the synchronized switch values
reg btnL_hold, btnL_sync; // register to hold the synchronized value of btnL
reg btnR_hold, btnR_sync; // register to hold the synchronized value of btnR

// First feed the raw inputs into the hold registers on the positive edge of the fast clock
always @(posedge clk_fast) begin
    sw_hold <= sw; // capture the raw switch input
    btnL_hold <= btnL; // capture the raw button input
    btnR_hold <= btnR; // capture the raw button input

    // Then feed the hold registers into the sync registers on the next clock cycle
    sw_sync <= sw_hold; // synchronize the switch input
    btnL_sync <= btnL_hold; // synchronize the button input
    btnR_sync <= btnR_hold; // synchronize the button input
end

// assign the outputs based on the synchronized inputs
assign select = sw_sync[0]; // use the least significant bit of the switch for select
assign adjust_mode = sw_sync[1]; // use the most significant bit of the switch for adjust mode
assign reset = btnL_sync; // use the left button for reset
assign pause = btnR_sync; // use the right button for pause

endmodule

