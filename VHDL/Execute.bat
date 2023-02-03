
ghdl -a ./SignExtenders/SE_4_8.vhd
ghdl -a ./SignExtenders/SE_8_16.vhd

ghdl -a ./Multiplexers/mux_4bit_2_1.vhd
ghdl -a ./Multiplexers/mux_8bit_2_1.vhd
ghdl -a ./Multiplexers/mux_16bit_2_1.vhd
ghdl -a ./Multiplexers/mux_8bit_3_1.vhd
ghdl -a ./Multiplexers/mux_16bit_3_1.vhd

ghdl -a ./Combinatori/adder_8bit.vhd
ghdl -a ./Combinatori/ALU.vhd
ghdl -a ./Combinatori/LUT.vhd
ghdl -a ./Combinatori/AND_gate.vhd
ghdl -a ./Combinatori/OR_gate.vhd
ghdl -a ./Combinatori/Data_Hazard_Control.vhd
ghdl -a ./Combinatori/Control_Hazard_Unit.vhd

ghdl -a ./Registri_e_Memorie/PC.vhd
ghdl -a ./Registri_e_Memorie/registers.vhd
ghdl -a ./Registri_e_Memorie/FF_T.vhd
ghdl -a ./Registri_e_Memorie/IM.vhd
ghdl -a ./Registri_e_Memorie/DM.vhd

ghdl -a ./Registri_e_Memorie/pipe_IF_ID.vhd
ghdl -a ./Registri_e_Memorie/pipe_ID_EX.vhd
ghdl -a ./Registri_e_Memorie/pipe_EX_MEM.vhd
ghdl -a ./Registri_e_Memorie/pipe_MEM_WB.vhd

ghdl -a ./Stages/Fetch_Stage.vhd
ghdl -a ./Stages/Decode_stage.vhd
ghdl -a ./Stages/Execute_Stage.vhd
ghdl -a ./Stages/Memory_Stage.vhd


ghdl -a SPP_system.vhd
ghdl -a SPP_TB.vhd

ghdl -r SPP_TB --vcd=tb.vcd
gtkwave tb.vcd conf.gtkw
