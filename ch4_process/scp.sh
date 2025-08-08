
COMMAND=$1
FILES=$2

if [ "$COMMAND" = "s" ]; then
    # check - args
    if [ $# -lt 2 ]; then
        echo "need more args"
        exit 1
    fi

    ## send binary to target
    scp -P 10023 $FILES root@localhost:/root

elif [ "$COMMAND" = "l" ]; then
    ## connect ssh to trace
    ssh root@localhost -p 10023

elif [ "$COMMAND" = "g" ]; then
    # check - args
    if [ $# -lt 2 ]; then
        echo "need more args"
        exit 1
    fi
    ## recieve files from target (default path: /root)
    scp -P 10023 root@localhost:/root/$FILES $PWD
fi

