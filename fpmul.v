/*
////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1996 - 2009 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    GN                 Jan. 22, 1996
//
// VERSION:   Simulation Architecture
//
// DesignWare_version: 896ac174
// DesignWare_release: C-2009.06-DWBB_0907
//
////////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------------
//
// ABSTRACT:  Five-Stage Pipelined Multiplier
//           A_width-Bits * B_width-Bits => A_width+B_width Bits
//           Operands A and B can be either both signed (two's complement) or 
//	     both unsigned numbers. TC determines the coding of the input operands.
//           ie. TC = '1' => signed multiplication
//	         TC = '0' => unsigned multiplication
//
//
//
// MODIFIED : GN  Jan. 25, 1996
//            Move component from DW03 to DW02
//	Jay Zhu, Nov 29, 1999: remove unit delay and simplify procedures
//---------------------------------------------------------------------------------


module DW02_mult_5_stage(A,B,TC,CLK,PRODUCT);
parameter	A_width = 8;
parameter	B_width = 8;
input	[A_width-1:0]	A;
input	[B_width-1:0]	B;
input			TC,CLK;
output	[A_width+B_width-1:0]	PRODUCT;

reg	[A_width+B_width-1:0]	PRODUCT,product_piped1,product_piped2,product_piped3;
wire	[A_width+B_width-1:0]	pre_product;

wire	[A_width-1:0]	temp_a;
wire	[B_width-1:0]	temp_b;
wire	[A_width+B_width-2:0]	long_temp1,long_temp2;

assign	temp_a = (A[A_width-1])? (~A + 1'b1) : A;
assign	temp_b = (B[B_width-1])? (~B + 1'b1) : B;

assign	long_temp1 = temp_a * temp_b;
assign	long_temp2 = ~(long_temp1 - 1'b1);

assign	pre_product = (TC)? (((A[A_width-1] ^ B[B_width-1]) && (|long_temp1))?
				{1'b1,long_temp2} : {1'b0,long_temp1})
			: A * B;

always @ (posedge CLK)
begin
	product_piped1 <= pre_product;
	product_piped2 <= product_piped1;
        product_piped3 <= product_piped2;
        PRODUCT <= product_piped3;
end

endmodule*/






module fpmul(a,b,c,clk,rst,pushin,pushout,r);

	input 		clk;
	input 		rst;
	input 		pushin; 	        // A valid a,b,c
	input [63:0] 	a,b,c;	// the a,b and c inputs
	output [63:0] 	r;	// the results from this multiply
	output 		pushout;		// indicates we have an answer this cycle
	
	reg 		pushout_1_q,pushout_2_q,pushout_3_q,pushout_2_piped1,pushout_2_piped2,pushout_2_piped3,pushout_2_piped4,pushout_1_piped1,pushout_1_piped2,pushout_1_piped3,pushout_1_piped4;
	
	reg 		sA,sB,sC;		// the signs of the a and b inputs
	reg   [10:0] 	expA, expB, expC;		// the exponents of each
	reg   [52:0] 	fractA, fractB, fractC_d,fractC_q,fractC_piped1,fractC_piped2,fractC_piped3,fractC_piped4;	// the fraction of A and B  present
	reg 		zeroA,zeroB,zeroC;	// a zero operand (special case for later)
	// result of the multiplication, rounded result, rounding constant
	reg   [159:0] 	mres_2_q,rconstant;
	wire  [158:0] 	mres_2_d;
	reg   [159:0] 	rres;
	wire  [105:0] 	mres_d;
	reg   [105:0] 	mres_q;
	reg 		any_zero_d,any_zero_1_q,any_zero_2_q,any_zero_2_piped1,any_zero_2_piped2,any_zero_2_piped3,any_zero_2_piped4,any_zero_1_piped1,any_zero_1_piped2,any_zero_1_piped3,any_zero_1_piped4;
	
	
	reg 		signres_d,signres_1_q,signres_2_q,signres_2_piped1,signres_2_piped2,signres_2_piped3,signres_2_piped4,signres_1_piped1,signres_1_piped2,signres_1_piped3,signres_1_piped4;		// sign of the result

	reg   [10:0] 	expres_d,expres_q,expres_d2,expres_1_d,expres_1_q,expres_2_d,expres_2_q,expres_1_piped1,expres_1_piped2,expres_1_piped3,expres_1_piped4,expres_2_piped1,expres_2_piped2,expres_2_piped3,expres_2_piped4;	// the exponent result
	
	
	reg   [10:0] 	expres_piped1,expres_piped2,expres_piped3,expres_piped4;
	
	
	reg   [63:0] 	resout,resout_q;	// the output value from the always block

assign r=resout_q;
assign pushout=pushout_3_q;


// latch the inputs...

//
// give the fields a name for convience
//


//=========================================================//

always @(*) begin
  sA = a[63];
  sB = b[63];
  sC = c[63];
  signres_d=sA^sB^sC;
  expA = a[62:52];
  expB = b[62:52];
  expC = c[62:52];
  fractA = { 1'b1, a[51:0]};
  fractB = { 1'b1, b[51:0]};
  fractC_d = { 1'b1, c[51:0]};
  zeroA = (a[62:0]==0)?1:0;
  zeroB = (b[62:0]==0)?1:0;
  zeroC = (c[62:0]==0)?1:0;
  //mres_d= fractA*fractB;
  //
  
  expres_2_d = expA+expB;
  expres_1_d = expC-11'd2045;
  any_zero_d = ((zeroA==1) || (zeroB==1) || (zeroC == 1)) ? 1:0;
end

DW02_mult_5_stage #(53,53) vishal1 (.A(fractA),.B(fractB),.TC(1'b0),.CLK(clk),.PRODUCT(mres_d));
    
    
    
     
 always @(posedge clk or posedge rst) begin
    if(rst) begin

	pushout_1_piped1     <= #1 0;  
        signres_1_piped1     <= #1 0; 
        fractC_piped1        <= #1 0; 
        expres_1_piped1      <= #1 0; 
        expres_2_piped1      <= #1 0; 
        any_zero_1_piped1    <= #1 0; 
        
        pushout_1_piped2     <= #1 0;  
        signres_1_piped2     <= #1 0;  
        fractC_piped2        <= #1 0;  
        expres_1_piped2      <= #1 0;  
        expres_2_piped2      <= #1 0;  
        any_zero_1_piped2    <= #1 0;  
        
        pushout_1_piped3     <= #1 0; 
        signres_1_piped3     <= #1 0; 
        fractC_piped3        <= #1 0; 
        expres_1_piped3      <= #1 0; 
        expres_2_piped3      <= #1 0; 
        any_zero_1_piped3    <= #1 0; 
        
        pushout_1_piped4     <= #1 0; 
        signres_1_piped4     <= #1 0; 
        fractC_piped4        <= #1 0; 
        expres_1_piped4      <= #1 0; 
        expres_2_piped4      <= #1 0; 
        any_zero_1_piped4    <= #1 0; 

    end else begin
        pushout_1_piped1     <= #1 pushin;
        signres_1_piped1     <= #1 signres_d;
        fractC_piped1        <= #1 fractC_d;
        expres_1_piped1      <= #1 expres_1_d;
        expres_2_piped1      <= #1 expres_2_d;
        any_zero_1_piped1    <= #1 any_zero_d;
        
        pushout_1_piped2     <= #1 pushout_1_piped1 	;	
        signres_1_piped2     <= #1 signres_1_piped1  	;   	
        fractC_piped2        <= #1 fractC_piped1     	;   	
        expres_1_piped2      <= #1 expres_1_piped1   	;   	
        expres_2_piped2      <= #1 expres_2_piped1   	;   	
        any_zero_1_piped2    <= #1 any_zero_1_piped1 	;   	
                                                     	
        pushout_1_piped3     <= #1 pushout_1_piped2  	;
        signres_1_piped3     <= #1 signres_1_piped2  	;
        fractC_piped3        <= #1 fractC_piped2     	;
        expres_1_piped3      <= #1 expres_1_piped2   	;
        expres_2_piped3      <= #1 expres_2_piped2   	;
        any_zero_1_piped3    <= #1 any_zero_1_piped2 	;
                                                     	
        pushout_1_piped4     <= #1 pushout_1_piped3  	;
        signres_1_piped4     <= #1 signres_1_piped3  	;
        fractC_piped4        <= #1 fractC_piped3     	;
        expres_1_piped4      <= #1 expres_1_piped3   	;
        expres_2_piped4      <= #1 expres_2_piped3   	;
        any_zero_1_piped4    <= #1 any_zero_1_piped3 	;       
    
    end
    
end



always @(posedge clk or posedge rst) begin
    if(rst) begin
        pushout_1_q <= #1 0;
        signres_1_q <= #1 0;
        fractC_q <= #1 0;
        mres_q <= #1 0;
        expres_1_q <= #1 0;
        expres_2_q <= #1 0;
        any_zero_1_q <= #1 0;
    end else begin
        pushout_1_q 	<= #1 	pushout_1_piped4  ;	
        signres_1_q 	<= #1 	signres_1_piped4  ; 	
        fractC_q 	<= #1 	fractC_piped4     ;  	
        expres_1_q 	<= #1 	expres_1_piped4    ; 	
        expres_2_q 	<= #1 	expres_2_piped4    ; 	
        any_zero_1_q 	<= #1 	any_zero_1_piped4  ; 	   
	 mres_q 	<= #1 mres_d;
    end
    
end


//=========================================================//

  DW02_mult_5_stage #(106,53) vishal2 (.A(mres_q),.B(fractC_q),.TC(1'b0),.CLK(clk),.PRODUCT(mres_2_d));
 


 
always @(*) begin 
  expres_d = expres_1_q + expres_2_q;
end





always @(posedge clk or posedge rst) begin
    if(rst) begin

	expres_piped1 		<= #1 0;
        any_zero_2_piped1 	<= #1 0;
        signres_2_piped1 	<= #1 0;
        pushout_2_piped1 	<= #1 0;
                                      
        expres_piped2 		<= #1 0;
        any_zero_2_piped2 	<= #1 0;
        signres_2_piped2 	<= #1 0;
        pushout_2_piped2 	<= #1 0;
                                      
        expres_piped3 		<= #1 0;
        any_zero_2_piped3 	<= #1 0;
        signres_2_piped3 	<= #1 0;
        pushout_2_piped3 	<= #1 0;
                                      
        expres_piped4 		<= #1 0;
        any_zero_2_piped4 	<= #1 0;
        signres_2_piped4 	<= #1 0;
        pushout_2_piped4 	<= #1 0;

    end else begin
        expres_piped1 		<= #1 expres_d;
        any_zero_2_piped1 	<= #1 any_zero_1_q;
        signres_2_piped1 	<= #1 signres_1_q;
        pushout_2_piped1 	<= #1 pushout_1_q;

	expres_piped2 		<= #1 expres_piped1;
        any_zero_2_piped2 	<= #1 any_zero_2_piped1;
        signres_2_piped2 	<= #1 signres_2_piped1;
        pushout_2_piped2 	<= #1 pushout_2_piped1;

	expres_piped3 		<= #1 	expres_piped2 	  ;
        any_zero_2_piped3 	<= #1 	any_zero_2_piped2 ;
        signres_2_piped3 	<= #1 	signres_2_piped2  ;
        pushout_2_piped3 	<= #1 	pushout_2_piped2  ;

	expres_piped4 		<= #1 	expres_piped3 	 ;	
        any_zero_2_piped4 	<= #1 	any_zero_2_piped3;	
        signres_2_piped4 	<= #1 	signres_2_piped3 ;	
        pushout_2_piped4 	<= #1 	pushout_2_piped3 ;	

	end
end




always @(posedge clk or posedge rst) begin
    if(rst) begin
        expres_q <= #1 0;
        mres_2_q <= #1 0;
        any_zero_2_q <= #1 0;
        signres_2_q <= #1 0;
        pushout_2_q <= #1 0;
    end else begin
        expres_q <= #1 expres_piped4;
        mres_2_q <= #1 mres_2_d;
        any_zero_2_q <= #1 any_zero_2_piped4;
        signres_2_q <= #1 signres_2_piped4;
        pushout_2_q <=  #1 pushout_2_piped4;
    end
    
end


//=========================================================//

always @(*) begin  

    expres_d2 = expres_q;
 
   rconstant=0;
  if (mres_2_q[158]==1) rconstant[105]=1; else if(mres_2_q[157]==1'b1) rconstant[104]=1; else rconstant[103]=1;
  
  rres=mres_2_q+rconstant;
 
  if(any_zero_2_q) begin // sets a zero result to a true 0
    rres = 0;
    expres_d2 = 0;
    resout=64'b0;
  end else begin
    if(rres[158]==1'b1) begin
      expres_d2=expres_d2+1;
      resout={signres_2_q,expres_d2,rres[157:106]};
    end else if(rres[157]==1'b0) begin // less than 1/2
      expres_d2=expres_d2-1;
      resout={signres_2_q,expres_d2,rres[155:104]};
    end else begin 
      resout={signres_2_q,expres_d2,rres[156:105]};
    end
  end
  
  
end


always @(posedge clk or posedge rst) begin
    if(rst) begin
        resout_q <= #1 0;
        pushout_3_q <= #1 0;
    end else begin
        resout_q <= #1 resout;
        pushout_3_q <= #1 pushout_2_q;
    end
    
end


endmodule




 
