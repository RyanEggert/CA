vdel -lib work -all
vlib work
vlog -reportprogress 300 -work work adder.v
vsim -voptargs="+acc" testFullAdder
add wave -position insertpoint  \
sim:/testFullAdder/beh_adder/a \
sim:/testFullAdder/beh_adder/b \
sim:/testFullAdder/beh_adder/carryin \
sim:/testFullAdder/beh_adder/sum \
sim:/testFullAdder/beh_adder/carryout \
sim:/testFullAdder/str_adder/sum \
sim:/testFullAdder/str_adder/carryout 
run -all
wave zoom full
