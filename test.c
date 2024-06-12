#include "integral.c"
#include <stdio.h>
#include <math.h>
double fun1(double x){
    return 1/x;
}
double fun2(double x){
    return x*x*x/(2*x+9);
}
int main(int argc, char* argv[]) {
    double a,b,e,ans;
    printf("intergal\n");
    a=1;
    b=4;
    e=1e-4;
    printf("\ttest1: fun1 a=%lf,b=%lf e=%lf result= ",a,b,e);
    ans=integral(fun1,a,b,e);
    printf("%lf equality=%s\n", ans,fabs(ans-1.38629436111989061883)<e?"Yes":"NO");
    a=1;
    b=4;
    e=1e-4;
    printf("\ttest2: fun2 a=%lf,b=%lf e=%lf result= ",a,b,e);
    ans=integral(fun2,a,b,e);
    printf("%lf equality=%s\n", ans,fabs(ans-4.1658203783144127574528)<e?"Yes":"NO");
    printf("root\n");
    a=-10;
    b=10;
    e=1e-7;
    printf("\ttest1: fun1 fun2 a=%lf,b=%lf e=%lf result= ",a,b,e);
    ans=root(fun1,fun2,a,b,e);
    printf("%lf equality=%s\n", ans,fabs(ans-1.890803347056341)<e?"Yes":"NO");

    return 0;
}