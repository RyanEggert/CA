vdel -lib work -all
vlib work
vlog -reportprogress 300 -work work decoder.v
vsim -voptargs="+acc" testDecoder
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
