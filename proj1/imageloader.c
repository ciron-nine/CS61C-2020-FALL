/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	FILE *fp = fopen(filename, "r");
	char buf[3];
	int rows,cols;
	int maxisize;
	Image *image = malloc(sizeof(Image));
	fscanf(fp,"%s %d %d %d",buf, &cols, &rows, &maxisize);
	image->cols = cols;
	image->rows = rows;
	Color **color_image = (Color **)malloc(sizeof(Color *) * rows); 
	for(int i = 0; i < image->rows; i ++) {
		color_image[i] = (Color*)malloc(sizeof(Color) * cols);
		for(int j = 0; j < image->cols; j ++){
			uint8_t R,G,B;
			fscanf(fp,"%d %d %d",&R,&G,&B);
			color_image[i][j].R = R;
			color_image[i][j].G = G;
			color_image[i][j].B = B;
		}
		
	}
	image->image = color_image;
	fclose(fp);
	return image;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{	
	int rows = image->rows;
	int cols = image->cols;
	printf("P3\n");
	printf("%d %d\n", cols, rows);
	printf("255\n");
	for(int i = 0; i < rows; i ++){
		for(int j = 0; j < cols - 1; j ++) {
			Color color = image->image[i][j];
			printf("%3d %3d %3d", color.R, color.G, color.B);
			printf("   ");
		}
		Color color = image->image[i][cols - 1];
		printf("%3d %3d %3d", color.R, color.G, color.B);
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	int rows = image->rows;
	for(int i = 0; i < rows; i ++) {
		free(image->image[i]);
	}
	free(image->image);
	free(image);
	return;
}
