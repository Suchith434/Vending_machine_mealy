# Secure Rs. 15 Vending Machine Controller (Mealy FSM)

## Overview
This repository contains the RTL design and exhaustive verification of a coin-operated vending machine controller, implemented in Verilog. The project highlights the transition from standard mathematical optimization (Karnaugh Maps) to secure, physical hardware implementation by patching a critical short-circuit vulnerability discovered during simulation.

## Architecture
* **State Machine:** Mealy FSM (Outputs depend on both Present State and Inputs)
* **Encoding:** Binary Encoding (2 Flip-Flops for 3 valid states: S0, S5, S10)
* **Target Dispense:** Rs. 15
* **Accepted Inputs:** Rs. 5 (`01`), Rs. 10 (`10`)

## The Vulnerability & Hardware Patch
During standard logic minimization, the physically impossible sensor input of `11` (both Rs. 5 and Rs. 10 inserted simultaneously) was treated as a "Don't Care" (`X`) condition to reduce gate count. 

**The Exploit:** Exhaustive testbench simulation revealed that this optimization created a hardware vulnerability. If a malicious user short-circuited the coin slot sensors to force a `11` logic level while the machine was in the S5 state, the combinational logic evaluated the dispense output to `1`, dropping free inventory.

**The Fix:** I explicitly discarded the gate-optimized equations and recalculated the Boolean logic, forcing the `11` column in the K-map to `0`. 
* *Original Logic:* `Y = PS0·X1 + PS1·(X0 + X1)`
* *Hardened Logic:* `Y = (X1·~X0·(PS0 + PS1)) + (~X1·X0·PS1)`

This patch sacrifices a small amount of silicon area to mathematically guarantee the dispense output remains low if a physical sensor short is detected.

## Verification
The testbench (`tb_vm.v`) utilizes standard delta-cycle race condition prevention (`@negedge clk` stimulus driving) and exhaustively tests:
1. Standard paths (5+5+5, 5+10, 10+5)
2. Overpay edge cases (10+10)
3. Asynchronous resets mid-transaction
4. Invalid/Malicious inputs (The patched `11` exploit)

### Waveforms

* `output/waveform_exploit.png` - The T=200 vulnerability.
* `output/waveform_patched.png` - The T=200 secured output.
