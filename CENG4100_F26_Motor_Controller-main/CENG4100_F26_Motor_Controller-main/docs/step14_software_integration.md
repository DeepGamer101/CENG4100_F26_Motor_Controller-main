# Step 14 — Software & Integration

## 1. Hello Program
Successfully compiled using `python sw/build.py hello`.

- Code: 1,628 bytes
- Data: 244 bytes
- `_start` begins at address `0x00000000`.
- Stack pointer initializes to `0x00008000`.
- `__mulsi3` performs software multiplication because RV32I does not support hardware multiplication.

## 2. Motor Controller Firmware
The `firmware.c` program uses a PI controller to regulate motor speed by adjusting the PWM duty cycle. It calculates the difference between desired and measured speeds, applies proportional and integral gains, limits the output, and writes the result to the PWM register.

Conditional statements and software multiplication can cause variable execution times. Our goal is to maintain identical PWM outputs while meeting the deterministic 2.9 µs timing requirement.

## 3. Motor Controller Build
Successfully compiled using `python sw/build.py case1_motor`.

- Code: 2,372 bytes
- Data: 6,484 bytes
- Both fit within the allocated 16 KB instruction and data memory regions.

## 4. Peripheral Behavior Specification
Based on `docs/memory_map.md`:

- **UART:** Serial communication at 115200 baud (8N1). Registers support transmission, reception, and status checking.
- **GPIO:** Reads switches and buttons and controls LEDs and the 7-segment display.
- **Timer:** A 32-bit counter tracks CPU clock cycles and can be reset through its control register.
- **PWM:** Controls the motor's duty cycle using period, duty, and enable registers.

All peripheral registers use 32-bit word accesses at fixed memory-mapped addresses.