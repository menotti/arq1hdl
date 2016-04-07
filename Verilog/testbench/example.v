module example(s, x);
  input [1:0] s;
  output x;
  
  reg x;
  
  always @*
    case (s)
      2'b01: assign x = 0;
      2'b10: assign x = 1;
      default: assign x = 1'bz;
    endcase
    
endmodule