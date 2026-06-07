#include <math.h>

float ComputeFunction(float x)
{
    float tg_x = tanf(x);
    float sin_x = sinf(x);
    float exp_x = expf(x);
    float result = (tg_x + sin_x) / exp_x;
    return result;
}