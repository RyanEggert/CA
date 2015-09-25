vdel -lib work -all
vlib work
vlog -reportprogress 1000 -work work multiplexer.v
vsim -voptargs="+acc" testMultiplexer
add wave -position insertpoint  \
sim:/testMultiplexer/beh_multip/address1 \
sim:/testMultiplexer/beh_multip/address0 \
sim:/testMultiplexer/beh_multip/in3 \
sim:/testMultiplexer/beh_multip/in2 \
sim:/testMultiplexer/beh_multip/in1 \
sim:/testMultiplexer/beh_multip/in0 \
sim:/testMultiplexer/beh_multip/out \
sim:/testMultiplexer/str_multip/out 
run -all
wave zoom full