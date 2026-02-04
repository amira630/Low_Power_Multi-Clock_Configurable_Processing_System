# Low Power Multi-Clock Configurable Processing System

## Overview

This is a comprehensive digital design project implementing a low-power, multi-clock domain configurable processing system in Verilog. The architecture targets embedded and IoT applications with flexible configuration options and explicit support for multi-clock domain crossing.

**Current Status (summary)**: multiple modules and testbenches are present in the repository. UART RX/TX are implemented and have testbenches and simulation scripts. Several other modules are implemented (ALU, register file, clocking and synchronization primitives), but need unit tests and system integration verification.

## Project snapshot (what's present)

- UART/
  - UART_RX/ `UART_RX.v` — receiver sources, `UART_RX_tb.v`, `RUN.do`, `UART_RX.vcd`
  - UART_TX/ `UART_TX.v` — transmitter sources, `UART_TX_tb.v`, `RUN.do`, `UART_TX.vcd`
  - `UART.v` — Top Module, `UART_tb.v`, `RUN.do`, `UART.vcd`
- ALU/`ALU.v`
- Reg_File/`Reg_File.v`
- SYS_CTRL/`SYS_CTRL.v`
- Clock_Divider/
  - `CLK_DIV.v`, `PRESCALE_MUX.v`
- Clock_Gating/`CLK_GATE.v`
- Data Synchronizers/
  - `DATA_SYNC.v`, `RST_SYNC.v`
  - `ASYNC_FIFO/` (`ASYNC_FIFO.v`, `FIFO_WR.v`, `FIFO_RD.v`, `Dual_Port_RAM.v`, `BIT_SYNC.v`)
- Pulse_Generator/`PULSE_GEN.v`

## Verified / Tested

- UART RX and UART TX: testbenches (`UART_RX_tb.v`, `UART_TX_tb.v`), ModelSim `RUN.do` scripts and generated VCD waveforms are present and ready to run.
- UART Top (TX + RX): testbenches (`UART_tb.v`), ModelSim `RUN.do` scripts and generated VCD waveforms are present and ready to run.

## Recommended Simulation & Testflow

1. Use ModelSim (provided `RUN.do`) or an open-source flow (Icarus Verilog + GTKWave) for unit tests.
2. Standardize each module with a `<module>_tb.v` and a `RUN.do` that:
   - compiles sources, runs the testbench, and writes a VCD
   - contains simple pass/fail checks (asserts) where feasible
3. Add a top-level smoke test that instantiates UART + control signals to exercise basic data flow across clock domains.

To run a provided ModelSim script (example):
```tcl
do RUN.do
```

## Development Status (accurate)

Implemented (sources present)
- UART: RX and TX with testbenches and simulation scripts
- ALU: `ALU/ALU.v`
- Register File: `Reg_File/Reg_File.v`
- System Controller: `SYS_CTRL/SYS_CTRL.v`
- Clock Divider: `Clock_Divider/CLK_DIV.v`
- Clock Gating: `Clock_Gating/CLK_GATE.v`
- Data Synchronizers: `Data Synchronizers/DATA_SYNC.v`, `Data Synchronizers/RST_SYNC.v`
- Asynchronous FIFO and submodules: `Data Synchronizers/ASYNC_FIFO/`
- Pulse Generator: `Pulse_Generator/PULSE_GEN.v`

Verified / Tested
- UART RX and UART TX: unit testbenches, `RUN.do` scripts, and VCDs present.

Remaining work
- Unit-testing: add focused testbenches for `ALU`, `Reg_File`, `SYS_CTRL`, `CLK_DIV`, `CLK_GATE`, `DATA_SYNC`, `RST_SYNC`, `ASYNC_FIFO` and FIFO submodules.
- Standardize `RUN.do`/test naming and add pass/fail checks instead of only VCD output.
- Create top-level integration tests that exercise multiple clock domains and the system controller.
- Add simple regression automation (batch script or CI) to run unit tests and collect results.
- Perform performance/power characterization and then synthesis and place-and-route.

## Next Steps (short checklist)

- [x] UART RX/TX: sources + testbenches present
- [ ] Unit tests for other cores (`ALU`, `Reg_File`, `SYS_CTRL`, `Clock` and `Sync` blocks)
- [ ] Top-level block/system integration testing
- [ ] Regression automation / CI
- [ ] Performance/power tuning and synthesis

## Notes

This project is Eng. Ali El Temsah's course final project, focusing on low-power configurable processing systems with emphasis on communication protocol implementation.