`timescale 10ns / 10ns

module talu;
  reg [31:0] a, b;
  reg [2:0] f;
  wire [31:0] r;

  //file reading variables
  integer fd, code, dummy;
  reg [8*10:1] str;

  //expected values
  reg [31:0] rr;
  
  //instance 
  alu myula(a, b, f, r);
    
  //dump waveform in vcd format
  initial  begin
    $dumpfile ("tula.vcd"); 
    $dumpvars; 
  end 

  //console monitor   
  initial  begin
    $display("%d,\ta\tb\tf\tr\trr", $time); 
    $monitor("%d,\t%d,\t%d,\t%d,\t%d,\t%d",$time, a, b, f, r, rr); 
  end 
 
  initial begin
    //open file for reading
    fd = $fopen("talu.dat","r"); 
    code = 1;
    while (code) begin
      code = $fgets(str, fd);
      dummy = $sscanf(str, "%d %d %d %d\n", a, b, f, rr);
      #5;
      if (r != rr) begin
        $display ("DUT Error at time %d", $time); 
        $display (" Expected value %d, Got Value %d", rr, r); 
        #1 $finish;
      end 
    end
    $finish;
  end
    
endmodule