#include <stdio.h>
#include <stdbool.h>
extern double f1(double a);
extern double f2(double a);
extern double f3(double a);
double root(double (*op1)(double), double (*op2)(double), double a, double b, double e) {
    double l = a,r=b,c,d,sdd, deltx;
    double k = e;
    bool game = true;
    for (; game;) {
        c = (l * ((op1(r) - op2(r))) - r * (op1(l) - op2(l))) / (((op1(r) - op2(r))) - (op1(l) - op2(l)));
        d = (op1(c + k) - op2(c + k)) - (op1(c) - op2(c)) / k;
        deltx = (l + r) / 2;
        sdd = (op1(deltx) - op2(deltx))- ((op1(l) - op2(l))+ (op1(r) - op2(r)))/2;
        if (sdd*d > 0) {
            l = c;
            if ((op1(c) - op2(c)) * ((op1(c + e) - op2(c + e))) <= 0) {
                game = false;
            }
        }
        else {
            r = c;
            if ((op1(c) - op2(c)) * ((op1(c - e) - op2(c - e))) <= 0) {
                game = false;
            }
        }
    }
    return c;
}

double integral(double (*op)(double), double a, double b, double e) {
    double l=a;
    double k = e;
    double ans = 0;
    ans=(op(a) + op(b))/2;
    l += k;
    for (; l < b; l+=k) {
        ans += op(l);
    }
    ans *= k;
    return ans;
}
