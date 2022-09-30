
/* Genera numeros en el rango [20, 70) */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <stdbool.h>

#define LOWER_BOUND 20
#define UPPER_BOUND 70
#define M (1/50)

double f(int x){
    return 1/50;
}

int main(int argc, char* argv[])
{
    clock_t begin = clock();

    int xi;
    double yi;
    unsigned long long n = atoll(argv[1]);

    int rango = UPPER_BOUND - LOWER_BOUND;
    unsigned long long frecuencia[rango];
    for(int i = 0; i < rango; i++){
        frecuencia[i] = 0;
    }
    
    srand(time(NULL));
    for (unsigned long long i = 0; i < n; i++)
    {
        /*
        como rand es uniforme, justo en este caso
        para que tarde menos tiempo omito los controles de rechazo
        me ahorro un salto en while y un llamado a rand
        es un monton
        */

        //do
        //{
            double r1 = (double)rand() / RAND_MAX;
        //    double r2 = (double)rand() / RAND_MAX;
            xi = LOWER_BOUND + rango * r1;
        //    yi = M * r2;
        //} while (yi > f(xi));

        frecuencia[xi - LOWER_BOUND]++;
    }

    /* sum of frequencies */
    unsigned long long sum = 0;
    for (int i = 0; i < rango; i++)
    {
        sum += frecuencia[i];
    }

    int no_generados = 0;
    printf("numero | frecuencia       | porcentaje\n");
    printf("--------------------------------------\n");
    for (int i = 0; i < rango; i++)
    {   
        long double porcentaje = (long double)frecuencia[i] / (long double)sum;
        if (frecuencia[i] != 0)
        {
            printf("%-6d | %-16lld | %Lf\n", i + LOWER_BOUND, frecuencia[i], porcentaje);
        }
        else
        {
            no_generados++;
            printf("%-6d | NO GENERADO      | -\n", i + LOWER_BOUND);
        }
    }
    printf("\nNo generados: %d\n", no_generados);

    bool es_uniforme = true;
    for (int i = 1; i < rango; i++)
    {
        if(frecuencia[i] != frecuencia[i-1])
        {
            es_uniforme = false;
            break;
        }
    }

    unsigned long long min = frecuencia[0];
    unsigned long long max = frecuencia[0];
    for (int i = 1; i < rango; i++)
    {
        if(frecuencia[i] < min)
        {
            min = frecuencia[i];
        }

        if(frecuencia[i] > max)
        {
            max = frecuencia[i];
        }
    }

    unsigned long long medio = (max + min) / 2;

    printf("\nError relativo: %Lf\n", (long double)(max - medio) / (long double)medio);

    if (es_uniforme)
    {
        printf("La distribucion es uniforme\n");
    }
    else
    {
        printf("La distribucion NO es uniforme\n");
    }

    clock_t end = clock();
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

    printf("\nTiempo de ejecucion: %fs\n", time_spent);

    return 0;
}
