# AES-128 Cryptographic Core Using Verilog HDL

## 📌 Project Overview

This project focuses on the design and verification of an **AES-128 (Advanced Encryption Standard) Cryptographic Core** using Verilog HDL. AES is a symmetric-key encryption algorithm widely used to secure digital information.

The proposed design supports both **encryption and decryption** of 128-bit data using a 128-bit secret key. The RTL design is developed and functionally verified using Xilinx Vivado.

## 🎯 Objectives

- To design an AES-128 cryptographic core using Verilog HDL.
- To implement both encryption and decryption operations.
- To understand the internal AES transformation stages.
- To develop and verify the RTL design using Xilinx Vivado.
- To evaluate the design through simulation and FPGA-oriented implementation.

## 🔐 About AES-128

AES-128 is a symmetric block cipher that operates on:
- **Block size:** 128 bits
- **Key size:** 128 bits
- **Number of rounds:** 10

### AES Encryption Process

The encryption process consists of the following operations:

1. **SubBytes** – Replaces each byte using a substitution table (S-Box).
2. **ShiftRows** – Cyclically shifts the rows of the state matrix.
3. **MixColumns** – Performs column-wise mathematical transformations.
4. **AddRoundKey** – Combines the state with the round key using XOR.

The initial round, nine main rounds, and final round together form the AES-128 encryption process.

### AES Decryption Process

Decryption reverses the encryption transformations using:

- Inverse SubBytes
- Inverse ShiftRows
- Inverse MixColumns
- AddRoundKey

## 🛠️ Technologies Used

- **Hardware Description Language:** Verilog HDL
- **Design and Simulation Tool:** Xilinx Vivado
- **Target Platform:** FPGA
- **Verification:** Verilog Testbench

## 🏗️ Project Architecture

The AES-128 core consists of the following functional blocks:

- AES Top Module
- Key Expansion / Key Schedule
- SubBytes and Inverse SubBytes
- ShiftRows and Inverse ShiftRows
- MixColumns and Inverse MixColumns
- AddRoundKey
- Encryption and Decryption Control
- Testbench for Functional Verification

## 📂 Project Structure

```text
AES128-Cryptographic-Core/
│
├── RTL/
│   ├── aes128.v
│   ├── key_schedule.v
│   ├── round.v
│   ├── mix_col_lut.v
│   ├── inv_mix_col_lut.v
│   ├── sub_bytes_lut.v
│   └── rcon_lut.v
│
├── Testbench/
│   └── encryption_test.v
│
├── Simulation/
│   └── Simulation waveform screenshots
│
├── Results/
│   └── RTL schematic and implementation results
│
└── README.md
```

*Note: Adjust the folder names and file names above to match the actual files in your repository.*

## 🧪 Simulation and Verification

The RTL design was simulated using Xilinx Vivado.

- Functional simulation was performed using a Verilog testbench.
- Encryption and decryption operations were evaluated.
- The final simulation report showed **17 verification checks with zero detected errors**.

This result represents the checks performed by the project testbench and does not imply exhaustive verification of every possible input.

## 📊 Results

The project includes the following design and evaluation outputs:

- RTL schematic generated in Vivado.
- Functional simulation waveform.
- FPGA hardware evaluation screenshots, where applicable.
- Vivado power-analysis report.

The power-analysis report showed an estimated total on-chip power of **0.198 W**, including **0.136 W dynamic power**. These are Vivado estimates rather than direct hardware measurements.

## 🚀 Future Enhancements

- Improve the AES core architecture for higher operating frequency.
- Optimize hardware resource utilization.
- Perform more extensive functional verification.
- Evaluate timing and power across different FPGA devices.
- Explore integration with communication and secure data-storage systems.

## 📚 References

1. NIST, *Advanced Encryption Standard (AES)*, FIPS PUB 197, updated May 2023.
2. AMD/Xilinx, *Vivado Design Suite User Guides*.
3. Verilog Hardware Description Language documentation and IEEE standards.

## 👨‍💻 Project Team

**A. Prasanna**  
**CH. VV. Satyanarayana**

Department of Electronics and Communication Engineering  
Malla Reddy University, Hyderabad, India

**Project Guide:** Mrs. B. Sweetha

---

⭐ If you find this project useful, consider giving the repository a star!





