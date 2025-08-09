
## trace on (* need to turn off)
./ftrace.sh set serial8250_interrupt
./ftrace.sh add serial8250_rx_chars
./ftrace.sh add serial8250_tx_chars
./ftrace.sh add serial8250_handle_irq
./ftrace.sh on

