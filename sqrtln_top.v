

module sqrtln_top (A,B,C,D,delta,clk,rst,pushin,pushout,a);

input [63:0] A,B,C,D,delta;
input clk,rst,pushin;

output [63:0] a;
output pushout;




wire pushin_mul_1,pushout_m11,pushout_m12,pushout_m13,pushout_m21,pushin_mul_2,pushout_a41;
reg pushout_s11,pushout_s12,pushout_s13,pushout_s14,pushout_s15,pushout_s16,pushout_s17,pushout_s18,pushout_s19,pushout_s110,pushout_s111 ,pushout_s21,pushout_s22,pushout_s23,pushout_s24,pushout_s25,pushout_s26,pushout_s27,pushout_s28,pushout_s29,pushout_s210,pushout_s211;

wire [63:0] delta_cube,B_delta_sq,C_delta;
reg [63:0] D_s1,D_s2,D_s3,D_s4,D_s5,D_s6,D_s7,D_s8,D_s9,D_s10,D_s11 ,A_s1,A_s2,A_s3,A_s4,A_s5,A_s6,A_s7,A_s8,A_s9,A_s10,A_s11;

wire [63:0] A_delta_cube;
reg [63:0] B_delta_sq_s21,B_delta_sq_s22,B_delta_sq_s23, B_delta_sq_s24,B_delta_sq_s25,B_delta_sq_s26,B_delta_sq_s27,B_delta_sq_s28,B_delta_sq_s29,B_delta_sq_s210,B_delta_sq_s211 ,C_delta_s21,C_delta_s22,C_delta_s23,C_delta_s24,C_delta_s25,C_delta_s26,C_delta_s27,C_delta_s28,C_delta_s29,C_delta_s210,C_delta_s211 ,D_s3_s21,D_s3_s22,D_s3_s23,D_s3_s24,D_s3_s25,D_s3_s26,D_s3_s27,D_s3_s28,D_s3_s29,D_s3_s210,D_s3_s211;

wire [63:0] A_B,C_D;

parameter [63:0] constant= 64'h3FF0_0000_0000_0000;  //Decimal Value = 1.0E0 

/******************** sqrt(-2 * ln(U1)) *********************************/


//assign pushin_mul_1 = pushout_norm_1 & pushout_sqrtln; 

assign pushout = pushout_a41;


fpmul fpmul_sqrtln_m11 (.a(delta),.b(delta),.c(delta),.clk(clk),.rst(rst),.pushin(pushin),.pushout(pushout_m11),.r(delta_cube));

fpmul fpmul_sqrtln_m12 (.a(delta),.b(delta),.c(B),.clk(clk),.rst(rst),.pushin(pushin),.pushout(pushout_m12),.r(B_delta_sq));

fpmul fpmul_sqrtln_m13 (.a(delta),.b(C),.c(constant),.clk(clk),.rst(rst),.pushin(pushin),.pushout(pushout_m13),.r(C_delta));


            //********Dummy stage for multiplication stage 1 ********//

always @(posedge clk or posedge rst) begin
    if(rst) begin
        D_s1 <= #1 0;
        A_s1 <= #1 0;
        pushout_s11 <= #1 0;
        
        D_s2 <= #1 0;
        A_s2 <= #1 0;
        pushout_s12 <= #1 0;
        
        D_s3 <= #1 0;
        A_s3 <= #1 0;
        pushout_s13 <= #1 0;
        
        D_s4 <= #1 0;
        A_s4 <= #1 0;
        pushout_s14 <= #1 0;
        
        D_s5 <= #1 0;
        A_s5 <= #1 0;
        pushout_s15 <= #1 0;
        
        D_s6 <= #1 0;
        A_s6 <= #1 0;
        pushout_s16 <= #1 0;
        
        D_s7 <= #1 0;
        A_s7 <= #1 0;
        pushout_s17 <= #1 0;

        D_s8 <= #1 0;
        A_s8 <= #1 0;
        pushout_s18 <= #1 0;
        
        D_s9 <= #1 0;
        A_s9 <= #1 0;
        pushout_s19 <= #1 0;
        
        D_s10 <= #1 0;
        A_s10 <= #1 0;
        pushout_s110 <= #1 0;
        
        D_s11 <= #1 0;
        A_s11 <= #1 0;
        pushout_s111 <= #1 0;
        
    end else begin
        D_s1 <= #1 D;
        A_s1 <= #1 A;
        pushout_s11 <= #1 pushin;
        
        D_s2 <= #1 D_s1;
        A_s2 <= #1 A_s1;
        pushout_s12 <= #1 pushout_s11;
        
        D_s3 <= #1 D_s2;
        A_s3 <= #1 A_s2;
        pushout_s13 <= #1 pushout_s12;
        
        D_s4 <= #1 D_s3;
        A_s4 <= #1 A_s3;
        pushout_s14 <= #1 pushout_s13;
        
        D_s5 <= #1 D_s4;
        A_s5 <= #1 A_s4;
        pushout_s15 <= #1 pushout_s14;
        
        D_s6 <= #1 D_s5;
        A_s6 <= #1 A_s5;
        pushout_s16 <= #1 pushout_s15;
        
        D_s7 <= #1 D_s6;
        A_s7 <= #1 A_s6;
        pushout_s17 <= #1 pushout_s16;

        D_s8 <= #1 D_s7;
        A_s8 <= #1 A_s7;
        pushout_s18 <= #1 pushout_s17;
        
        D_s9 <= #1 D_s8;
        A_s9 <= #1 A_s8;
        pushout_s19 <= #1 pushout_s18;
        
        D_s10 <= #1 D_s9;
        A_s10 <= #1 A_s9;
        pushout_s110 <= #1 pushout_s19;
        
        D_s11 <= #1 D_s10;
        A_s11 <= #1 A_s10;
        pushout_s111 <= #1 pushout_s110;
    end
    
end


fpmul fpmul_sqrtln_m21 (.a(A_s11),.b(delta_cube),.c(constant),.clk(clk),.rst(rst),.pushin((pushout_m11 & pushout_s111)),.pushout(pushout_m21),.r(A_delta_cube));


assign pushin_mul_2 = pushout_m12 & pushout_m13 & pushout_s111;

always @(posedge clk or posedge rst) begin
    if(rst) begin
       B_delta_sq_s21 <= #1 0; 
       C_delta_s21    <= #1 0; 
       D_s3_s21       <= #1 0; 
       pushout_s21    <= #1 0; 
                                 
       B_delta_sq_s22 <= #1 0;  
       C_delta_s22    <= #1 0;  
       D_s3_s22       <= #1 0;  
       pushout_s22    <= #1 0;  
                                 
       B_delta_sq_s23 <= #1 0;  
       C_delta_s23    <= #1 0;  
       D_s3_s23       <= #1 0;  
       pushout_s23    <= #1 0;
       
       B_delta_sq_s24 <= #1 0; 
       C_delta_s24    <= #1 0; 
       D_s3_s24       <= #1 0; 
       pushout_s24    <= #1 0; 
                                 
       B_delta_sq_s25 <= #1 0;  
       C_delta_s25    <= #1 0;  
       D_s3_s25       <= #1 0;  
       pushout_s25    <= #1 0;  
                                 
       B_delta_sq_s26 <= #1 0;  
       C_delta_s26    <= #1 0;  
       D_s3_s26       <= #1 0;  
       pushout_s26    <= #1 0;
       
       B_delta_sq_s27 <= #1 0; 
       C_delta_s27    <= #1 0; 
       D_s3_s27       <= #1 0; 
       pushout_s27    <= #1 0; 
                                 
       B_delta_sq_s28 <= #1 0;  
       C_delta_s28    <= #1 0;  
       D_s3_s28       <= #1 0;  
       pushout_s28    <= #1 0;  
                                 
       B_delta_sq_s29 <= #1 0;  
       C_delta_s29    <= #1 0;  
       D_s3_s29       <= #1 0;  
       pushout_s29    <= #1 0;
       
       B_delta_sq_s210 <= #1 0; 
       C_delta_s210    <= #1 0; 
       D_s3_s210       <= #1 0; 
       pushout_s210    <= #1 0; 
                                 
       B_delta_sq_s211 <= #1 0;  
       C_delta_s211    <= #1 0;  
       D_s3_s211       <= #1 0;  
       pushout_s211    <= #1 0;  
                                 
        
    end else begin
      B_delta_sq_s21    <= #1 B_delta_sq;
      C_delta_s21       <= #1 C_delta;
      D_s3_s21          <= #1 D_s11;
      pushout_s21       <= #1 pushout_s111;
                       
      B_delta_sq_s22    <= #1	B_delta_sq_s21 	 ;
      C_delta_s22       <= #1	C_delta_s21    	 ;
      D_s3_s22          <= #1	D_s3_s21       	 ;
      pushout_s22       <= #1	pushout_s21    	 ;
                       
      B_delta_sq_s23    <= #1	B_delta_sq_s22		 ;
      C_delta_s23       <= #1	C_delta_s22   		 ;
      D_s3_s23          <= #1	D_s3_s22   		 ;
      pushout_s23       <= #1	pushout_s22   		 ;
      
       B_delta_sq_s24 <= #1 	B_delta_sq_s23 		; 
       C_delta_s24    <= #1 	C_delta_s23    		; 
       D_s3_s24       <= #1 	D_s3_s23       		; 
       pushout_s24    <= #1 	pushout_s23    		; 
                            			    
       B_delta_sq_s25 <= #1 	B_delta_sq_s24		;  
       C_delta_s25    <= #1 	C_delta_s24   		;  
       D_s3_s25       <= #1 	D_s3_s24      		;  
       pushout_s25    <= #1 	pushout_s24   		;  
                            			    
       B_delta_sq_s26 <= #1 	B_delta_sq_s25		;  
       C_delta_s26    <= #1 	C_delta_s25   		;  
       D_s3_s26       <= #1 	D_s3_s25      		;  
       pushout_s26    <= #1 	pushout_s25   		;
                            			
       B_delta_sq_s27 <= #1 	B_delta_sq_s26		; 
       C_delta_s27    <= #1 	C_delta_s26   		; 
       D_s3_s27       <= #1 	D_s3_s26      		; 
       pushout_s27    <= #1 	pushout_s26   		; 
                            			    
       B_delta_sq_s28 <= #1 	B_delta_sq_s27		;  
       C_delta_s28    <= #1 	C_delta_s27   		;  
       D_s3_s28       <= #1 	D_s3_s27      		;  
       pushout_s28    <= #1 	pushout_s27   		;  
                            			    
       B_delta_sq_s29 <= #1 	B_delta_sq_s28		;  
       C_delta_s29    <= #1 	C_delta_s28   		;  
       D_s3_s29       <= #1 	D_s3_s28      		;  
       pushout_s29    <= #1 	pushout_s28   		;
                            			
       B_delta_sq_s210 <= #1	B_delta_sq_s29		; 
       C_delta_s210    <= #1	C_delta_s29   		; 
       D_s3_s210       <= #1	D_s3_s29      		; 
       pushout_s210    <= #1	pushout_s29   		; 
                            			   
       B_delta_sq_s211 <= #1	B_delta_sq_s210		;  
       C_delta_s211    <= #1	C_delta_s210   		;  
       D_s3_s211       <= #1	D_s3_s210      		;  
       pushout_s211    <= #1	pushout_s210   		;
    end
    
end


/******************************************************/

fpadd fpadd_sqrtln_a31 (.a(A_delta_cube),.b(B_delta_sq_s211),.clk(clk),.rst(rst),.pushin((pushout_s211 & pushout_m21)),.pushout(pushout_a31),.r(A_B));

fpadd fpadd_sqrtln_a32 (.a(C_delta_s211),.b(D_s3_s211),.clk(clk),.rst(rst),.pushin(pushout_s211),.pushout(pushout_a32),.r(C_D));


/********************************************************/

fpadd fpadd_sqrtln_a41 (.a(A_B),.b(C_D),.clk(clk),.rst(rst),.pushin((pushout_a31 & pushout_a32)),.pushout(pushout_a41),.r(a));

/**********************************************************/





endmodule
