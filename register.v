module register #(
	parameter width  = 8
)
(
	input  wire       clk;
	input  wire       reset_n,
	input  wire       Enb,
	output wire [2:0] oColour,
	output wire [1:0] oDelay,
	output wire [2:0] oBox,
);

	localparam rand = 8'b10100110;

	wire 				fedbk;
	reg [3:0] 			shift;
	reg [7:0] register;

	always @(posedge clk or negedge reset_n) begin
        case ({!reset_n, Enb, (shift == cycle)})
    		3'b000: begin
        	shift   <= 0;
        	oValid  <= 0;
        	register <= rand;
        	oValid  <= 1'b0;
    	end

    	3'b001: begin
        	oValid   <= 1'b0;
        	register <= {fedbk, register[7:1]};
        	shift    <= shift + 1'b1;
    	end

    	3'b010: begin
        	oValid   <= 1;
        	shift    <= 4'b0;
    	end

    	default: begin
        	oValid   <= 1'b0;
    	end
	endcase


	assign oColour = register[2:0];
	assign fedbk= ^register[7:0];
	assign oBox    = register[2:0];
	assign oDelay  = register[1:0];
endmodule 