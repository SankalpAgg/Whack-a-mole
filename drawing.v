module drawing(
   // inputs
   input  wire       clk,
   input  wire       reset_n;
   input  wire       iPlotBox,
   input  wire [8:0] iStart_X,
   input  wire [7:0] iStart_Y,
   input  wire [2:0] iColour,

   // outputs
   output wire [2:0] oColour,
   output wire [8:0] oX,
   output wire [7:0] oY,
   output reg        oPlot,
   output reg        oDone
);


localparam horizontal = 50;
localparam vertical = 36;
localparam loc = 40;
localparam poc = 30;

localparam hogaya     = 2'b11;
localparam drawing = 2'b01;
localparam first     = 2'b00;

reg [1:0] next_state;
reg [1:0] current_state;

reg       en_counters;
reg [5:0] horizontalkocountkaro;
reg [5:0] verticlekocountkaro;

reg [8:0] temp_x;
reg [7:0] temp_y;
reg [2:0] temp_colour;

always @(posedge clk,negedge reset_n) begin
   if (!iResetn) begin                                                                                                                                                          
      current_state <= 2'b00;
   end
   else begin
      current_state <= next_state;
   end
end

always @(*) begin
    oDone       = 1'b0;
    en_counters = 1'b0;
    oPlot       = 1'b0;

    case (current_state)
        drawing: begin
            en_counters = 1'b1;
            oPlot       = 1'b1;
        end

        hogaya: oDone = 1'b1;

        default: begin
            oDone       = 1'b0;
            en_counters = 1'b0;
            oPlot       = 1'b0;
        end
    endcase
end

always @(posedge clk,negedge reset_n) begin
case(current_state)
   if (!reset_n) begin
      horizontalkocountkaro <= 6'b0;
      verticlekocountkaro <= 6'b0;
      temp_x      <= 9'b0;
      temp_y      <= 8'b0;
      temp_colour <= 3'b0;
   end
   else if (current_state == first || current_state == hogaya) begin
      temp_x      <= iStart_X;
      temp_y      <= iStart_Y;
      temp_colour <= iColour;
   end
   else if ((verticlekocountkaro == V_SIZE - 1) && (horizontalkocountkaro== horizontal- 1)) begin
      horizontalkocountkaro <= 6'b0;
      verticlekocountkaro <= 6'b0;
   end
   else if (en_counters) begin
      horizontalkocountkaro <= horizontalkocountkaro + 1'b1;
      temp_x    <= temp_x + 1'b1;
   end
end  

always @(*) begin
case (current_state)
    drawing: begin
        case ({verticlekocountkaro == vertical - 1, horizontalkocountkaro == horizontal - 1})
            2'b11:  next_state = hogaya;
            default:  next_state = drawing;
        endcase

    hogaya:  next_state = first;

    default:  next_state = first;
endcase

   case (!iPlotBox)
    drawing: next_state = drawing;
    default:  next_state = first;
endcase
end


assign oX      = temp_x;s
assign oY      = temp_y;
assign oColour = temp_colour;

endmodule