//Car Parking System

module parking (
input clk,
input rst,
input in1,						//entry sensor input
input in2,						//exit sensor input
output reg status1,					//entry sensor output
output reg status2					//exit sensor output
);

integer capacity = 0;					//counter for number of vehicles

parameter EntryOpen = 2'b00;				//State Encoding
parameter EntryClosed = 2'b01;
parameter ExitOpen = 2'b10;
parameter ExitClosed = 2'b11;

reg [1:0] Entry_curr, Entry_next;
reg [1:0] Exit_curr, Exit_next;

always @ (posedge clk, posedge rst)			//State register for Entry
begin
if (rst) Entry_curr <= 2'b01;
else Entry_curr <= Entry_next;
end

always @ (posedge clk, posedge rst)			//State register for Exit
begin
if (rst) Exit_curr <= 1;
else Exit_curr <= Exit_next;
end

always @ (in1)						//Change in state wrt Entry
begin
case (Entry_curr)

00:	if(in1)
	begin
		if(capacity < 50)
		begin 
		status1 <= 1;				//status1 = 1 implies entry is open
		Entry_next <= EntryOpen;
		capacity = capacity + 1;
		end
		else
		begin
		status1 <= 0;				//status1 = 0 implies entry is closed	
		Entry_next <= EntryClosed;
		end
	end
	else
	begin
	status1 <= 0;					
	Entry_next <= EntryClosed;
	end

01:	if(in1)
	begin
		if(capacity < 50)
		begin 
		status1 <= 1;				//status1 = 1 implies entry is open
		Entry_next <= EntryOpen;
		capacity = capacity + 1;
		end
		else
		begin
		status1 <= 0;				//status1 = 0 implies entry is closed	
		Entry_next <= EntryClosed;
		end
	end
	else
	begin
	status1 <= 0;
	Entry_next <= EntryClosed;
	end

endcase
end

always @ (in2)						//Change in state wrt Exit
begin
case (Exit_curr)

10:	if(in2)
	begin
	status2 <= 1;					//status2 = 1 implies exit is open
	Exit_next <= ExitOpen;
	capacity = capacity - 1;
	end
	else
	begin
	status2 <= 0;					//status2 = 0 implies exit is closed
	Exit_next <= ExitClosed;
	end

11:	if(in2)
	begin
	status2 <= 1;
	Exit_next <= ExitOpen;
	capacity = capacity - 1;
	end
	else
	begin
	status2 <= 0;
	Exit_next <= ExitClosed;
	end

endcase
end

endmodule

module simulate;
reg clk,rst,in1,in2;
wire out1,out2;

parking CP(clk,rst,in1,in2,out1,out2);

initial
begin
clk=0;
forever #100 clk=~clk;
end

initial
begin
$monitor($time,"rst=%b,in1=%b,in2=%b,out1=%b,out2=%b",rst,in1,in2,out1,out2);
#100 in1=1;in2=0;rst=0;
#100 in1=0;in2=1;rst=0;
#100 in1=1;in2=1;rst=0;
#100 in1=1;in2=1;rst=1;
#100 $finish;
end
endmodule 
