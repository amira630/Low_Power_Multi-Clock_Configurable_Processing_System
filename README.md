# Low Power Multi-Clock Configurable Processing System

## Overview

This is a comprehensive digital design project implementing a low-power, multi-clock domain configurable processing system in Verilog. The architecture is optimized for embedded and IoT applications with flexible configuration options and sophisticated clock domain crossing techniques.

**Current Status**: UART communication interface implementation complete. Additional subsystems under development.

## Project Structure

```
UART/                 # Communication Interface (COMPLETED)
├── UART_RX/          # UART Receiver Module
│   ├── UART_RX.v     # Main receiver module (98 lines)
│   ├── FSM.v         # Receiver finite state machine
│   ├── Data_Sampling.v
│   ├── Deserializer.v
│   ├── Edge_Bit_Counter.v
│   ├── Parity_Check.v
│   ├── Start_Check.v
│   └── Stop_Check.v
└── UART_TX/          # UART Transmitter Module
    ├── UART_TX.v     # Main transmitter module (52 lines)
    ├── UART_TX_tb.v  # Testbench
    ├── FSM.v         # Transmitter finite state machine
    ├── Serializer.v
    ├── Parity_Calc.v
    ├── MUX4x1.v
    ├── RUN.do        # ModelSim simulation script
    └── UART_TX.vcd   # Waveform output
```

## Planned Architecture

The complete system will include the following subsystems:

### In Development
- 🔧 **UART Interface**: Serial communication receiver and transmitter (⚠️ Verification pending - UART RX and complete UART subsystem)

### Planned Modules
- ⏳ **System Controller**: Main control unit managing system operation
- ⏳ **Register File**: Configuration and status register storage
- ⏳ **ALU**: Arithmetic and logic operations
- ⏳ **Asynchronous FIFO**: Cross-domain data buffering
- ⏳ **Data Synchronizer**: Multi-clock domain synchronization
- ⏳ **Reset Synchronizers**: Safe reset distribution across domains
- ⏳ **Clock Gating**: Dynamic power reduction
- ⏳ **Clock Dividers**: Configurable clock generation

## UART Module Features

### UART Receiver (RX)
- Configurable prescale ratio for baud rate selection
- Programmable parity control (even/odd)
- Data sampling with glitch detection
- Frame error detection (start/stop bits)
- Parity error detection
- Modular design with separate components:
  - FSM: Protocol state machine
  - Data Sampling: Clock synchronization
  - Deserializer: Serial-to-parallel conversion
  - Parity Check: Data integrity validation
  - Start/Stop Check: Frame validation

### UART Transmitter (TX)
- Configurable prescale ratio
- Programmable parity generation
- Data serialization with multiplexing
- Busy signal for flow control
- Modular architecture:
  - FSM: Control state machine
  - Serializer: Parallel-to-serial conversion
  - Parity Calculator: Parity bit generation
  - Multiplexer: Output data selection

## Module Interfaces

### UART_RX
**Inputs:**
- `clk`: System clock
- `rst_n`: Active-low reset
- `RX_IN`: Serial input data
- `Prescale[5:0]`: Baud rate prescaler value
- `Par_En`: Parity enable
- `Par_Typ`: Parity type (0=Even, 1=Odd)

**Outputs:**
- `P_DATA[7:0]`: Parallel data output
- `Data_Valid`: Data ready flag
- `PAR_Err`: Parity error flag
- `STP_Err`: Stop bit error flag

### UART_TX
**Inputs:**
- `clk`: System clock
- `rst_n`: Active-low reset
- `P_DATA[7:0]`: Parallel data input
- `Data_Valid`: Data input valid flag
- `Par_En`: Parity enable
- `Par_Typ`: Parity type (0=Even, 1=Odd)

**Outputs:**
- `TX_OUT`: Serial output data
- `Busy`: Transmitter busy flag

## Simulation & Testing

- **Testbench**: [UART_TX_tb.v](UART/UART_TX/UART_TX_tb.v)
- **Simulation Script**: [RUN.do](UART/UART_TX/RUN.do) (ModelSim format)
- **Waveforms**: [UART_TX.vcd](UART/UART_TX/UART_TX.vcd)

To run simulations in ModelSim:
```tcl
do RUN.do
```

## Development Status

🚧 **Work in Progress**

**Phase 1 (Current)**: UART communication subsystem
- Core UART RX and TX modules implemented
- ⚠️ **UART RX verification pending**
- ⚠️ **Complete UART verification pending**
- Testbench and simulation setup in place
- Awaiting functional verification before integration

**Phase 2 (Planned)**: Control and processing unit
- System controller development
- Register file implementation
- ALU design

**Phase 3 (Planned)**: Power and clock management
- Clock dividers and gating logic
- Low-power optimization
- Multi-clock domain crossing

## Key Design Considerations

1. **Modularity**: Separated concerns allow for independent testing and reuse
2. **Configurability**: Runtime parameters for prescale and parity options
3. **Error Detection**: Comprehensive error flags for protocol violations
4. **Multi-Clock Support**: Designed to handle prescaler-based clock domain crossing
5. **Low Power**: Scalable design suitable for embedded and IoT applications

## Next Steps

- [ ] Complete UART verification and testing
- [ ] Implement System Controller
- [ ] Develop Register File
- [ ] Design ALU
- [ ] Integrate Asynchronous FIFO
- [ ] Add Data Synchronizer for multi-clock domains
- [ ] Implement Reset Synchronizers
- [ ] Add Clock Gating logic
- [ ] Integrate Clock Dividers
- [ ] System-level integration and verification
- [ ] Performance and power optimization
- [ ] Synthesis and layout

## Notes

This project is Eng. Ali El Temsah's course final project, focusing on low-power configurable processing systems with emphasis on communication protocol implementation.
