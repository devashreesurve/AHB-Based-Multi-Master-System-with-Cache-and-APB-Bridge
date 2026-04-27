# AHB-Based-Multi-Master-System-with-Cache-and-APB-Bridge

## Overview

This project presents the **design and functional verification** of an AHB-based multi-master system implemented using **Verilog RTL** and verified using **SystemVerilog UVM** methodology.

The system demonstrates a simplified AMBA AHB interconnect featuring multiple masters, arbitration logic, pipelined transfers, address decoding, cache memory, RAM slave, and an AHB-to-APB bridge for low-speed peripheral communication.

Along with RTL implementation, a complete UVM verification environment was developed to validate memory read/write functionality, protocol transactions, scoreboard checking, and functional coverage.

This project combines both **front-end RTL design** and **verification engineering** skills relevant to ASIC / FPGA / SoC development.

---

## Key Features

### RTL Design

* Dual AHB Masters
* Round Robin Arbiter
* 2-Stage Pipeline
* Address Decoder
* Cache Controller
* AHB RAM Slave
* AHB to APB Bridge
* APB Peripheral Slave
* Integrated Top Module

### Verification (UVM)

* Transaction Class
* Sequence Generator
* Driver
* Monitor
* Scoreboard
* Functional Coverage
* Environment
* Testbench Automation

---

## System Architecture

```text
AHB Master 1 (Read)
AHB Master 2 (Write)
        ↓
Round Robin Arbiter
        ↓
2-Stage Pipeline
        ↓
Address Decoder
   ├── Cache Controller
   ├── AHB RAM
   └── AHB to APB Bridge
                ↓
          APB Peripheral
```

---

## RTL Modules

* `ahb_master1`
* `ahb_master2`
* `ahb_arbiter`
* `ahb_decoder`
* `ahb_cache_controller`
* `ahb_ram_slave`
* `ahb_apb_bridge`
* `apb_slave_device`
* `ahb_system_top`

---

## Verification Components

* `ahb_txn`
* `ahb_seq`
* `ahb_driver`
* `ahb_monitor`
* `ahb_scoreboard`
* `ahb_coverage`
* `ahb_env`
* `ahb_test`

---

## Test Scenarios Covered

### Directed Tests

* Sequential Write to all addresses
* Sequential Read from all addresses
* Read After Write

### Random Tests

* Randomized address/data transactions
* Mixed read/write operations

### Corner Cases

* Address boundary testing
* Back-to-back transactions
* Data consistency validation

---

## Simulation Results

| Metric              | Result     |
| ------------------- | ---------- |
| Functional Coverage | 100%       |
| PASS Count          | 26         |
| FAIL Count          | 0          |
| Simulation Status   | Successful |

---

## Tools Used

* Verilog HDL
* SystemVerilog
* UVM
* Cadence Xcelium
* EDA Playground
* RTL Schematic Viewer


---

## Learning Outcomes

* AMBA AHB / APB Protocol Understanding
* RTL Design Methodology
* Bus Arbitration Logic
* Cache Memory Concepts
* SoC Interconnect Design
* UVM Verification Flow
* Functional Coverage Analysis
* ASIC Verification Practices

---

## Resume Highlights

* Designed multi-master AHB bus system using Verilog RTL.
* Implemented cache, RAM, APB bridge and pipelined data path.
* Developed UVM verification environment with scoreboard and coverage.
* Achieved 100% functional coverage with zero mismatches.

---

## Author

**Devashree Surve**
Electronics Engineering (VLSI Design & Technology)

---
