 #
 # Copyright (C) 2017 Kubos Corporation
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #     http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 #
 #############################################################################
 # Flash Kubos Linux related NOR flash files on the at91sam9g20isis board
 # using the SAM-BA flashing utility
 #############################################################################
 #
 # THIS SCRIPT MUST RUN ON A WINDOWS MACHINE. SAM-BA USING JLINK IS ONLY
 # SUPPORTED FOR WINDOWS.
 #
 #############################################################################
 #
 # Pre-Requisites:
 #
 # 1. You must have the iOBC board files installed in your SAM-BA instance
 #
 # 2. Update the {path to SAM-BA}/tcl_lib/boards.tcl file to change this line:
 #   "at91sam9g20-ISISOBC"    "at91sam9g20-ISISOBC/at91sam9g20-ISISOBC.tcl"
 # to this:
 #   "at91sam9g20-isisobc"    "at91sam9g20-ISISOBC/at91sam9g20-ISISOBC.tcl"
 # (the command line converts everything to lower case, which will lead to 
 #  a "board not found" error if you don't change this file)
 #
 #############################################################################
 #
 # Note: The iOBC must be connected, powered, and not running Kubos Linux
 #  in order for this script to work. (If board is currently running 
 #  Kubos Linux, reboot the board and hold down any key to boot into the 
 #  U-Boot CLI instead)
 # 
 # This script will be passed as an argument when calling the SAM-BA flashing
 # utility:
 #   $ {path to SAM-BA}/sam-ba.exe \jlink\ARM0 at91sam9g20-ISISOBC \
 #        kubos-nor-flash.tcl {input arguments} [> {logfile}]
 # 
 # No output will be printed to STDOUT. Instead, it is recommended that
 # you pass the data into a log file. Additionally, the command will
 # immediately return, even though the script is still running, so wait
 # 10-15 seconds before checking the log file to see if it ran successfully.
 #
 # Inputs:
 #  * uboot={uboot file} - Path to U-Boot binary
 #  * dtb={dtb file} - Path to Device Tree binary
 #  * altos={alt file} - Path to alternate OS binary
 # 
 # Example:
 #
 #   $ C:/ISIS/applications/samba/sam-ba.exe /jlink/ARM0 at91sam9g20-ISISOBC \
 #        kubos-nor-flash.tcl uboot=new-u-boot.bin dtb=new-dtb.dtb \
 #        > logfile.log
 #

puts "Running Kubos NOR flash script"
 
 # The first 3 arguments are from the sam-ba command, so ignore them
if { $argc < 4 } {
	puts "ERROR: Please specify at least one file to flash."
	return 1
}

# Init NOR Flash
NORFLASH::Init

foreach arg $::argv {
	
	if {![string match *=* "$arg"]} {
		continue
	}

	# Tokenize argument around '='
	set fields [split $arg "="]
	set param [lindex $fields 0]
	set file [lindex $fields 1]

	if {[string match "uboot" $param]} {
		set addr 0x0000A000
	} elseif {[string match "dtb" $param]} {
		set addr 0x00070000
	} elseif {[string match "altos" $param]} {
		set addr 0x00080000
	} else {
		puts "Unknown file type: $param"
		continue
	}
	
	# Flash and verify
	send_file {NorFlash} "$file" $addr 0
	compare_file {NorFlash} "$file"  $addr 0

}

puts "Flashing script has completed"

return 0
