// A simple test bench for the random distribution problem
// Written in a low level verilog
// Uses a test case file
//

`timescale 1ns/10ps

module top();

reg clk,rst;
reg pushin;
reg [63:0] U1,U2,Zexp;
wire pushout;
wire [63:0] Z;
real x1,x2,x3;
integer fin;
reg [63:0] expFIFO[0:1023];
reg [9:0] hpt,tpt;
reg running=0;

reg bad=0;

randist r(clk,rst,pushin,U1,U2,pushout,Z);

initial begin
  hpt=0;
  tpt=0;
  $dumpfile("randist.vcd");
  $dumpvars(9,top);

end

task die;
  input [60*8-1:0] msg;
  begin
    repeat(5) $display("- - - - - - - - - - - v v v v - - -");
    while(msg[60*8-1:60*8-8]==0) msg = msg << 8;
    $display("Error --> %60s",msg);
    $display("Simulation failed... Fix it and try again");
    repeat(5) $display("* * * * * * * * * * * ^ ^ ^ ^ * * *");
    bad=1;
    #10;
    $finish;
  end
endtask

task addexp;
input [63:0] exp;
begin
  expFIFO[hpt]=exp;
  hpt=hpt+1;
  if(hpt==tpt) begin
    die("Not enough pushouts >1023 pushins pending");
    $finish;
  end
end
endtask

initial begin
  rst=0;
  clk=1;
  pushin=0;
  repeat(10000000) #5 clk= ~clk;
  die("used > 10M clocks");
  $finish;
end

reg oldpush,push;
reg [63:0] oldZ;
reg [60*8-1:0] badmsg;
real rexp,rz,delta;
reg [60*8-1:0] dmsg;

always @(posedge(clk)) begin
  oldpush=pushout;
  oldZ = Z;
  #0.3;
  if(running) begin
    if(pushout === 1'bX) die("pushout is x");
    if(pushout !== oldpush) die("No hold time on pushout");
    if(oldZ !== Z) die("No hold time on Z");
    if(pushout===1'b1) begin
      rexp = $bitstoreal(expFIFO[tpt]);
      rz = $bitstoreal(Z);
      delta = rexp-rz;
      if(delta < 0) delta=-delta;
      if(delta > 1e-8) begin
        $cast(dmsg,$sformatf("Bad Z --> Exp %016h Got %016h delta %f",expFIFO[tpt],Z,delta));
        die(dmsg);
      end
      tpt=tpt+1;
    end
  end

end

integer fpc=0;
reg [1024*8-1:0] sin;
integer qqx,bb;
initial begin
  U1=0;
  U2=0;
  #1 rst=1;
  repeat(5) @(posedge(clk));
  #1 rst=0;
  @(posedge(clk)) #1;
  running=1;
  fin = $fopen("/home/morris/randist/tc.txt","r");
  if(fin == 0) begin
    $display("Error, could not open the test cases file");
    $finish();
  
  end
  
  while($fgets(sin,fin)) begin
    qqx=0;
    while(qqx < 1023 && sin[1024*8-1:1024*8-8]==0) begin
      sin = sin << 8;
      qqx=qqx+1;
    end

    if(sin[1024*8-1:1024*8-8]==8'h23) begin
//      $display("%60s",sin[1024*8-1:1024*8-8*80]);
    end else begin
      bb=$sscanf(sin,"%x %x %x %f %f %f",U1,U2,Zexp,x1,x2,x3);
//      $display("%f %f %f",x1,x2,x3);
      if(fpc < 20) repeat(100) @(posedge(clk)) #1;
      fpc=fpc+1;
      if(fpc > 200) repeat($random()&'h3) @(posedge(clk)) #1;
      pushin=1;
      addexp(Zexp);
      @(posedge(clk)) #1;
      pushin=0;
    end
  end
  $fclose(fin);
  repeat(500) @(posedge(clk));
  if(hpt != tpt) die("Not all data pushed out");
  $display("\n\n\nThe test was happy with you\n\n\n");
  $finish();
end















endmodule
