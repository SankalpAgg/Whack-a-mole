module WhacAMole (
  
   input  wire       clk,  
   input  wire       reset_m,
   inout             PS2_CLK, 
   inout             PS2_DAT, 
  
   output wire [7:0] VGA_R,
   output wire [7:0] VGA_G,
   output wire [7:0] VGA_B,
   output wire       VGA_HS,
   output wire       VGA_VS,
   output wire       VGA_BLANK,
   output wire       VGA_SYNC,
   output wire       VGA_CLK
);



wire [2:0] oColour;
wire [8:0] oX;
wire [7:0] oY;
wire       oPlot;


wire       keyboard_reset;
wire [7:0] iKeyboard_data;
wire       iKeyboard_data_en;

assign keyboard_reset = !reset_m;

PS2_Controller u1(
   .CLOCK_50(clk),
   .reset(keyboard_reset),
   // Bidirectionals
   .PS2_CLK(PS2_CLK), // PS2 Clock
   .PS2_DAT(PS2_DAT), // PS2 Data
   .received_data(iKeyboard_data),
   .received_data_en(iKeyboard_data_en)  // If 1 - new data has been received
);

Data u2 (
   .clk(clk),
   .reset_m(reset_m),
   .iKeyboard_data(iKeyboard_data),
   .iKeyboard_data_en(iKeyboard_data_en),
   .oColour(oColour),
   .oX(oX),
   .oY(oY),
   .oPlot(oPlot)
);

vga_adapter vga(
   .reset_m(reset_m),
   .clk(clk),
   .colour(oColour),
   .x(oX), 
   .y(oY), 
   .plot(oPlot),
   .VGA_R(VGA_R),
   .VGA_G(VGA_G),
   .VGA_B(VGA_B),
   .VGA_HS(VGA_HS),
   .VGA_VS(VGA_VS),
   .VGA_BLANK(VGA_BLANK),
   .VGA_SYNC(VGA_SYNC),
   .VGA_CLK(VGA_CLK)
);

endmodule

