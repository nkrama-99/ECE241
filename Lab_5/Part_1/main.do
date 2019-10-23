# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in main.v to working dir
# could also have multiple verilog files
vlog main.v

#load simulation using mux as the top level simulation module
vsim main

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# force {clk} 0 0ns , 1 {5ns} -r 10ns
# The first commands sets clk to after 0ns, then sets it to 1 after 5ns. This cycle repeats after 10ns.

#force {CLOCK_50} 0 0ns , 1 {10ns} -r 20ns
force {KEY[0]} 0
force {SW[1]} 0
force {SW[0]} 1
run 10ns

# Test enable functionality, no addition with enable=0 while posedge clk 
force {KEY[0]} 1
run 10ns

# Test enable functionality, addition with enable=1 while posedge clk
force {KEY[0]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

# Test clear functionality, while enable=1
force {KEY[0]} 0
force {SW[0]} 1
run 10ns

force {KEY[0]} 1
run 10ns

# Add some value again, ideally repeat until 0xFF
force {KEY[0]} 0
force {SW[1]} 1
force {SW[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

# Test clear functionality while enable=0
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns