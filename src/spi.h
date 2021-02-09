//extern void __fastcall__ spi_write_to(char *address, char data);
extern void __fastcall__ spi_write_16_addr(char *data);
extern void __fastcall__ spi_write_16_data(char *data);
extern void __fastcall__ spi_write(char data);
extern void __fastcall__ spi_begin();
extern void __fastcall__ spi_end();
extern void __fastcall__ spi_init();
extern char __fastcall__ spi_read(char data);
