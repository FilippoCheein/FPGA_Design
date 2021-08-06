In this code, we have designed a circuit that would count the number of switches on and decide the parity of the binary input.
The circuit has two outputs. One output is the number of bits set in a 16-bit word (a stone-age binary to decimal conversion), and the other is an output indicates the parity of the 16-bit word. The 16 switches on the development board are used as the input word. Two 7-segment display devices are used to display the result of the stone-age binary to decimal conversion. The other two unused 7-segment displays are used to indicate parity with an “EE” for even parity and “oo” for odd parity. When the user presses a button, the circuit calculates the parity and displays the results accordingly. It then waits for another button press.

Design Diagram:

![alt text](https://github.com/FilippoCheein/FPGA_Design/blob/main/Parity_Generator/Parity_Generator_Design_Diagram_.jpg?raw=true)
