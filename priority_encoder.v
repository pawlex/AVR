
module priority_encoder ( input [3:0] irq_lines , output iflag, output reg [1:0] ivect );

//reg [1:0] ivect;

always @(*) begin
    if (irq_lines[0])       ivect = 0;
    else if (irq_lines[1])  ivect = 1;
    else if (irq_lines[2])  ivect = 2;
    else if (irq_lines[3])  ivect = 3;
    else                    ivect = 0;
end

assign	iflag = |irq_lines;

endmodule
