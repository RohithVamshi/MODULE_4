
module module41_1
#(parameter i1=3,f1=3,
parameter i2=3,f2=2,
parameter out_i=3,out_f=2
)
(input clk,
input rst,
input [i1+f1-1:0]a,
input [i2+f2-1:0]b,
input sign_add,
output  reg overflow,underflow,
output reg  [out_i+out_f-1:0]sum);
  
 localparam max_i=(i1>=i2)?i1:i2;
 localparam max_f=(f1>=f2)?f1:f2;
 

 reg [i1-1:0]ai;
 reg [max_i-1:0]temp_ai;
 reg [f1-1:0]af;
 reg [max_f-1:0]temp_af;
 reg [i2-1:0]bi;
 reg [max_i-1:0]temp_bi;
 reg [f2-1:0]bf;
 reg [max_f-1:0]temp_bf;
 reg [max_i+max_f-1:0]temp_a;
 reg [max_i+max_f-1:0]temp_b;
 reg [max_i+max_f:0]temp_sum;
 reg [out_i-1:0]temp_sumi;
 reg [out_f-1:0]temp_sumf;
 wire signed [3:0] max_int ;
     

 always@(*)
 begin
 ai=a[i1+f1-1:f1];
 af=a[f1-1:0];
 bi=b[i2+f2-1:f2];
 bf=b[f2-1:0];
 end
 
 always@(posedge clk)
   begin
 if(i1==i2 && f1==f2)
 begin
    temp_ai=ai;
    temp_bi=bi;
    temp_af=af;
    temp_bf=bf;
 end
 end
 
 
 always@(posedge clk)
 begin
 if(i1>i2 )
 begin
  temp_ai=ai;
  temp_bi={{(i1-i2){bi[i2-1]}},bi};
  end
 else
  if(i2>i1)
   begin
   temp_bi=bi;
   temp_ai={{(i2-i1){ai[i1-1]}},ai};
   end
   
   begin
    if(f1>f2)
  begin
    temp_af=af;
    temp_bf={bf,{(f1-f2){1'b0}}};
  end
   else if(f2>f1)
  begin  
    temp_bf=bf;
    temp_af={af,{(f2-f1){1'b0}}};
  end
  
 
  begin
   temp_a ={temp_ai,temp_af};
   temp_b ={temp_bi,temp_bf};
    temp_sum=$signed(temp_a)+$signed(temp_b);
    end
 end
 end



always@(posedge clk)
begin
if(rst)
begin
overflow=0;
underflow=0;
temp_sum=0;
end
else
begin
if(out_i>max_i)
overflow=0;
else if(out_i==max_i)
overflow=((temp_a[max_i+max_f-1]^temp_sum[max_i+max_f-1]) && (temp_b[max_i+max_f-1]^temp_sum[max_i+max_f-1])); 
else if(out_i<max_i)
begin
 if(temp_sum[max_i+max_f]==0)
overflow=|temp_sum[max_i+max_f:(max_i+max_f-(max_i-(out_i)))];
else if(temp_sum[max_i+max_f]==1)
overflow=(~(&temp_sum[max_i+max_f:max_f+out_i]));
end
end
begin
if(overflow)
begin
if(temp_sum[max_i+max_f]==0)
temp_sumi={{temp_sum[max_i+max_f]},{(out_i-1){1'b1}}};
else if(temp_sum[max_i+max_f]==1)
temp_sumi={{temp_sum[max_i+max_f]},{(out_i-1){1'b0}}};
end
else
temp_sumi=temp_sum[max_i+max_f:max_f];
end
end

//underflow condition

always@(posedge clk)
begin
if(out_f>=max_f)
underflow=0;
else 
underflow=|temp_sum[max_f-out_f-1:0];
end
//fraction output
always@(posedge clk)
begin
begin
if(underflow)
temp_sumf={{{max_f-(max_f-out_f)-1}{1'b0}},{1'b1}};
else
temp_sumf=temp_sum[max_f-1:(max_f-out_f)];
end
sum={{temp_sumi},{temp_sumf}};
end



endmodule
