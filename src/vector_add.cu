#include <stdio.h>
#include <cuda_runtime.h>

__global__ void vectorAdd(int *A, int *B, int *C, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < n) {
        C[i] = A[i] + B[i];
    }
}

int main() {
    int n = 4;
    int A[] = {1, 2, 3, 4};
    int B[] = {10, 20, 30, 40};
    int C[4];

    int *d_A, *d_B, *d_C;

    cudaMalloc(&d_A, n * sizeof(int));
    cudaMalloc(&d_B, n * sizeof(int));
    cudaMalloc(&d_C, n * sizeof(int));

    cudaMemcpy(d_A, A, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, n * sizeof(int), cudaMemcpyHostToDevice);

    vectorAdd<<<1, 4>>>(d_A, d_B, d_C, n);
    cudaDeviceSynchronize();

    cudaMemcpy(C, d_C, n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Result: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", C[i]);
    }
    printf("\n");

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}
