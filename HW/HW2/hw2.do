vdel -lib work -all
vlib work
vlog -reportprogress 300 -work work multiplexer.v decoder.v adder.v
vsim -voptargs="+acc" testMultiplexer
run -all
#add wave -position insertpoint  \
sim:/testDecoder/addr0 \
sim:/testDecoder/addr1 \
sim:/testDecoder/enable \
sim:/testDecoder/out0 \
sim:/testDecoder/out1 \
sim:/testDecoder/out2 \
sim:/testDecoder/out3
# run -all
# wave zoom full

vsim -voptargs="+acc" testFullAdder
run -all
vsim -voptargs="+acc" testDecoder
run -all