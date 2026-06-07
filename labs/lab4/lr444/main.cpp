#include <iostream>
#include <iomanip>
#include <clocale>
#include <limits>
#include <chrono>   // для замера времени
#include <windows.h> // для QueryPerformanceCounter (более точный)

using namespace std;
using namespace chrono;

extern "C" void CalculateValues(int n, float step, float* result);
extern "C" float ComputeFunction(float x);

int main()
{
    setlocale(LC_ALL, "Russian");
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);

    cout << "========================================" << endl;
    cout << "Вариант 19" << endl;
    cout << "Функция: f(x) = (tg(x) + sin(x)) / e^x" << endl;
    cout << "========================================" << endl << endl;

    const float step = 0.1f;
    const int MAX_N = 11;
    const float MAX_X = 1.0f;

    cout << "По заданию: интервал [0, " << MAX_X << "], шаг = " << step << endl;
    cout << "Максимальное количество точек: " << MAX_N << endl << endl;

    int n;

    cout << "Введите количество точек для вычисления (1 - " << MAX_N << "): ";
    cin >> n;

    if (n < 1) n = 1;
    if (n > MAX_N) n = MAX_N;

    const int ITERATIONS = 100000;  

    float* results_asm = new float[n];
    float* results_c = new float[n];

    auto start_asm = high_resolution_clock::now();

    for (int iter = 0; iter < ITERATIONS; iter++)
    {
        CalculateValues(n, step, results_asm);
    }

    auto end_asm = high_resolution_clock::now();
    auto duration_asm = duration_cast<microseconds>(end_asm - start_asm).count();

    auto start_c = high_resolution_clock::now();

    for (int iter = 0; iter < ITERATIONS; iter++)
    {
        for (int i = 0; i < n; i++)
        {
            float x = i * step;
            results_c[i] = ComputeFunction(x);
        }
    }

    auto end_c = high_resolution_clock::now();
    auto duration_c = duration_cast<microseconds>(end_c - start_c).count();

    cout << endl;
    cout << "РЕЗУЛЬТАТЫ ЗАМЕРОВ" << endl;
    cout << "Количество точек: " << n << endl;

    // Время на один вызов
    double per_call_asm = (double)duration_asm / (n * ITERATIONS);
    double per_call_c = (double)duration_c / (n * ITERATIONS);

    cout << "Время выполнения:" << endl;
    cout << "  Assembler: " << fixed << setprecision(3) << per_call_asm << " мкс" << endl;
    cout << "  C:         " << per_call_c << " мкс" << endl;

    cout << "----------------------------------------" << endl;
    cout << "   i   |    x    |   Assembler   |      C       " << endl;
    cout << "----------------------------------------" << endl;

    for (int i = 0; i < n; i++)
    {
        float x = i * step;
        cout << "   " << setw(2) << i << "   |  "
            << fixed << setprecision(1) << setw(4) << x << "   |   "
            << setprecision(6) << setw(11) << results_asm[i] << "   |   "
            << setw(11) << results_c[i] << endl;
    }
    cout << "----------------------------------------" << endl;

    // Очистка памяти
    delete[] results_asm;
    delete[] results_c;

    cout << endl << "Нажмите Enter для выхода...";
    cin.ignore();
    cin.get();

    return 0;
}