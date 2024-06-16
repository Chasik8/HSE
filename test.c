#include "integral.h"
#include "test.h"
#include <stdio.h>
#include <math.h>
double fun1(double x){
    return 1/x;
}
double fun2(double x){
    return x*x*x/(2*x+9);
}
double funf1(double x){
    return pow(2,x)+1.0;
}
double funf3(double x){
    return (1-x)/3;
}
double funf2(double x){
    return x*x*x*x*x;
}
int main(int argc, char* argv[]) {
    double a,b,e,ans;
    printf("intergal\n");
    e=1e-1;
    double lime=1e-6;
    while (e>=lime) {
        a = 1;
        b = 4;
        printf("\ttest1: fun1 a=%lf,b=%lf e=%lf result= ", a, b, e);
        ans = integral(fun1, a, b, e);
        printf("%lf equality=%s\n", ans, fabs(ans - 1.38629436111989061883) < e ? "Yes" : "NO");
        e /= 10;
    }
    e=1e-1;
    while (e>=lime) {
        a = 1;
        b = 4;
        printf("\ttest2: fun2 a=%lf,b=%lf e=%lf result= ", a, b, e);
        ans = integral(fun2, a, b, e);
        printf("%lf equality=%s\n", ans, fabs(ans - 4.1658203783144127574528) < e ? "Yes" : "NO");
        e /= 10;
    }
    printf("-----------------------------------------------------------------------------------------\n");
    printf("root\n");
    e=1e-4;
    while (e>=lime) {
        a = 1;
        b = 10;
        printf("\ttest1: fun1 fun2 a=%lf,b=%lf e=%lf result= ", a, b, e);
        ans = root(fun1, fun2, a, b, e);
        printf("%lf equality=%s\n", ans, fabs(ans - 1.890803347056341) < e ? "Yes" : "NO");
        e /= 10;
    }
    e=1e-4;
    while (e>=lime) {
        a = -4;
        b = -1;
        printf("\ttest2: funf1 funf3 a=%lf,b=%lf e=%lf result= ", a, b, e);
        ans = root(funf1, funf3, a, b, e);
        printf("%lf equality=%s\n", ans, fabs(ans - -2.522223) < e ? "Yes" : "NO");
        e /= 10;
    }
    e=1e-4;
    while (e>=lime) {
        a = 1;
        b = 2;
        printf("\ttest3: funf1 funf2 a=%lf,b=%lf e=%lf result= ", a, b, e);
        ans = root(funf1, funf2, a, b, e);
        printf("%lf equality=%s\n", ans, fabs(ans - 1.279354) < e ? "Yes" : "NO");
        e /= 10;
    }
    return 0;
}