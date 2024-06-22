set_global_assignment -entity "VGA_40MHz" -library "lib_VGA_40MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "VGA_40MHz" -library "lib_VGA_40MHz" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "VGA_40MHz" -library "lib_VGA_40MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_VGA_40MHz" -name SPD_FILE [file join $::quartus(sip_path) "VGA_40MHz.spd"]

set_global_assignment -library "lib_VGA_40MHz" -name MISC_FILE [file join $::quartus(sip_path) "VGA_40MHz_sim/VGA_40MHz.vo"]
