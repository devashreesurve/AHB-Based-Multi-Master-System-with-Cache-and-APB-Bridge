`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

// ================= INTERFACE =================
interface ahb_if(input logic clk);
    logic [3:0] HADDR;
    logic [7:0] HWDATA;
    logic [7:0] HRDATA;
    logic HWRITE;
    logic [1:0] HTRANS;
    logic HSEL;
endinterface
