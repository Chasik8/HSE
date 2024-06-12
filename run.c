#include <stdio.h>
#include "integral.c"
extern double f1(double a);
extern double f2(double a);
extern double f3(double a);
int main(int argc, char* argv[]) {
	printf("%d",f1(2.0));
	return 0;
}