//
// This is a simple version of a 64 bit floating point multiplier 
// used in EE287 as a homework problem.
// This is a reduced complexity floating point.  There is no NaN
// overflow, underflow, or infinity values processed.
//
// Inspired by IEEE 754-2008 (Available from the SJSU library to students)
//
// 63  62:52 51:0
// S   Exp   Fract (assumed high order 1)
// 
// Note: all zero exp and fract is a zero 
// 
//

module fpadd(a,b,clk,rst,pushin,pushout,r);
	input 		clk;
	input 		rst;
	
	input 		pushin;
	input [63:0] 	a,b;	// the a and b inputs
	output [63:0] 	r;	// the results from this multiply
	output 		pushout;		// indicates we have an answer this cycle
	
	reg 		pushout_1_q,pushout_2_q,pushout_3_q,pushout_1_q2,pushout_1_q3;
	
	parameter 	fbw=104;
	
	reg 		sA,sB;		// the signs of the a and b inputs
	reg [10:0] 	expA, expB,expR_d,expR_q,expR_ns,expR_2_q,expR_2_ns,expR_old_q,expR_q2,expR_q3;		// the exponents of each
	reg [fbw:0] 	fractA_d,fractA_q,fractA_q2,fractA_q3,fractB_ns_1, fractB_d,fractB_q,fractB_ns,fractB_2_q,fractA_2_q,fractR,fractR_q,fractR_ns,fractR_q2,fractR_ns2,fractAdd,fractPreRound,denormB;	
		// the fraction of A and B  present
	reg 		zeroA,zeroB;	// a zero operand (special case for later)
		
	
	reg 		signres_d,signres_q,signres_2_d,signres_2_q,signres_q2,signres_q3;		// sign of the result
	reg [10:0] 	expres;	// the exponent result
	reg [63:0] 	resout,resout_q;	// the output value from the always block
	integer 	iea,ieb,ied_d,ied_q,ied_2_q,ied_q2,ied_q3;	// exponent stuff for difference...
	integer 	renorm,renorm_q;		// How much to renormalize...
	parameter [fbw:0] zero=0;
	reg 		stopinside;
	
	reg 		sign_cmp_d,sign_cmp_q,sign_cmp_2_q,sign_cmp_q2;

assign r=resout_q;
assign pushout=pushout_3_q;






//
// give the fields a name for convience
//





always @(*) begin
  zeroA = (a[62:0]==0)?1:0;
  zeroB = (b[62:0]==0)?1:0;
  if( b[62:0] > a[62:0] ) begin
    expA = b[62:52];
    expB = a[62:52];
    sA = b[63];
    sB = a[63];
    fractA_d = (zeroB)?0:{ 2'b1, b[51:0],zero[fbw:54]};
    fractB_d = (zeroA)?0:{ 2'b1, a[51:0],zero[fbw:54]};
    signres_d=sA;
  end else begin
    sA = a[63];
    sB = b[63];
    expA = a[62:52];
    expB = b[62:52];
    fractA_d = (zeroA)?0:{ 2'b1, a[51:0],zero[fbw:54]};
    fractB_d = (zeroB)?0:{ 2'b1, b[51:0],zero[fbw:54]};
    signres_d=sA;
  end
  expR_d=expA;
  ied_d=expA-expB;
  sign_cmp_d = (sA==sB) ? 1:0;
end
  
 


 
always @(posedge clk or posedge rst) begin
    if(rst) begin
        fractA_q 	<= #1 0;
        fractB_q 	<= #1 0;
        signres_q 	<= #1 0;
        expR_q 		<= #1 0;
        ied_q 		<= #1 0;
        sign_cmp_q 	<= #1 0;
        pushout_1_q 	<= #1 0;


    
    end else begin
        fractA_q 	<= #1 fractA_d;
        fractB_q 	<= #1 fractB_d;
        signres_q 	<= #1 signres_d;
        expR_q		<= #1 expR_d;
        ied_q 		<= #1 ied_d;
        sign_cmp_q 	<= #1 sign_cmp_d;
        pushout_1_q 	<= #1 pushin;

    end
end
 

//======================================================================//
 
 always @(*) begin
 
 
    fractB_ns = fractB_q;
    fractB_ns=(ied_q[5])?{32'b0,fractB_ns[fbw:32]}: {fractB_ns};
    fractB_ns=(ied_q[4])?{16'b0,fractB_ns[fbw:16]}: {fractB_ns};
    fractB_ns=(ied_q[3])?{ 8'b0,fractB_ns[fbw:8 ]}: {fractB_ns};
    fractB_ns=(ied_q[2])?{ 4'b0,fractB_ns[fbw:4 ]}: {fractB_ns};
    fractB_ns=(ied_q[1])?{ 2'b0,fractB_ns[fbw:2 ]}: {fractB_ns};
    fractB_ns=(ied_q[0])?{ 1'b0,fractB_ns[fbw:1 ]}: {fractB_ns};

end



always @(posedge clk or posedge rst) begin
    if(rst) begin
        fractA_q2 	<= #1 0;
        fractB_ns_1 	<= #1 0;
        signres_q2 	<= #1 0;
        expR_q2		<= #1 0;
        ied_q2 		<= #1 0;
        sign_cmp_q2 <= #1 0;
        pushout_1_q2 <= #1 0;



    
    end else begin
        fractA_q2 	<= #1 fractA_q;
        fractB_ns_1 	<= #1 fractB_ns;
        signres_q2 	<= #1 signres_q;
        expR_q2		<= #1 expR_q;
        ied_q2 		<= #1 ied_q;
        sign_cmp_q2 <= #1 sign_cmp_q;
        pushout_1_q2 <= #1 pushout_1_q;

    end
    
end




//======================================================================//





always @(*) begin
if(sign_cmp_q2) fractR=fractA_q2+fractB_ns_1; else fractR=fractA_q2-fractB_ns_1;
end




always @(posedge clk or posedge rst) begin
    if(rst) begin
        fractA_q3 	<= #1 0;
        signres_q3 	<= #1 0;
        expR_q3	<= #1 0;
        ied_q3 		<= #1 0;
        pushout_1_q3 <= #1 0;
        fractR_q2 <= #1 0; 
    end else begin
        fractA_q3 	<= #1 fractA_q2;
        signres_q3 	<= #1 signres_q2;
        expR_q3		<= #1 expR_q2;
        ied_q3 		<= #1 ied_q2;
        pushout_1_q3 <= #1 pushout_1_q2;
        fractR_q2 <= #1 fractR; 
    end
end





//======================================================================// 




    
  always @(*) begin   
    
    expR_ns = expR_q3;
    fractR_ns2 = fractR_q2;
    
    renorm=0;
    if(fractR_ns2[fbw]) begin
      fractR_ns2={1'b0,fractR_ns2[fbw:1]};
      expR_ns=expR_ns+1;
    end
    if(fractR_ns2[fbw-1:fbw-32]==0) begin 
	renorm[5]=1; fractR_ns2={ 1'b0,fractR_ns2[fbw-33:0],32'b0 }; 
    end
    if(fractR_ns2[fbw-1:fbw-16]==0) begin 
	renorm[4]=1; fractR_ns2={ 1'b0,fractR_ns2[fbw-17:0],16'b0 }; 
    end
    if(fractR_ns2[fbw-1:fbw-8]==0) begin 
	renorm[3]=1; fractR_ns2={ 1'b0,fractR_ns2[fbw-9:0], 8'b0 }; 
    end
    if(fractR_ns2[fbw-1:fbw-4]==0) begin 
	renorm[2]=1; fractR_ns2={ 1'b0,fractR_ns2[fbw-5:0], 4'b0 }; 
    end
    if(fractR_ns2[fbw-1:fbw-2]==0) begin 
	renorm[1]=1; fractR_ns2={ 1'b0,fractR_ns2[fbw-3:0], 2'b0 }; 
    end
    if(fractR_ns2[fbw-1   ]==0) begin 
	renorm[0]=1; fractR_ns2={ 1'b0,fractR_ns2[fbw-2:0], 1'b0 }; 
    end
    
  end
  
  
  
always @(posedge clk or posedge rst) begin
    if(rst) begin
        ied_2_q <= #1 0;
        fractA_2_q <= #1 0;
        signres_2_q <= #1 0;
        expR_2_q <= #1 0;
        pushout_2_q <= #1 0;
        
        renorm_q <= #1 0;
        fractR_q <= #1 0;
        expR_old_q <= #1 0;
    
    end else begin
        ied_2_q <= #1 ied_q3;
        fractA_2_q <= #1 fractA_q3;
        signres_2_q <= #1 signres_q3;
        expR_2_q <= #1 expR_ns;
        pushout_2_q <= #1 pushout_1_q3;
    
        renorm_q <= #1 renorm;
        fractR_q <= #1 fractR_ns2;
        expR_old_q <= #1 expR_q3;

    end
    
end




  
  
  //======================================================================// 





  
always @(*) begin
    
    expR_2_ns = expR_2_q;
    signres_2_d = signres_2_q;
    
  if(ied_2_q > 60) begin
    fractR_ns=fractA_2_q;
    expR_2_ns = expR_old_q;
    
  end else begin
    fractR_ns = fractR_q;
    fractPreRound=fractR_ns;
    if(fractR_ns != 0) begin
      if(fractR_ns[fbw-55:0]==0 && fractR_ns[fbw-54]==1) begin
	if(fractR_ns[fbw-53]==1) fractR_ns=fractR_ns+{1'b1,zero[fbw-54:0]};
      end else begin
        if(fractR_ns[fbw-54]==1) fractR_ns=fractR_ns+{1'b1,zero[fbw-54:0]};
      end
      expR_2_ns=expR_2_ns-renorm_q;
      if(fractR_ns[fbw-1]==0) begin
       expR_2_ns=expR_2_ns+1;
       fractR_ns={1'b0,fractR_ns[fbw-1:1]};
      end
    end else begin
      expR_2_ns=0;
      signres_2_d=0;
    end
  end

  resout={signres_2_d,expR_2_ns,fractR_ns[fbw-2:fbw-53]};

end





    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pushout_3_q <= #1 0;
            resout_q <= #1 0;
        end else begin
            pushout_3_q <= #1 pushout_2_q;
            resout_q <= #1 resout;
        end
    end
//======================================================================// 

endmodule
