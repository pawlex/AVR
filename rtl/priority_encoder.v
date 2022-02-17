// FIXUP: Hazard free interrupt assertion and vector generation.
// PK

module priority_encoder (
           input clk,
           input rst,
           input [NUM_VECTORS-1:0] irq_lines,
           output iflag,
           output reg [NVL2-1:0] ivect
       );

parameter NUM_VECTORS = 4;
localparam NVL2 = $clog2(NUM_VECTORS);
// flopped input stage - pk
reg [3:0] irq_lines_ff;

genvar i;
generate
    for(i=0; i<NUM_VECTORS; i=i+1) begin
        always @(posedge clk or posedge rst)
            if(rst) irq_lines_ff[i] <= 1'b0;
            else irq_lines_ff[i] <= irq_lines[i] ? 1 : 0;
    end
endgenerate

always @( * )
begin
    if (irq_lines_ff[0])
        ivect = 0;
    else if (irq_lines_ff[1])
        ivect = 1;
    else if (irq_lines_ff[2])
        ivect = 2;
    else if (irq_lines_ff[3])
        ivect = 3;
    else
        ivect = 0;
end

//assign iflag = irq_lines_ff == 1 ? 1 : 0;
assign iflag = irq_lines_ff == 0 ? 0 : 1;

endmodule
