

module denorm1 (U1,clk,rst,pushin,pushout,delta_denorm,fract_lt);
       
parameter fpw = 63;
parameter [fpw:0] zero=0;
parameter size=9;


input [63:0] U1;
input clk;
input rst;
input pushin;
output [fpw:0] delta_denorm;
output [size:0] fract_lt;
output pushout;

reg signres;
reg [fpw:0] fract;
reg [10:0] exp;
reg [4:0] exp_denorm;

//reg [63:0] U1_a;
reg pushout_b;

reg [fpw:0] delta_denorm_b,delta_denorm_d;
reg [size:0] fract_lt_b,fract_lt_d;


assign delta_denorm=delta_denorm_b;
assign fract_lt = fract_lt_b;

assign pushout= pushout_b;




// always @(posedge clk or posedge rst) begin
//     if(rst==1) begin
//         U1_a      <= #1 0;
//         pushin_a  <= #1 0;
//     end else begin
//         U1_a      <= #1 U1;
//         pushin_a  <= #1 pushin;    
//     end
// end



always @(*) begin

signres = U1[63];
fract= {1'b1,U1[51:0],zero[fpw:53]};
exp=11'd1022-U1[62:52];


//********** Denormalization *************************//

exp_denorm=exp[4:0];

fract = (exp_denorm[4]) ? {16'b0,fract[fpw:16]} : {fract} ;
fract = (exp_denorm[3]) ? {8'b0,fract[fpw:8]} : {fract} ;
fract = (exp_denorm[2]) ? {4'b0,fract[fpw:4]} : {fract} ;
fract = (exp_denorm[1]) ? {2'b0,fract[fpw:2]} : {fract} ;
fract = (exp_denorm[0]) ? {1'b0,fract[fpw:1]} : {fract} ;


fract_lt_d = fract[fpw:fpw-size];
delta_denorm_d = {zero[fpw:fpw-size],fract[fpw-(size+1):0]};

//****************************************************//
end

always @(posedge clk or posedge rst) begin
    if(rst==1) begin
        delta_denorm_b      <= #1 0;
        fract_lt_b          <= #1 0;
        pushout_b           <= #1 0;
    end else begin
        delta_denorm_b      <= #1 delta_denorm_d;
        fract_lt_b          <= #1 fract_lt_d;
        pushout_b           <= #1 pushin;
    end
end

endmodule
