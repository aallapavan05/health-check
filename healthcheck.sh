#!/bin/bash
# ----------------------------------------------------------
# Windows-Compatible System Health Check Script
# ----------------------------------------------------------

LOG_FILE="healthlog.txt"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

{
echo "============================================"
echo " System Health Report - $TIMESTAMP"
echo "============================================"

# --- System Date & Time ---
echo "Date & Time: $(date)"

# --- Uptime (PowerShell) ---
echo "Uptime:"
powershell.exe -Command "(Get-Uptime).ToString('dd\.hh\:mm\:ss')" 2>/dev/null

# --- CPU Load (use WMIC or PowerShell) ---
echo "CPU Load:"
powershell.exe -Command "Get-Counter '\Processor(_Total)\% Processor Time' | Select -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue" 2>/dev/null

# --- Memory Usage ---
echo "Memory Usage (MB):"
powershell.exe -Command "Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize,FreePhysicalMemory" 2>/dev/null

# --- Disk Usage ---
echo "Disk Usage:"
powershell.exe -Command "Get-PSDrive -PSProvider 'FileSystem' | Select-Object Name,Used,Free" 2>/dev/null

# --- Top 5 Memory-Consuming Processes ---
echo "Top 5 Memory-Consuming Processes:"
powershell.exe -Command "Get-Process | Sort-Object WS -Descending | Select-Object -First 5 Name,Id,CPU,WS" 2>/dev/null

# --- Service Checks (nginx, sshd examples) ---
echo "Service Status:"
for svc in nginx sshd; do
  powershell.exe -Command "if (Get-Service -Name '$svc' -ErrorAction SilentlyContinue) { Write-Host '$svc : ' (Get-Service -Name '$svc').Status } else { Write-Host 'Service $svc not found' }"
done
echo "--------------------------------------------"
echo ""
} >> "$LOG_FILE"

echo "✅ Health check completed. Log saved to $LOG_FILE"

