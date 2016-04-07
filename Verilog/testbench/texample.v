`timescale 10ns / 10ns

module texample;
  //stimulus
  reg [1:0] s;
  wire x;

  //file reading variables
  reg xx;  
  integer fd, code, dummy;
  reg [8*10:1] str;
   
  //instance 
  example dut(s, x);
    
  //dump waveform in vcd format
  initial  begin
    $dumpfile ("example.vcd"); 
    $dumpvars; 
  end 

  //console monitor   
  initial  begin
    $display("%d,\ts\tx\txx", $time); 
    $monitor("%d,\t%b,\t%b,\t%b",$time, s, x, xx); 
  end 
 
  initial begin
    //open file for reading
    fd = $fopen("input.dat","r"); 
    code = 1;
    while (code) begin
      code = $fgets(str, fd);
      dummy = $sscanf(str, "%b %b\n", s, xx);
      #5;
      if (x != xx) begin
        $display ("DUT Error at time %d", $time); 
        $display (" Expected value %d, Got Value %d", xx, x); 
        #1 $finish;
      end 
    end
    $finish;
  end
  
endmodule