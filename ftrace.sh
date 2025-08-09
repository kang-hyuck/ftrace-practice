
############## function definitions ##############
function print_usage(){
    echo "usage:"
    echo "  - tracing run:"
    echo "       $0 run <functions>"
    echo "  - tracing on:"
    echo "       $0 on"
    echo "  - tracing off:"
    echo "       $0 off"
    echo "  - tracing off & copy data:"
    echo "       $0 g"
    echo "  - set first filter function"
    echo "       $0 set <functions>"
    echo "  - add filter function"
    echo "       $0 add <functions>"
    echo "  - grep available filter function"
    echo "       $0 grep <functions>"
    echo " "
    echo "functions:"
    echo "  - show_interrupts"
    echo "  - __x64_sys_clone"
    echo "  - do_exit"
    echo "  - kernel_clone"
    echo "  - copy_process"
    echo "  - __x64_sys_execve"
    echo "  - serial8250_interrupt"
    echo "  - serial8250_rx_chars"
    echo "  - serial8250_tx_chars"
    echo "  - serial8250_handle_irq"
    echo " "
}

function config_event(){
    if [ "$FUNCTIONS" =  "show_interrupts" ]; then
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
        echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_entry/enable
        echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_exit/enable
        sleep 1
        echo "event enabled"

    elif [ "$FUNCTIONS" =  "__x64_sys_clone" ]; then
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_fork/enable
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_exit/enable
        echo 1 > /sys/kernel/debug/tracing/events/signal/enable
        sleep 1
        echo "event enabled"

    elif [ "$FUNCTIONS" =  "__x64_sys_execve" ]; then
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_exec/enable
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_free/enable
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_fork/enable
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_exit/enable

    elif [ "$FUNCTIONS" =  "serial8250_interrupt" ]; then
        echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_entry/enable
        echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_exit/enable
    fi
}

################ tracing scripts ################
COMMAND=$1
FUNCTIONS=$2

if [ "$COMMAND" = "run" ]; then
    ## check - args
    if [ $# -lt 2 ]; then
        print_usage
        exit 1
    fi

    ## check - availability of tracing functions
    if grep -xq "$FUNCTIONS" /sys/kernel/debug/tracing/available_filter_functions; then
        echo "$FUNCTIONS: available"
    else
        echo "$FUNCTIONS: not available"
        exit 1
    fi

    ## tracing off
    echo 0 > /sys/kernel/debug/tracing/tracing_on
    sleep 1

    ## event disabled
    echo 0 > /sys/kernel/debug/tracing/events/enable
    sleep 1

    ## set functions
    echo $FUNCTIONS > /sys/kernel/debug/tracing/set_ftrace_filter
    sleep 1

    ## select tracer (function)
    echo function > /sys/kernel/debug/tracing/current_tracer
    sleep 1

    ## config event
    config_event

    ## config function stack trace
    echo 1 > /sys/kernel/debug/tracing/options/func_stack_trace
    echo 1 > /sys/kernel/debug/tracing/options/sym-offset

    ## tracing on
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo "tracing on"

elif [ "$COMMAND" = "g" ]; then
    ## tracing off
    echo 0 > /sys/kernel/debug/tracing/tracing_on
    echo "tracing off"

    ## copy log
    cp /sys/kernel/debug/tracing/trace ${PWD}/ftrace_log.txt
    echo "copy ftrace"

elif [ "$COMMAND" = "off" ]; then
    ## tracing off
    echo 0 > /sys/kernel/debug/tracing/tracing_on

    ## event disabled
    echo 0 > /sys/kernel/debug/tracing/events/enable
    sleep 1

    echo "tracing off"

elif [ "$COMMAND" = "add" ]; then
    ## check - args
    if [ $# -lt 2 ]; then
        print_usage
        exit 1
    fi

    ## check - availability of tracing functions
    if grep -xq "$FUNCTIONS" /sys/kernel/debug/tracing/available_filter_functions; then
        echo "$FUNCTIONS: available"
    else
        echo "$FUNCTIONS: not available"
        exit 1
    fi

    ## config event
    config_event

    ## add functions (append: >>)
    echo $FUNCTIONS >> /sys/kernel/debug/tracing/set_ftrace_filter
    sleep 1

    echo "add '$FUNCTIONS': ok"

elif [ "$COMMAND" = "set" ]; then
    ## check - args
    if [ $# -lt 2 ]; then
        print_usage
        exit 1
    fi

    ## check - availability of tracing functions
    if grep -xq "$FUNCTIONS" /sys/kernel/debug/tracing/available_filter_functions; then
        echo "$FUNCTIONS: available"
    else
        echo "$FUNCTIONS: not available"
        exit 1
    fi

    ## config event
    config_event

    ## set functions
    echo $FUNCTIONS > /sys/kernel/debug/tracing/set_ftrace_filter
    sleep 1

    echo "set '$FUNCTIONS': ok"

elif [ "$COMMAND" = "grep" ]; then
    ## check - args
    if [ $# -lt 2 ]; then
        print_usage
        exit 1
    fi

    ## print grep reults
    grep "$FUNCTIONS" /sys/kernel/debug/tracing/available_filter_functions

elif [ "$COMMAND" = "on" ]; then
    ## select tracer (function)
    echo function > /sys/kernel/debug/tracing/current_tracer
    sleep 1

    ## config function stack trace
    echo 1 > /sys/kernel/debug/tracing/options/func_stack_trace
    echo 1 > /sys/kernel/debug/tracing/options/sym-offset

    ## tracing on
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo "tracing on"

else
    print_usage
    exit 1
fi

