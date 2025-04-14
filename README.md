# verilog

To run the processor simulator, naviagate to /processDesign/project 
if if you run the follow command in terminal the simulation should start, you can store the instruction in data.bin file

```
iverilog -o alu.vvp alu.v
vvp alu.vvp
```


I made a simple processor for simple Risc
Aka: https://github.com/sowhatnowgithub/Assembler_simple_risc

Example Program:
Program - SimpleRisc
```
mov r3, 0xab
mov r1, 0x01
mov r7, 0x3
mov r14, r7
add r4, r3, r1
st r3, 0x03[r1]
ld r5, 0x03[r1]

```

Instruction Decoded - Machine Code
```
01001100110000000000000010101011
01001100010000000000000000000001
01001101110000000000000000000011
01001011100000011100000000000000
00000001000011000100000000000000
01111100110001000000000000000011
01110101010001000000000000000011
```

<img width="385" alt="Screenshot 2025-04-14 at 11 20 41 PM" src="https://github.com/user-attachments/assets/377a1435-f1dd-45ad-afc9-2e4e176b6449" />
