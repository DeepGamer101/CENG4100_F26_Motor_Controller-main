
# Resource ledger

Budget: Basys 3, XC7A35T-1CPG236C. Update after every Vivado build from
`reports/summary.txt` and `reports/utilization.rpt`. Estimates come from
decision discussions; measured numbers replace them.

| Resource | Device total |
| --- | --- |
| LUTs | 20,800 |
| Flip-flops | 41,600 |
| BRAM36 tiles | 50 |
| DSP48E1 slices | 90 |
| Distributed RAM | ~400 Kb |

## Ledger

| Date | Decision or change | LUT est. | LUT meas. | FF meas. | BRAM meas. | DSP meas. | WNS (ns) | Clock (MHz) | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 11/19/2026 | Empty `top.v` (baseline) | 0 | 0 | 0 | 0 | 0 | N/A | 100 | Baseline bitstream generated successfully. Synthesis used 29 bonded IOBs and no LUTs, flip-flops, BRAM, or DSPs. No timed logic paths; routed WNS unavailable. |

## Client targets

Case 1: Motor Controller

| Target | Limit | Best so far | Design that achieved it |
| --- | --- | --- | --- |
| R1 - Control-pass execution time | <= 2.9 microseconds | Not measured | Pending CPU implementation |
| R1 - Deterministic execution | Same number of CPU cycles for every control pass | Not measured | Pending CPU implementation |
| R2 - LUT utilization | <= 1.25 x reference CPU LUT count | Reference count not yet established | Pending completed CPU synthesis |
| R3 - PWM correctness | Match golden-reference PWM outputs for 1,000 recorded passes | Not tested | Pending firmware execution |
| R4 - RV32I baseline tests | Pass all 40 official rv32ui tests | Not tested | Pending completed CPU |
| R4 - Serial monitor | Interactive typed serial monitor | Not tested | Pending UART integration |

Notes:
- The Basys 3 provides 20,800 LUTs, but this is the total device capacity,
  not the reference CPU utilization used for the R2 calculation.
- The empty top.v baseline cannot establish CPU execution time,
  instruction count, CPI, or RV32I correctness.
- The baseline clock constraint is 100 MHz (10 ns period).
- The final CPU clock frequency and timing must be verified after
  synthesis and implementation.
- At 50 MHz, 2.9 microseconds corresponds to 145 clock cycles.
  The actual allowable cycle count depends on the final CPU clock.

## Performance

Fill in from the week 7 benchmark: cycles from the timer, instruction count
from simulation.

| Program | Instructions | Cycles | CPI | Clock (MHz) | Run time |
| --- | --- | --- | --- | --- | --- |
| Motor Controller control pass | TBD | TBD | TBD | TBD | TBD |
| RV32I test suite | TBD | TBD | TBD | TBD | TBD |

## Baseline build notes

Build date: 11/19/2026
Tool: Vivado 2026.1
Board: Digilent Basys 3
FPGA: xc7a35tcpg236-1
Top module: top

Build status:
- Synthesis: Complete
- Implementation: Complete
- Bitstream generation: Complete

Synthesis resource utilization:
- Slice LUTs: 0 / 20,800
- Slice registers: 0 / 41,600
- Block RAM tiles: 0 / 50
- DSP slices: 0 / 90
- Bonded IOBs: 29 / 106

Routed timing:
- Clock: sys_clk_pin
- Clock period: 10.000 ns
- Clock frequency: 100.000 MHz
- Worst Negative Slack (WNS): N/A
- Total Negative Slack (TNS): N/A
- No meaningful timed CPU paths in the empty baseline.

The baseline bitstream demonstrates that the starter top.v can be built
successfully for the Basys 3. It does not demonstrate the performance,
resource utilization, or timing closure of the completed RV32I processor.

The final implemented utilization and any implementation warnings
should be reviewed separately.
