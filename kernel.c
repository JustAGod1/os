void kmain(void) {
	for (int i = 0; i < 300; i++) {
		*((char *)(0xA0000 + i)) = 4;
	}
}
