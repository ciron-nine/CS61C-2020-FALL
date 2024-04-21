/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

int check(int row, int col, int cols, int rows) {
	return row >= 0 && row < rows && col >=0 && col < cols;
}

int aliveCell(Image * image, int row, int col) {
	int dx[8] = {-1, 1, -1, 1, -1, 1, 0, 0}; 
	int dy[8] = {0, 0, 1, 1, -1, -1, 1, -1};
	int count = 0;
	for(int i = 0; i < 8; i ++) {
		if(!check(row + dx[i], col + dy[i], image->cols, image->rows)) continue;
		Color color = image->image[row + dx[i]][col + dy[i]];
		if(color.R || color.G || color.B) {
			count ++;
		}
	}
	return count;
}


int CellR(Image * image, int row, int col) {
	int dx[8] = {-1, 1, -1, 1, -1, 1, 0, 0}; 
	int dy[8] = {0, 0, 1, 1, -1, -1, 1, -1};
	int R = 0;
	for(int i = 0; i < 8; i ++) {
		if(!check(row + dx[i], col + dy[i], image->cols, image->rows)) continue;
		Color color = image->image[row + dx[i]][col + dy[i]];
		R += color.R;
	}
	return R;
}

int CellG(Image * image, int row, int col) {
	int dx[8] = {-1, 1, -1, 1, -1, 1, 0, 0}; 
	int dy[8] = {0, 0, 1, 1, -1, -1, 1, -1};
	int G = 0;
	for(int i = 0; i < 8; i ++) {
		if(!check(row + dx[i], col + dy[i], image->cols, image->rows)) continue;
		Color color = image->image[row + dx[i]][col + dy[i]];
		G += color.G;
	}
	return G;
}

int CellB(Image * image, int row, int col) {
	int dx[8] = {-1, 1, -1, 1, -1, 1, 0, 0}; 
	int dy[8] = {0, 0, 1, 1, -1, -1, 1, -1};
	int B = 0;
	for(int i = 0; i < 8; i ++) {
		if(!check(row + dx[i], col + dy[i], image->cols, image->rows)) continue;
		Color color = image->image[row + dx[i]][col + dy[i]];
		B += color.B;
	}
	return B;
}
//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	Color *color = malloc(sizeof(Color));
	Color inital_color = image->image[row][col];
	if(inital_color.R || inital_color.B || inital_color.G) {
		if ((rule >> 9 >> aliveCell(image, row, col) )& 1) {
			color->R = inital_color.R;
			color->G = inital_color.G;
			color->B = inital_color.B;
		}
		else {
			color->R = 0; color->B = 0; color->G = 0;
		}
	}
	else {
		int dead_count = aliveCell(image, row, col);
		int r = CellR(image, row, col), g = CellG(image, row, col), b = CellB(image, row, col);
		if((rule >> dead_count) & 1) {
			color->R = (uint32_t)(r / dead_count);
			color->G = (uint32_t)(g / dead_count);
			color->B = (uint32_t)(b / dead_count);
		}
		else {
			color->R = 0; color->B = 0; color->G = 0;
		}
	}
	return color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	int rows = image->rows;
	int cols = image->cols;
	Image *newimage = malloc(sizeof(Image));
	newimage->cols = cols;
	newimage->rows = rows;
	Color **color_image = (Color **)malloc(sizeof(Color *) * rows); 
	for(int i = 0; i < image->rows; i ++) {
		color_image[i] = (Color*)malloc(sizeof(Color) * cols);
		for(int j = 0; j < image->cols; j ++){
			Color *color = evaluateOneCell(image, i, j, rule);
			color_image[i][j].R = color->R;
			color_image[i][j].G = color->G;
			color_image[i][j].B = color->B;
			free(color);
		}
	}
	newimage->image = color_image;
	return newimage;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/

void processCLI(int argc, char **argv, char **filename, char **rule) 
{
	if (argc != 3) {
		printf("usage: %s filename\n",argv[0]);
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
		exit(-1);
	}
	*filename = argv[1];
	*rule = argv[2];
}

uint32_t ut2rule(char *str) {
	uint32_t rule = 0;
	for(int i = 0; str[i] != '\0'; i ++) {
		if(i == 0 || i == 1) continue;
		int num = 0;
		if(str[i] <= '9' && str[i] >= '0') num = str[i] - '0';
		else if(str[i]>='A' && str[i] <= 'Z') num = str[i] - 'A' + 10;
		else num = str[i] - 'a' + 10;
		rule = rule * 16 + num;
	} 
	return rule;
}

int main(int argc, char **argv)
{
	uint32_t rule;
	char *filename;
	char *rule_s;
	processCLI(argc,argv,&filename, &rule_s);
	rule = ut2rule(rule_s);
	Image *src_image = readData(filename);
	Image *now_image = life(src_image, rule);
	writeData(now_image);

	freeImage(now_image);
	freeImage(src_image);
}
