# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]       
 set_property IOSTANDARD LVCMOS33 [get_ports clk]
 
 ## positches
set_property PACKAGE_PIN M1 [get_ports {switch}]
    set_property IOSTANDARD LVCMOS33 [get_ports {switch}]
set_property PACKAGE_PIN M2 [get_ports {touch}]
    set_property IOSTANDARD LVCMOS33 [get_ports {touch}]


set_property PACKAGE_PIN V17 [get_ports {touch_state}]
    set_property IOSTANDARD LVCMOS33 [get_ports {touch_state}]

set_property PACKAGE_PIN U18 [get_ports {reset}]
    set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
    
set_property PACKAGE_PIN N2 [get_ports {servo_a}]
    set_property IOSTANDARD LVCMOS33 [get_ports {servo_a}]
set_property PACKAGE_PIN N1 [get_ports {servo_b}]
    set_property IOSTANDARD LVCMOS33 [get_ports {servo_b}]
    
set_property PACKAGE_PIN U16 [get_ports {led[0]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN N3 [get_ports {led_one[0]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led_one[0]}]
set_property PACKAGE_PIN P1 [get_ports {led_one[1]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led_one[1]}]
set_property PACKAGE_PIN L1 [get_ports {led_one[2]}]                   
    set_property IOSTANDARD LVCMOS33 [get_ports {led_one[2]}]