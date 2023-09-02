PORT ?= /dev/ttyUSB0

search_port:
	# check whether board connected.
	dmesg | grep ttyUSB
	
concat:
	xfel ddr d1
	xfel write $(FIRMWARE_ENTRY_PA) $(SBI_BIN)
	xfel write $(MMK_ENTRY_PA) $(MMK_BIN)
	xfel write $(PAYLOAD_ENTRY_PA) $(PAYLOAD_BIN)
	
run: concat
	xfel exec $(FIRMWARE_ENTRY_PA)
