module booth_nxn_tb();
reg [5:0]multiplicand;
reg [5:0]multiplier;
wire [11:0]product;
booth_nxn #(.n(6)) vut(multiplicand,multiplier,product);
initial begin
multiplicand=6'b010101;multiplier=6'b101010;
#10 multiplicand=6'b011010;multiplier=6'b011010;
$monitor("time=%0t,multiplicand=%0b,multiplier=%0b,product=%0b",$time,multiplicand,multiplier,product);
#20 $finish;
end
endmodule
