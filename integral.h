typedef double afunc(double);
double integral(afunc *op, double a, double b, double e);
double root(afunc *op1,afunc *op2, double a, double b, double e);
double f(afunc *op1,afunc *op2,double x);