#include <stdio.h>
#include "integral.h"
#include <getopt.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
extern double f1(double a);
extern double f2(double a);
extern double f3(double a);
int main(int argc, char* argv[]) {
    int command_len=1;
    double e=1e-4;
    double f1_f3= root(f1,f3,-3.0,-1.0,e);
    double f1_f2= root(f1,f2,1,3,e);
    double f2_f3= root(f3,f2,0,2,e);
    double ans= integral(f1,f1_f3,f1_f2,e);
    double ans2= integral(f3,f1_f3,f2_f3,e);
    double ans3= integral(f2,f2_f3,f1_f2,e);
    struct option command[] = {
            [0] = { .name = "help", .has_arg=0, .flag=0, .val='h'},
            [1] = { .name = "root", .has_arg=0, .flag=0, .val='r'},
            [2] = { .name = "iterations", .has_arg=0, .flag=0, .val='i'},
            [3] = { .name = "test-root", .has_arg=1, .flag=0, .val='R'},
            [4] = { .name = "test-integral", .has_arg=1, .flag=0, .val='I'},
    };
    int i;
    char *token;
    int f_n1=0,f_n2=0;
    double a=1.0,b=1.0,r=1.0,root_ans=1.0;
    while((i= getopt_long(argc,argv,"hrR:I:i",command,NULL))!=-1){
        switch ((char)i) {
            case 'h':
                for (int j=0;j<command_len;++j){
                    printf("--%s -%c\n", command[j].name, command[j].val);
                }
                break;
            case 'r':
                printf("%lf %lf %lf\n", f1_f3, f1_f2, f2_f3);
                break;
            case 'i':
                printf("%i %i %i\n", 29, 85, 184);
                break;
            case 'R':
                printf("%s\n",optarg);
                token = strtok(optarg, ":");
                f_n1=atoi(token);
                token = strtok(NULL, ":");
                f_n2=atoi(token);
                token = strtok(NULL, ":");
                a=atof(token);
                token = strtok(NULL, ":");
                b=atof(token);
                token = strtok(NULL, ":");
                e=atof(token);
                token = strtok(NULL, ":");
                r=atof(token);
                root_ans=1.0;
                if (f_n1==1 && f_n2==2) {
                    root_ans=root(f1,f2,a,b,e);
                }
                else if (f_n1==3 && f_n2==2){
                    root_ans=root(f2,f3,a,b,e);
                }
                else if (f_n1==1 && f_n2==3){
                    root_ans=root(f1,f3,a,b,e);
                }
                printf("%lf %lf %lf\n",root_ans, fabs(r-root_ans),fabs(r-root_ans)/fabs(root_ans));
                break;
            case 'I':
                token = strtok(optarg, ":");
                f_n1=atoi(token);
                token = strtok(NULL, ":");
                a=atof(token);
                token = strtok(NULL, ":");
                b=atof(token);
                token = strtok(NULL, ":");
                e=atof(token);
                token = strtok(NULL, ":");
                r=atof(token);
                root_ans=1.0;
                if (f_n1==1) {
                    root_ans=integral(f1,a,b,e);
                }
                else if (f_n1==2){
                    root_ans=integral(f2,a,b,e);
                }
                else if (f_n1==3){
                    root_ans=integral(f3,a,b,e);
                }
                printf("%lf %lf %lf\n",root_ans, fabs(r-root_ans),fabs(r-root_ans)/fabs(root_ans));
                break;
            default:
                break;
        }
    }
    printf("%lf\n",ans-ans2-ans3);
    return 0;
}