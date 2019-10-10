# set the working dir, where all compiled verilog goes
vlib 7400s_work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog 7400s.v

#load simulation using mux as the top level simulation module
vsim v7404

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
force {pin1} 0
force {pin3} 0
force {pin5} 0
force {pin7} 0
force {pin9} 0
force {pin11} 0
#run simulation for a few ns
run 10ns

#second test case, change input values and run for another 10ns
force {pin1} 1
force {pin3} 1
force {pin5} 1
force {pin7} 1
force {pin9} 1
force {pin11} 1
run 10ns