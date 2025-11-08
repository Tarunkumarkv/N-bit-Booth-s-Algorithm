module booth_nxn#(parameter n=4)(multiplicand,multiplier,product);
input [n-1:0]multiplicand;
input [n-1:0]multiplier;
output reg [2*n-1:0]product;
reg [n-1:0]A;
reg [2*n:0]partial_product;
reg q_1;
integer i;
always@(*)
begin
A=0;
q_1=0;
partial_product={A,multiplier,q_1};
for(i=n-1;i>=0;i=i-1)begin
case({partial_product[1],partial_product[0]})
2'b01:partial_product[2*n:n+1]=partial_product[2*n:n+1]+multiplicand;
2'b10:partial_product[2*n:n+1]=partial_product[2*n:n+1]-multiplicand;
default:partial_product=partial_product;
endcase
partial_product={partial_product[2*n],partial_product[2*n:1]};
end
product=partial_product[2*n:1];
end
endmodule
