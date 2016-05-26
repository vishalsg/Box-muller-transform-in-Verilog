

module randist (clk,rst,pushin,U1,U2,pushout,Z);

parameter [63:0] constant= 64'h3FF0_0000_0000_0000;  //Decimal Value = 1.0E0 
parameter fpw = 63; 

input [63:0] U1,U2;
input clk,rst,pushin;

output [63:0] Z;
output pushout;

reg [63:0] U1_a,U2_a;
reg pushin_a;
wire pushout_denorm_1,pushout_denorm_2,pushout_norm_1,pushout_norm_2,pushout_sqrtln,pushout_sin;

wire pushin_sqrtln_top,pushout_sqrtln_top,pushin_sin_top,pushout_sin_top;


wire [fpw:0] delta_denorm_1,delta_denorm_2;
wire [8:0] fract_lt_1;
wire [9:0] fract_lt_2;

wire [63:0] delta_u1,delta_u2; 
wire [63:0] A_u1,B_u1,C_u1,D_u1,A_u2,B_u2,C_u2;

wire [63:0] a,b;


always @(posedge clk or posedge rst) begin
    if(rst==1) begin
        U1_a      <= #1 0;
        U2_a      <= #1 0;
        pushin_a  <= #1 0;
    end else begin
        U1_a      <= #1 U1;
        U2_a      <= #1 U2;
        pushin_a  <= #1 pushin;    
    end
end

denorm Denorm1 (.U1(U1_a),.clk(clk),.rst(rst),.pushin(pushin_a),.pushout(pushout_denorm_1),.delta_denorm(delta_denorm_1),.fract_lt(fract_lt_1));

norm #(.fpw(fpw)) Norm1 (.delta_denorm(delta_denorm_1),.clk(clk),.rst(rst),.pushin(pushout_denorm_1),.pushout(pushout_norm_1),.delta(delta_u1)); 


denorm1 Denorm2 (.U1(U2_a),.clk(clk),.rst(rst),.pushin(pushin_a),.pushout(pushout_denorm_2),.delta_denorm(delta_denorm_2),.fract_lt(fract_lt_2));

norm #(.fpw(fpw)) Norm2 (.delta_denorm(delta_denorm_2),.clk(clk),.rst(rst),.pushin(pushout_denorm_2),.pushout(pushout_norm_2),.delta(delta_u2));


sqrtln sqrtln_M0 (.vin(fract_lt_1),.clk(clk),.rst(rst),.pushin(pushout_denorm_1),.pushout(pushout_sqrtln),.A(A_u1),.B(B_u1),.C(C_u1),.D(D_u1));

sin sin_M0 (.vin(fract_lt_2),.clk(clk),.rst(rst),.pushin(pushout_denorm_2),.pushout(pushout_sin),.A(A_u2),.B(B_u2),.C(C_u2));

/**********************************************/

assign pushin_sqrtln_top = pushout_norm_1 & pushout_sqrtln;

sqrtln_top sqrtln1 (.A(A_u1),.B(B_u1),.C(C_u1),.D(D_u1),.delta(delta_u1),.clk(clk),.rst(rst),.pushin(pushin_sqrtln_top),.pushout(pushout_sqrtln_top),.a(a));


/*******************************************/

assign pushin_sin_top = pushout_norm_2 & pushout_sin;

sin_top sin1 (.A(A_u2),.B(B_u2),.C(C_u2),.delta(delta_u2),.clk(clk),.rst(rst),.pushin(pushin_sin_top),.pushout(pushout_sin_top),.b(b));


/************************************************/

assign pushin_ab = pushout_sqrtln_top & pushout_sin_top;

fpmul fpmul_ab (.a(a),.b(b),.c(constant),.clk(clk),.rst(rst),.pushin(pushin_ab),.pushout(pushout),.r(Z));


endmodule
