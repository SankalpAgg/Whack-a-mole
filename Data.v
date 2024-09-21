module Data(clk, reset_m, iKeyboard_data, iKeyboard_data_en, oColour, oX, oY, oPlot);
   input  wire       clk;
   input  wire       reset_m;
   input  wire [7:0] iKeyboard_data;
   input  wire       iKeyboard_data_en;

   
   output wire [2:0] oColour;
   output wire [8:0] oX;
   output wire [7:0] oY;
   output wire       oPlot;

wire 	     iPlotBox;
wire [8:0] xstart;
wire [7:0] ystart;
wire [2:0] col;
wire 	     oDone;


wire 	     Enb;
wire [2:0] LFSR_oColour;
wire [2:0] LFSR_oBoX;
wire [1:0] LFSR_oDelay;
wire       oValid;


wire [2:0] oScore;
wire       oScore_update;
wire [4:0] mem_addr;
wire [2:0] mem_out;

assign mem_addr = 5'b0;


drawing u1(
   .clk(clk),.reset_m(reset_m),.iPlotBox(iPlotBox),.xstart(iStart_X),.ystart(iStart_Y), .col(iColour),.oColour(oColour),.oX(oX),.oY(oY),.oPlot(oPlot),.oDone(oDone));

whacamoleFsm fsm(.clk(clk), .reset_m(reset_m),.iKeyboard_data(iKeyboard_data),.iKeyboard_data_en(iKeyboard_data_en),  .del(LFSR_oDelay), .col(LFSR_oColour),.oScore(oScore),.oScore_update(oScore_update),.oPlotBox(iPlotBox),.oStart_X(iStart_X),.oStart_Y(iStart_Y),.oColour(iColour));

register LFSR(.clk(clk),.reset_m(reset_m),.Enb(Enb),.oColour(LFSR_oColour),.oDelay(LFSR_oDelay),.oBox(LFSR_oBoX));
endmodule