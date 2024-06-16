#include <stdio.h>
#include <stdbool.h>
#include <Windows.h>
#include "integral.h"
typedef double afunc(double);
double f(afunc *op1,afunc *op2,double x){
    return op1(x)-op2(x);
}
double root(afunc *op1,afunc *op2, double a, double b, double e) {
    double l = a,r=b,c,d,sdd, deltx;
    double k = e/5;


    bool game = true;
    bool lim=true;
    double fr=f(op1,op2,r),fl=f(op1,op2,l);
    c = (l * fr - r * fl) / (fr - fl);
    double ck=c+k;
    d = (f(op1,op2,ck) - f(op1,op2,c)) / k;
    deltx = (l + r) / 2;
    sdd =(f(op1,op2,deltx))- (fl + fr)/2;
    if (sdd*d < 0) {
        l = c;
        lim=true;
        if (f(op1,op2,c) * f(op1,op2,c+e) <= 0) {
            game = false;
        }
    }
    else {
        r = c;
        lim=false;
        if (f(op1,op2,c) * f(op1,op2,c-e) <= 0) {
            game = false;
        }
    }
    for (; game;) {
        fr=f(op1,op2,r);
        fl=f(op1,op2,l);
        c = (l * fr - r * fl) / (fr - fl);
        ck=c+k;
        if (lim){
            l=c;
            if (f(op1,op2,c) * f(op1,op2,c+e) <= 0) {
                game = false;
            }
        }else{
            r=c;
            if (f(op1,op2,c) * f(op1,op2,c-e) <= 0) {
                game = false;
            }
        }
    }
    return c;
}

double integral(afunc *op, double a, double b, double e) {
    double l=a;
    double k = e/5;
    double ans = 0;
    ans=(op(a) + op(b))/2;
    l += k;
    for (; l < b; l+=k) {
        ans += op(l);
    }
    ans *= k;
    return ans;
}
