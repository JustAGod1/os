typedef char byte;

byte letters_lookup[] = {
	0x18, 0x18, 0x24, 0x24, 0x3C, 0x42, 0x42, 0x42, // A
	0x70, 0x48, 0x48, 0x78, 0x44, 0x44, 0x44, 0x78, // B
	0x1C, 0x20, 0x40, 0x40, 0x40, 0x40, 0x20, 0x1C  // C
};

void set_frag(unsigned short x, unsigned short y, byte value) {
	*((byte *)(0xA0000 + x + y * 80)) = value;
}

unsigned short posX = 0, posY = 0;
void draw_letter(char letter) {
	for (int i = 0; i < 8; i++) {
		set_frag(posX, posY + i, letters_lookup[i + (letter - 'A') * 8]);
	}
	posX++;
}

void kmain(void) {
	draw_letter('A');
	draw_letter('A');
	draw_letter('B');
	draw_letter('C');
	while (1);
}
