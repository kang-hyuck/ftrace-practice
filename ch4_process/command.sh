
## trace on (* need to turn off)
./ftrace.sh set __x64_sys_clone
./ftrace.sh add do_exit
./ftrace.sh add __do_sys_fork
./ftrace.sh add copy_process
./ftrace.sh on

