module sin_top (A,B,C,delta,clk,rst,pushin,pushout,b);

input [63:0] A,B,C,delta;
input clk,rst,pushin;
output pushout;
output [63:0] b;

parameter [63:0] constant= 64'h3FF0_0000_0000_0000;  //Decimal Value = 1.0E0 

reg pushout_s11,pushout_s12,pushout_s13,pushout_s14,pushout_s15,pushout_s16,pushout_s17,pushout_s18,pushout_s19,pushout_s110,pushout_s111,pushout_s21,pushout_s22,pushout_s23,pushout_s24,pushout_s25,pushout_s41,pushout_s42,pushout_s43,pushout_s44,pushout_s45,pushout_s46,pushout_s47,pushout_s48,pushout_s49,pushout_s410,pushout_s411;
wire pushout_m11,pushout_m12,pushout_a21,pushout_a31;

reg [63:0] C_s11,C_s12,C_s13,C_s14,C_s15,C_s16,C_s17,C_s18,C_s19,C_s110,C_s111,C_s21,C_s22,C_s23,C_s24,C_s25;

wire [63:0] A_B;

wire [63:0] b_d;

reg [63:0] b_s41,b_s42,b_s43,b_s44,b_s45,b_s46,b_s47,b_s48,b_s49,b_s410,b_s411;

wire [63:0] A_delta_sq,B_delta;

assign pushout=pushout_s411;
assign b=b_s411;


fpmul fpmul_sin_m11 (.a(A),.b(delta),.c(delta),.clk(clk),.rst(rst),.pushin(pushin),.pushout(pushout_m11),.r(A_delta_sq));

fpmul fpmul_sin_m12 (.a(B),.b(delta),.c(constant),.clk(clk),.rst(rst),.pushin(pushin),.pushout(pushout_m12),.r(B_delta));


always @(posedge clk or posedge rst) begin
    if(rst) begin
        C_s11 <= #1 0;
        pushout_s11 <= #1 0;
        
        C_s12 <= #1 0;
        pushout_s12 <= #1 0;
        
        C_s13 <= #1 0;
        pushout_s13 <= #1 0;
        
        C_s14 <= #1 0;
        pushout_s14 <= #1 0;
        
        C_s15 <= #1 0;
        pushout_s15 <= #1 0;
        
        C_s16 <= #1 0;
        pushout_s16 <= #1 0;
        
        C_s17 <= #1 0;
        pushout_s17 <= #1 0;
        
        C_s18 <= #1 0;
        pushout_s18 <= #1 0;
        
        C_s19 <= #1 0;
        pushout_s19 <= #1 0;
        
        C_s110 <= #1 0;
        pushout_s110 <= #1 0;
        
        C_s111 <= #1 0;
        pushout_s111 <= #1 0;
        
    end else begin
        C_s11 <= #1 C;
        pushout_s11 <= #1 pushin;
        
        C_s12 <= #1 C_s11;
        pushout_s12 <= #1 pushout_s11;
        
        C_s13 <= #1 C_s12;
        pushout_s13 <= #1 pushout_s12;
        
        C_s14 <= #1 C_s13;
        pushout_s14 <= #1 pushout_s13;
        
        C_s15 <= #1 C_s14;
        pushout_s15 <= #1 pushout_s14;
        
        C_s16 <= #1 C_s15;
        pushout_s16 <= #1 pushout_s15;
        
        C_s17 <= #1 C_s16;
        pushout_s17 <= #1 pushout_s16;
        
        C_s18 <= #1 C_s17;
        pushout_s18 <= #1 pushout_s17;
        
        C_s19 <= #1 C_s18;
        pushout_s19 <= #1 pushout_s18;
        
        C_s110 <= #1 C_s19;
        pushout_s110 <= #1 pushout_s19;
        
        C_s111 <= #1 C_s110;
        pushout_s111 <= #1 pushout_s110;
    end
    
end

/****************************************************/

fpadd fpadd_sin_a21 (.a(A_delta_sq),.b(B_delta),.clk(clk),.rst(rst),.pushin((pushout_m11 & pushout_m12)),.pushout(pushout_a21),.r(A_B));

always @(posedge clk or posedge rst) begin
    if(rst) begin
        C_s21 <= #1 0;
        pushout_s21 <= #1 0;
        
        C_s22 <= #1 0;
        pushout_s22 <= #1 0;
        
        C_s23 <= #1 0;
        pushout_s23 <= #1 0;
        
        C_s24 <= #1 0;
        pushout_s24 <= #1 0;
        
        C_s25 <= #1 0;
        pushout_s25 <= #1 0;
        
    end else begin
        C_s21 <= #1 C_s111;
        pushout_s21 <= #1 pushout_s111;
        
        C_s22 <= #1 C_s21;
        pushout_s22 <= #1 pushout_s21;
        
        C_s23 <= #1 C_s22;
        pushout_s23 <= #1 pushout_s22;
        
        C_s24 <= #1 C_s23;
        pushout_s24 <= #1 pushout_s23;
        
        C_s25 <= #1 C_s24;
        pushout_s25 <= #1 pushout_s24;
    end
    
end


/*************************************************/

fpadd fpadd_sin_a31 (.a(A_B),.b(C_s25),.clk(clk),.rst(rst),.pushin((pushout_s25 & pushout_a21)),.pushout(pushout_a31),.r(b_d));


always @(posedge clk or posedge rst) begin
    if(rst) begin
        b_s41 <= #1 0;
        pushout_s41 <= #1 0;
        
        b_s42 <= #1 0;
        pushout_s42 <= #1 0;
        
        b_s43 <= #1 0;
        pushout_s43 <= #1 0;
        
        b_s44 <= #1 0;
        pushout_s44 <= #1 0;
        
        b_s45 <= #1 0;
        pushout_s45 <= #1 0;
        
        b_s46 <= #1 0;
        pushout_s46 <= #1 0;
        
        b_s47 <= #1 0;
        pushout_s47 <= #1 0;
        
        b_s48 <= #1 0;
        pushout_s48 <= #1 0;
        
        b_s49 <= #1 0;
        pushout_s49 <= #1 0;
        
        b_s410 <= #1 0;
        pushout_s410 <= #1 0;
        
        b_s411 <= #1 0;
        pushout_s411 <= #1 0;

        
    end else begin
        b_s41 <= #1 b_d;
        pushout_s41 <= #1 pushout_a31;
        
        b_s42 <= #1 b_s41;
        pushout_s42 <= #1 pushout_s41;
        
        b_s43 <= #1 b_s42;
        pushout_s43 <= #1 pushout_s42;
        
        b_s44 <= #1 b_s43;
        pushout_s44 <= #1 pushout_s43;
        
        b_s45 <= #1 b_s44;
        pushout_s45 <= #1 pushout_s44;
        
        b_s46 <= #1 b_s45;
        pushout_s46 <= #1 pushout_s45;
        
        b_s47 <= #1 b_s46;
        pushout_s47 <= #1 pushout_s46;
        
        b_s48 <= #1 b_s47;
        pushout_s48 <= #1 pushout_s47;
        
        b_s49 <= #1 b_s48;
        pushout_s49 <= #1 pushout_s48;
        
        b_s410 <= #1 b_s49;
        pushout_s410 <= #1 pushout_s49;
        
        b_s411 <= #1 b_s410;
        pushout_s411 <= #1 pushout_s410;
    end
    
end



endmodule
