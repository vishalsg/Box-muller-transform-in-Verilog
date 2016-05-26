

module norm (delta_denorm,clk,rst,pushin,pushout,delta); 

parameter fpw=63;
       
input [fpw:0] delta_denorm;
input clk;
input rst;
input pushin;
output [63:0] delta;
output pushout;

reg [fpw:0] fractR;
reg [10:0]  expR;
integer renorm;
reg signres;

reg pushout_a;
reg [63:0] delta_d,delta_a;

assign delta = delta_a;
assign pushout = pushout_a;


always @(*) begin


fractR=delta_denorm;
expR = 0;

    renorm=0;
    signres=0;

if(fractR != 64'b0) begin

    if(fractR[fpw:fpw-31]==0) begin 
	renorm[5]=1; fractR={fractR[fpw-32:0],32'b0 }; 
    end
    if(fractR[fpw:fpw-15]==0) begin 
	renorm[4]=1; fractR={fractR[fpw-16:0],16'b0 }; 
    end
    if(fractR[fpw:fpw-7]==0) begin 
	renorm[3]=1; fractR={fractR[fpw-8:0], 8'b0 }; 
    end
    if(fractR[fpw:fpw-3]==0) begin 
	renorm[2]=1; fractR={fractR[fpw-4:0], 4'b0 }; 
    end
    if(fractR[fpw:fpw-1]==0) begin 
	renorm[1]=1; fractR={fractR[fpw-2:0], 2'b0 }; 
    end
    if(fractR[fpw]==0) begin 
	renorm[0]=1; fractR={fractR[fpw-1:0], 1'b0 }; 
    end

    expR=11'd1022 - renorm;
  
    delta_d={signres,expR,fractR[fpw-1:fpw-52]};

   end else begin 
    
    delta_d = 64'b0;
  
  end

end


always @(posedge clk or posedge rst) begin

    if (rst==1) begin
        delta_a          <= #1 0;
        pushout_a        <= #1 0;
     
    end else begin
        delta_a          <= #1 delta_d;
        pushout_a        <= #1 pushin;    
    end

end



endmodule

