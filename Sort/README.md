In this code, we designed a circuit that sort 4 number in ascending order that will be displayed on the 7-segments display of the development board.
The four inputs are unsigned binary numbers that range from 0-15; the 16 switches on the dev board provides these inputs. 
This circuit also has an LED that indicates when the sort algorithm is happening (LED off), and when the sort algorithm has completed (LED on).

Uses a button press to start the sort
Checks for the button release after the sort is completed, which means if the user holds the button down, the hardware will not initiate another sort until the user releases the button.
Displays the input values as hex numbers

note:
FSM never inputs any data value that the hardware is sorting.
FSM must never uses mathematical or equality operators.
Only digital design foundation modules are used in the design

Black Box Design Diagram:
![alt text](https://github.com/FilippoCheein/FPGA_Design/blob/main/Sort/Bubble_Sort_Black_Box_Diagram.jpg?raw=true)

FSM State Diagram
![alt text](https://github.com/FilippoCheein/FPGA_Design/blob/main/Sort/Bubble_Sort_FSM_State_Diagram_.jpg?raw=true)
