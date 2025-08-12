
## trace on (* need to turn off)
./ftrace.sh set acpi_irq
./ftrace.sh add acpi_irq_stats_init
./ftrace.sh add acpi_ec_irq_handler
./ftrace.sh add acpi_ged_irq_handler
./ftrace.sh on

# request sleep
# echo mem > /sys/power/state
# Ctrl+A,C => qemu monitor mode
# system_wakeup
# Ctrl+A,C => kernel

