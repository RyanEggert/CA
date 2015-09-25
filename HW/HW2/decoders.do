vdel -lib work -all
vlib work
vlog -reportprogress 300 -work work decoder.v
vsim -voptargs="+acc" testDecoder
add wave -position insertpoint  \
sim:/testDecoder/beh_decoder/address1 \
sim:/testDecoder/beh_decoder/address0 \
sim:/testDecoder/beh_decoder/enable \
sim:/testDecoder/beh_decoder/out3 \
sim:/testDecoder/beh_decoder/out2 \
sim:/testDecoder/beh_decoder/out1 \
sim:/testDecoder/beh_decoder/out0 \
sim:/testDecoder/str_decoder/out3 \
sim:/testDecoder/str_decoder/out2 \
sim:/testDecoder/str_decoder/out1 \
sim:/testDecoder/str_decoder/out0 

run -all
wave zoom full
