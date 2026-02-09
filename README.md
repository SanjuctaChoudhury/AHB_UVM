# AHB_UVM--- WIP work in progress

Universal Verification Methodology (UVM) based verification environment for the **AMBA AHB (Advanced High-performance Bus)** protocol.

## 🚀 Overview

This project implements a **UVM-based testbench** for verifying designs that comply with the **AHB protocol**, using SystemVerilog and the standardized UVM methodology.  
The environment drives AHB transactions to the design under test (DUT), including read, write, burst, and back-to-back transfers, and checks the responses to ensure correct protocol implementation.

AHB (Advanced High-performance Bus) is part of the **AMBA** protocol family and is widely used in **SoC designs** for high-performance, pipelined, and multi-master bus communication.

## ⚙️ Features

- ⭐ **Complete UVM Testbench**  
  Includes transaction classes, sequencer, drivers, monitors, agents, environment, and scoreboard.

- 📊 **Multiple Test Sequences**  
  Supports:
  - Single read/write transfers  
  - Burst transfers  
 

- 💡 **Functional Coverage Support**  
  Modular coverage components to track protocol and functional coverage goals.

- 🔍 **Protocol Checking**  
  Validates AHB handshaking, transfer types, burst behavior, and response signals.

## 🛠️ Getting Started

### Requirements

To compile and simulate this project, you will need:

- A **SystemVerilog-capable simulator**, such as:
  - QuestaSim
  - Synopsys VCS
  - Cadence Xcelium
  - Riviera-PRO

- **UVM library**
  - Accellera UVM 1.x (or compatible)

