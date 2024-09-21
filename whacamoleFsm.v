module whacamoleFsm(

input wire clk,
input wire reset_m,
input wire [7:0] iKeyboard_data,
input wire iKeyboard_data_en,
input [1:0] del, 
input [2:0] block, 
input [2:0] col, 


output reg [2:0] Scr,
output reg oPlotBox,
output reg [8:0] oStart_X,
output reg [7:0] oStart_Y,
output reg [2:0] col
output reg [3:0] extoScore,
output [6:0] dis
);

//hex u1(.c(extoScore), .display(dis))
localparam nothing        = 4'b0000;
localparam Box = 4'b0001;
localparam input  = 4'b0100;
localparam scrUp  = 4'b0101;



localparam firstBox       = 3'b101;
localparam secondBox       = 3'b100;
localparam thirdBox       = 3'b011;
localparam fourthBox       = 3'b010;
localparam fifthBox       = 3'b111;
localparam sixthBox       = 3'b011;

localparam 1sec       = 2'b00;
localparam 1.5sec   = 2'b01;

localparam   1secDelay    = 50000000;
localparam 1.5secDelay = 75000000;

localparam Q_KEY       = 8'b00010101;
localparam W_KEY       = 8'b00011101;
localparam E_KEY       = 8'b00100100;
localparam A_KEY       = 8'b00011100;
localparam S_KEY       = 8'b00011011;
localparam D_KEY       = 8'b00100011;

reg [3:0] NextState;
reg [3:0] CurrState;

reg [2:0] Current_Box;



always @(posedge clk,negedge reset_m) 
begin
   if (!reset_m) 
begin
      Delay_Counter <= 27'b0
end
   else if ((Delay_Counter == 1secDelay)
begin
      Delay_Counter <= 0;
end
   else if ((Delay_Counter == 1.5secDelay - 1) && del == 1.5sec) 
begin
      Delay_Counter <= 0;
end
   else if (En_Counter) 
begin
      Delay_Counter <= Delay_Counter + 2'b01;
end
   else 
begin
      Delay_Counter <= 2'b00;
   end
end

always @(posedge clk,negedge reset_m) 
case(!reset_m)
1'b0 : begin
 CurrState <= 4"b0000;
end
default: CurrState <= NextState;
endcase
end
end

always @(posedge iClock,negedge iResetn) begin
  case(1'b0)
!reset_m: begin 
Box <= firstBox;
end
Box <= sixthBox: begin
Box <= firstBox;
end
CurrState == nothing && Box != sixthBox: begin
Box <= Box + 2'b01;
end
endcase
end

always @(posedge clk,negedge reset_m) 
begin
   if (!reset_m) 
begin
      oScore    <= 3'b000;
end
   else if (oScore == 3'b101) 
begin
      oScore    <= 3'b000;
      Game_Over <= 1'b1;
end
   else if (NextState == scrUp) 
begin
      oScore    <= oScore + 3'b001;
      Game_Over <= 1'b0;
   end
end

always @(*) begin

   case (CurrState)

      nothing: NextState = (!Game_Over) ? Box : nothing;

      Box: NextState = (Box == sixthBox) ? Box : input;

      Box: NextState = (iValid) ? Box : input;

      Box: NextState = (iDone) ? inputwait : Box;

      inputwait: NextState = (iKeyboard_data_en && !Delay_Done) ?

                        ((iKeyboard_data == Q_KEY && block
                      == firstBox) ||

                         (iKeyboard_data == W_KEY && block
                         == secondbox) ||

                         (iKeyboard_data == E_KEY && block
                         == thirdBox) ||

                         (iKeyboard_data == R_KEY && block
                         == fourthBox) ||

                         (iKeyboard_data == T_KEY && block
                         == fifthBox) ||

                         (iKeyboard_data == Y_KEY && block
                         == sixthBox)) ? scrUp : inputwait

                      : (Delay_Done) ? start : inputwait;

      scrUp: NextState = (oScore == 5) ? nothing : start;

      default: NextState = nothing;

   endcase

end

always @(*) begin
   scoreUp = 1'b0;
   oPlotBox      = 1'b0;
   oLFSR_En      = 1'b0;
   oStart_X      = 9'b0;
   oStart_Y      = 8'b0;
   col       = 3'b0;
   En_Counter    = 1'b0;
   if (CurrState == Box) 
begin
      oPlotBox = 1'b1;
      col  = 3'b111; 
      if (Box == firstBox)
end
 begin
         oStart_X = 134;
         oStart_Y = 36;
      end
      else if (Box == secondBOo) 
begin
         oStart_X = 40;
         oStart_Y = 36;
      end
      else if (Box == thirdBox) 
begin
         oStart_X = 220;
         oStart_Y = 50;
      end
      else if (Box == fourthBox) 
begin
         oStart_X = 134;
         oStart_Y = 50;
      end
      else if (Box == fifthBox) 
begin
         oStart_X = 135;
         oStart_Y = 154;
      end
      else begin
         oStart_X = 134;
         oStart_Y = 220;
      end
   end
   else if (CurrState == inputwait) 
begin
      En_Counter = 1'b1;
   end
   else if (CurrState == scrUp) 
begin
      scrUp = 1'b1;
   end
   else 
begin
      scrUp = 1'b0;
      oPlotBox      = 1'b0;
      oLFSR_En      = 1'b0;
      oStart_X      = 9'b0;
      oStart_Y      = 8'b0;
      col       = 3'b0;
      En_Counter    = 1'b0;
   end
end

endmodule

module hex(c,display);
input [3:0]c;
output [6:0]display;
assign display[0] = !((!c[3] & !c[2] & !c[1] & !c[0]) | (!c[3] & !c[2] & c[1] & !c[0]) | (!c[3] & !c[2] & c[1] & c[0]) | (!c[3] & c[2] & !c[1] & c[0]) | (!c[3] & c[2] & c[1] & !c[0]) | (!c[3] & c[2] & c[1] & c[0]) | (c[3] & !c[2] & !c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & c[0]) | (c[3] & !c[2] & c[1] & !c[0]) | (c[3] & c[2] & c[1] & !c[0]) | (c[3] & c[2] & c[1] & c[0]));
assign display[1] = !((!c[3] & !c[2] & !c[1] & !c[0]) | (!c[3] & !c[2] & !c[1] & c[0]) | (!c[3] & !c[2] & c[1] & !c[0]) | (!c[3] & !c[2] & c[1] & c[0]) | (!c[3] & c[2] & !c[1] & !c[0]) | (!c[3] & c[2] & c[1] & c[0]) | (c[3] & !c[2] & !c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & c[0]) | (c[3] & !c[2] & c[1] & !c[0]) | (c[3] & c[2] & !c[1] & c[0]));
assign display[2] = !((!c[3] & !c[2] & !c[1] & !c[0]) | (!c[3] & !c[2] & !c[1] & c[0]) | (!c[3] & !c[2] & c[1] & c[0]) | (!c[3] & c[2] & !c[1] & !c[0]) | (!c[3] & c[2] & !c[1] & c[0]) | (!c[3] & c[2] & c[1] & !c[0]) | (!c[3] & c[2] & c[1] & c[0]) | (c[3] & !c[2] & !c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & c[0]) | (c[3] & !c[2] & c[1] & !c[0]) | (c[3] & !c[2] & c[1] & c[0]) | (c[3] & c[2] & !c[1] & c[0]));
assign display[3] = !((!c[3] & !c[2] & !c[1] & !c[0]) | (!c[3] & !c[2] & c[1] & !c[0]) | (!c[3] & !c[2] & c[1] & c[0]) | (!c[3] & c[2] & !c[1] & c[0]) | (!c[3] & c[2] & c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & c[0]) | (c[3] & !c[2] & c[1] & c[0]) | (c[3] & c[2] & !c[1] & !c[0]) | (c[3] & c[2] & !c[1] & c[0]) | (c[3] & c[2] & c[1] & !c[0]));
assign display[4] = !((!c[3] & !c[2] & !c[1] & !c[0]) | (!c[3] & !c[2] & c[1] & !c[0]) | (!c[3] & c[2] & !c[1] & c[0]) | (c[3] & !c[2] & !c[1] & !c[0]) | (c[3] & !c[2] & c[1] & !c[0]) | (c[3] & !c[2] & c[1] & c[0]) | (c[3] & c[2] & !c[1] & !c[0]) | (c[3] & c[2] & !c[1] & c[0]) | (c[3] & c[2] & c[1] & !c[0]) | (c[3] & c[2] & c[1] & c[0]));
assign display[5] = !((!c[3] & !c[2] & !c[1] & !c[0]) | (!c[3] & c[2] & !c[1] & !c[0]) | (!c[3] & c[2] & !c[1] & c[0]) | (!c[3] & c[2] & c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & c[0]) | (c[3] & !c[2] & c[1] & !c[0]) | (c[3] & !c[2] & c[1] & c[0]) | (c[3] & c[2] & !c[1] & !c[0]) | (c[3] & c[2] & c[1] & !c[0]) | (c[3] & c[2] & c[1] & c[0]));
assign display[6] = !((!c[3] & !c[2] & c[1] & !c[0]) | (!c[3] & !c[2] & c[1] & c[0]) | (!c[3] & c[2] & !c[1] & !c[0]) | (!c[3] & c[2] & !c[1] & c[0]) | (!c[3] & c[2] & c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & !c[0]) | (c[3] & !c[2] & !c[1] & c[0]) | (c[3] & !c[2] & c[1] & !c[0]) | (c[3] & !c[2] & c[1] & c[0]) | (c[3] & c[2] & !c[1] & !c[0]) | (c[3] & c[2] & !c[1] & c[0]) | (c[3] & c[2] & c[1] & !c[0]) | (c[3] & c[2] & c[1] & c[0]));


endmodule