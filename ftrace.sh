
############## function definitions ##############
function print_usage(){
    echo "usage:"
    echo "  - tracing on:"
    echo "       $0 on <functions>"
    echo "  - tracing off:"
    echo "       $0 off"
    echo "  - tracing off & copy data:"
    echo "       $0 g"
    echo " "
    echo "functions:"
    echo "  - show_interrupts"
    echo " "
}

function config_event(){
    if [ "$FUNCTIONS" =  "show_interrupts" ]; then
        echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
        echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_entry/enable
        echo 1 > /sys/kernel/debug/tracing/events/irq/irq_handler_exit/enable
        sleep 1
        echo "event enabled"
    fi
}

################ tracing scripts ################
COMMAND=$1
FUNCTIONS=$2

if [ "$COMMAND" = "on" ]; then
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
    echo "tracing off"

else
    print_usage
    exit 1
fi

