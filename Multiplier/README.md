In this code, we designed a circuit that would multiply 2 numbers using the shifting method.

The design is a 5-bit multiplier driven that uses successive additions in conjunction with appropriate shifting and accumulate operations to generate a 5-bit multiply operation.
It uses the switches on the development board to input two 5-bit unsigned binary values. These values are multiplied and the seven-segment displays show the result.
The multiply operation is initiated when you press the development board’s left-most button. The final result should remain on the output display until the button is pressed again.
It ignores all button presses between the initial button press and obtaining the final result.
It uses the univ_sseg.v module to display your results and use a clock division module to slow down the circuit operation for added visual benefit.

Design Diagram:

![alt text](https://github.com/FilippoCheein/FPGA_Design/blob/main/Multiplier/Multiplier%20-%20Design%20Diagram.jpg?raw=true)
