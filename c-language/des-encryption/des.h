#ifndef _STRUCTURE_DES_H_
#define _STRUCTURE_DES_H_

#define ENCRYPT_MODE 1
#define DECRYPT_MODE 0

typedef struct {
	unsigned char k[8];
	unsigned char c[4];
	unsigned char d[4];
} key_bunch;

void keyGen(unsigned char* key);
void subKeysGen(unsigned char* main_key, key_bunch* key_sets);
void process_msg(unsigned char* message_piece, unsigned char* processed_piece, key_bunch* key_sets, int mode);
void printHelp(char* argv[]);

#endif

