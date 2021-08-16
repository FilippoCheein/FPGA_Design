`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Filippo Cheein
// 
// Create Date: 11/30/2018 01:18:36 PM
// Design Name: 
// Module Name: Bubble_Sort
// Project Name: Experiment 12
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 module mux_2t1_nb(SEL, D0, D1, D_OUT); 
       input  SEL; 
       input  [n-1:0] D0, D1; 
       output reg [n-1:0] D_OUT;  
       
       parameter n = 8; 
        
       always @(SEL, D0, D1)
       begin 
          if      (SEL == 0)  D_OUT = D0;
          else if (SEL == 1)  D_OUT = D1; 
          else                D_OUT = 0; 
       end
                
endmodule

 module mux_4t1_nb(SEL, D0, D1, D2, D3, D_OUT); 
       input  [1:0] SEL; 
       input  [n-1:0] D0, D1, D2, D3; 
       output reg [n-1:0] D_OUT;  
       
       parameter n = 8; 
        
       always @(SEL, D0, D1, D2, D3)
       begin 
          if      (SEL == 0)  D_OUT = D0;
          else if (SEL == 1)  D_OUT = D1; 
          else if (SEL == 2)  D_OUT = D2; 
          else if (SEL == 3)  D_OUT = D3; 
          else                D_OUT = 0; 
       end
                
endmodule

module reg_nb(data_in, clk, clr, ld, data_out); 
    input  [n-1:0] data_in; 
    input  clk, clr, ld; 
    output reg [n-1:0] data_out; 

    parameter n = 8; 
    
    always @(posedge clr, posedge clk)
    begin 
       if (clr == 1)     // asynch clr
          data_out <= 0;
       else if (ld == 1) 
          data_out <= data_in; 
    end
    
endmodule

module comp_nb(a, b, eq, lt, gt); 
    input  [n-1:0] a,b; 
    output reg eq, lt, gt; 
  
    parameter n = 8;
    
    always @ (a,b)
    begin      
       if (a == b)
       begin     
          eq = 1; lt = 0;  gt = 0;   
       end
       else if (a > b)   
       begin     
          eq = 0; lt = 0;  gt = 1; 
       end
       else if (a < b)  
       begin     
          eq = 0; lt = 1;  gt = 0; end
       else
       begin     
          eq = 0; lt = 0;  gt = 0; 
       end  
    end 

endmodule

module cntr_up_clr_nb(clk, clr, up, ld, D, count, rco); 
    input  clk, clr, up, ld; 
    input  [n-1:0] D; 
    output   reg [n-1:0] count; 
    output   reg rco; 

    //- default data-width 
    parameter n = 8; 
    
    always @(posedge clr, posedge clk)
    begin 
        if (clr == 1)       // asynch reset
           count <= 0;
        else if (ld == 1)   // load new value
           count <= D; 
        else if (up == 1)   // count up (increment)
           count <= count + 1;  
    end 
       
    
    //- handles the RCO, which is direction dependent
    always @(count, up)
    begin 
       if ( up == 1 && &count == 1'b1)
          rco = 1'b1;
       else if (up == 0 && |count == 1'b0)
          rco = 1'b1;
       else 
          rco = 1'b0; 
    end
    
endmodule

module clk_divder_nbit(clockin, clockout); 
    input clockin; 
    output wire clockout; 

    parameter n = 13; 
    reg [n:0] count; 

    always@(posedge clockin) 
    begin 
        count <= count + 1; 
    end 

    assign clockout = count[n]; 
endmodule 

//7-Segment display module
module our_sseg(clk, , seg, Anodes, regA, regB, regC, regD);
    input clk;
    //input [3:0] P_State;
    input [3:0] regA, regB, regC, regD;
    
    wire fastclock;
    wire [1:0]count;
    wire [3:0] value;
    
    output reg [7:0] seg;
    output reg [3:0] Anodes;
    
    //clock divider for anode selection
    clk_divder_nbit #(.n(13)) Fast(
        .clockin (clk),
        .clockout (fastclock)
        );
  
    cntr_up_clr_nb #(.n(2)) MY_CNTR_insseg (
           .clk   (fastclock), 
           .clr   (), 
           .up    (1), 
           .ld    (0), 
           .D     (00), 
           .count (count), 
           .rco   ()   );
  
    mux_4t1_nb  #(.n(4)) my_4t1_mux_out  (
           .SEL   (count), 
           .D0    (regA),
           .D1    (regB),
           .D2    (regC), 
           .D3    (regD),
           .D_OUT (value) );  
                             
                             
    // rapid flickering of anodes
    always @ (count)
    begin 
        case (count)
           0 : Anodes = 4'b0111;
           1 : Anodes = 4'b1011;
           2 : Anodes = 4'b1101;
           3 : Anodes = 4'b1110;
        endcase
    end
    
    //Seven segment display data
    always @ (value)
    begin
        case (value)
           0 : seg = 8'b00000011;
           
           1 : seg = 8'b10011111;
           
           2 : seg = 8'b00100101;
           
           3 : seg = 8'b00001101;
           
           4 : seg = 8'b10011001;
           
           5 : seg = 8'b01001001;
           
           6 : seg = 8'b01000001;
           
           7 : seg = 8'b00011111;
           
           8 : seg = 8'b00000001;
           
           9 : seg = 8'b00001001;
           
           10 : seg = 8'b00010001;
           
           11 : seg = 8'b00000001;
           
           12 : seg = 8'b01100011;
           
           13 : seg = 8'b00000011;
           
           14 : seg = 8'b01100001;
           
           15 : seg = 8'b01110001;
        endcase
    end
    
endmodule



module Bubble_Sort(A, B, C, D, BTN, clk, sseg, DISP_EN, LED); 

    input BTN;
    input clk;
    input [3:0] A, B, C, D;
    
    wire slow_clk;
    wire [1:0] count_1;
    wire [1:0] count_2;
   
    // bubble sort 
    wire [3:0] data_mux_1, data_mux_2, data_mux_3, data_mux_4;
    wire [3:0] regA_comp, regB_comp, regC_comp, regD_comp;
    wire gt_1, gt_2, gt_3;
    wire [1:0] sel; 
    wire ld_1, ld_2, ld_3, ld_4;
    wire RCO, UP, CLR;

    output [7:0] sseg;
    output [3:0] DISP_EN;
    output LED;
        
        //Clock Divider for Slow Clock 
    clk_divder_nbit #(.n(26)) Slow_clock(
         .clockin (clk),
         .clockout (slow_clk) );
 
    our_sseg Values( 
        .clk (clk),
        .regA (regA_comp), 
        .regB (regB_comp), 
        .regC (regC_comp), 
        .regD (regD_comp),
        .seg (sseg),
        .Anodes(DISP_EN)
        );


  // bubble sort
  mux_4t1_nb  #(.n(4)) my_4t1_mux_1  (
       .SEL   (sel), 
       .D0    (A[3:0]), 
       .D1    (regA_comp), 
       .D2    (regB_comp), 
       .D3    (0),
       .D_OUT (data_mux_1) );  

  mux_4t1_nb  #(.n(4)) my_4t1_mux_2  (
       .SEL   (sel), 
       .D0    (B[3:0]), 
       .D1    (regB_comp), 
       .D2    (regA_comp), 
       .D3    (regC_comp),
       .D_OUT (data_mux_2) );  

  mux_4t1_nb  #(.n(4)) my_4t1_mux_3  (
       .SEL   (sel), 
       .D0    (C[3:0]), 
       .D1    (regD_comp), 
       .D2    (regC_comp), 
       .D3    (regB_comp),
       .D_OUT (data_mux_3) );  

  mux_4t1_nb  #(.n(4)) my_4t1_mux_4  (
       .SEL   (sel), 
       .D0    (D[3:0]), 
       .D1    (regC_comp), 
       .D2    (regD_comp), 
       .D3    (0),
       .D_OUT (data_mux_4) );  

   reg_nb #(4) MY_REG_1 (
       .data_in  (data_mux_1), 
       .ld       (ld_1), 
       .clk      (slow_clk), 
       .clr      (0), 
       .data_out (regA_comp)
          ); 

    reg_nb #(4) MY_REG_2 (
       .data_in  (data_mux_2), 
       .ld       (ld_2), 
       .clk      (slow_clk), 
       .clr      (0), 
       .data_out (regB_comp)
          ); 

    reg_nb #(4) MY_REG_3 (
       .data_in  (data_mux_3), 
       .ld       (ld_3), 
       .clk      (slow_clk), 
       .clr      (0), 
       .data_out (regC_comp)
          ); 

      reg_nb #(4) MY_REG_4 (
          .data_in  (data_mux_4), 
          .ld       (ld_4), 
          .clk      (slow_clk), 
          .clr      (0), 
          .data_out (regD_comp)
          ); 

      comp_nb #(.n(4)) MY_COMP_1 (
          .a (regA_comp), 
          .b (regB_comp), 
          .eq (), 
          .gt (gt_1), 
          .lt ()
          );  

      comp_nb #(.n(4)) MY_COMP_2 (
          .a (regB_comp), 
          .b (regC_comp), 
          .eq (0), 
          .gt (gt_2), 
          .lt (0)
          );  

      comp_nb #(.n(4)) MY_COMP_3 (
          .a (regC_comp), 
          .b (regD_comp), 
          .eq (0), 
          .gt (gt_3), 
          .lt (0)
          );  

      cntr_up_clr_nb #(.n(2)) MY_CNTR_FSM (
          .clk   (slow_clk), 
          .clr   (CLR), 
          .up    (UP), 
          .ld    (0), 
          .D     (), 
          .count (count_2), 
          .rco   (RCO)   );

         fsm_template(
            .reset (0), 
            .btn (BTN), 
            .clk (slow_clk), 
            .rco (RCO), 
            .gt_1 (gt_1), 
            .gt_2 (gt_2), 
            .gt_3 (gt_3), 
            .clr (CLR), 
            .led (LED), 
            .sel (sel), 
            .up (UP), 
            .ld_1 (ld_1), 
            .ld_2 (ld_2),  
            .ld_3 (ld_3), 
            .ld_4 (ld_4)
            ); 
            
endmodule

module fsm_template(reset, btn, clk, rco, gt_1, gt_2, gt_3, clr, led, sel, up, ld_1, ld_2, ld_3, ld_4); 
    input  reset, btn, clk, rco, gt_1, gt_2, gt_3; 
    output reg clr, led, up; // mealy 
    output reg [1:0] sel;
    output reg ld_1, ld_2, ld_3, ld_4; // moore
     
    //- next state & present state variables
    reg [2:0] NS, PS; 
    //- bit-level state representations
    parameter [2:0] st_wait = 3'b000,
                    st_load = 3'b001, 
                    st_hold = 3'b010,
                    st_sort_1 = 3'b011,
                    st_sort_2 = 3'b100,
                    st_sort_3 = 3'b101,
                    st_cnt    = 3'b110,
                    st_btn    = 3'b111;
    

    //- model the state registers
    always @ (negedge reset, posedge clk)
       if (reset == 1) 
          PS <= st_wait; 
       else
          PS <= NS; 
    
    
    //- model the next-state and output decoders
    always @ (btn,PS)
    begin             // assign all outputs
       clr = 0; led = 0; sel = 00; up = 0; //mealy
       ld_1 = 0; ld_2 = 0; ld_3 = 0; ld_4 = 0; //moore 
       
       case(PS)
       
          st_wait:
          begin     
             led = 1;
             if (btn == 1)
             begin
                clr = 1;
                led = 0;   
                NS = st_load; 
             end  
             else
             begin
               // led = 1;
                NS = st_wait; 
             end  
          end
          
          st_load:
             begin
                ld_1 = 1;
                ld_2 = 1;
                ld_3 = 1;
                ld_4 = 1;
                sel = 2'b00;
                clr = 0;
                NS = st_hold;
             end   
             
          st_hold:
             begin
                 if (gt_1 == 1) 
                    NS = st_sort_1; 
                 else if (gt_1 == 0 & gt_2 == 1) 
                    NS = st_sort_2; 
                 else if ( gt_1 == 0 & gt_2 == 0 & gt_3 == 1 )
                    NS = st_sort_3;
                 else if ( gt_1 == 0 & gt_2 == 0 & gt_3 == 0 )
                   NS = st_btn; 
             end
             
          st_sort_1:
             begin
                    sel = 2'b10;
                    ld_1 = 1;
                    ld_2 = 1;
                    ld_3 = 0;
                    ld_4 = 0;
                 if (gt_2 == 1)
                    NS = st_sort_2; 
                 else if (gt_2 == 0 & gt_3 == 1)      
                    NS = st_sort_3; 
                 else if (gt_2 == 0 & gt_3 == 0)
                  begin
                   up = 1;
                   NS = st_cnt;
                  end 
             end
             
         st_sort_2:
             begin
                  sel = 2'b11;
                  up = 0;
                  ld_1 = 0;
                  ld_2 = 1;
                  ld_3 = 1;
                  ld_4 = 0; 
                if (gt_3 == 1)              
                   NS = st_sort_3;                 
                else if (gt_3 == 0)
                 begin
                   up = 1; 
                   NS = st_cnt; 
                 end   
            end
             
            st_sort_3:
               begin
                   sel= 2'b01;
                   ld_1 = 0;
                   ld_2 = 0;
                   ld_3 = 1;
                   ld_4 = 1; 
                   up = 1;
                   NS = st_cnt;
               end             
            
            st_cnt:
               begin
                   ld_1 = 0;
                   ld_2 = 0;
                   ld_3 = 0;
                   ld_4 = 0; 
                   if (rco == 0)
                    begin
                      up = 0;
                      NS = st_hold;
                    end
                   else
                   begin
                  //  led = 1;
                    NS = st_btn; 
                   end
               end    
               
            st_btn:
               begin
                 if (btn == 1)
                  NS = st_btn;
                 else
                 begin
                 NS = st_wait;
                 end
               end 
            
          endcase
      end              
endmodule
