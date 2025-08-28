#!/bin/bash

# ===========================
# Server Stats Monitoring Script
# ===========================

echo "========================================"
echo "📊 SERVER PERFORMANCE STATS"
echo "Run Date: $(date)"
echo "Host: $(hostname)"
echo "========================================"

# ---- CPU Usage ----
echo ""
echo "🔹 CPU Usage:"
mpstat 1 1 | awk '/Average:/ {printf "CPU Usage: %.2f%%\n", 100 - $12}'

# ---- Memory Usage ----
echo ""
echo "🔹 Memory Usage:"
free -m | awk 'NR==2{printf "Used: %sMB | Free: %sMB | Usage: %.2f%%\n", $3,$4,$3*100/$2 }'

# ---- Disk Usage ----
echo ""
echo "🔹 Disk Usage:"
df -h --total | grep total | awk '{printf "Used: %s | Free: %s | Usage: %s\n", $3,$4,$5}'

# ---- Top Processes by CPU ----
echo ""
echo "🔹 Top 5 Processes by CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# ---- Top Processes by Memory ----
echo ""
echo "🔹 Top 5 Processes by Memory:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# ---- Stretch Goals ----
echo ""
echo "========================================"
echo "📌 EXTRA INFO"
echo "========================================"

# OS version
echo "OS Version: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/*release | head -n 1)"

# Uptime & Load Average
uptime -p
uptime | awk -F'load average:' '{ print "Load Average:" $2 }'

# Logged in users
echo "Logged in users: $(who | wc -l)"

# Failed login attempts (if logs available)
if [ -f /var/log/auth.log ]; then
    echo "Failed login attempts: $(grep -i 'failed password' /var/log/auth.log | wc -l)"
fi
