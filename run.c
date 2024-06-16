#include <stdio.h>
#include "integral.h"
extern double f1(double a);
extern double f2(double a);
extern double f3(double a);
int main(int argc, char* argv[]) {
    double e=1e-4;
    double f1_f3= root(f1,f3,-3.0,-1.0,e);
    double f1_f2= root(f1,f2,1,3,e);
    double f2_f3= root(f3,f2,0,2,e);
    double ans= integral(f1,f1_f3,f1_f2,e);
    double ans2= integral(f3,f1_f3,f2_f3,e);
    double ans3= integral(f2,f2_f3,f1_f2,e);
    printf("%lf\n",ans-ans2-ans3);
	return 0;
}