vdel -lib work -all
vlib work
vlog -reportprogress 300 -work work register.v
vsim -voptargs="+acc" test_mux32
run -all