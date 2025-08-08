
## trace on (* need to turn off)
./ftrace.sh set __x64_sys_execve
./ftrace.sh add __x64_sys_clone
./ftrace.sh add kernel_clone
./ftrace.sh add copy_process
./ftrace.sh add do_exit
./ftrace.sh on

