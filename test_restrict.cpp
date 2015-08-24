#include <cstdlib>

#ifdef USE_RESTRICT
  #ifdef __INTEL_COMPILER
    #define RESTRICT __restrict
  #else
    #define RESTRICT __restrict__
  #endif
#else
  #define RESTRICT
#endif

struct Wrapper {
	double* RESTRICT a;
};

const int N = 1024;

__attribute__((noinline))
void
op(Wrapper a, Wrapper b, Wrapper c) {
	#ifdef __clang
	  #pragma clang loop vectorize(enable)
    #pragma clang loop interleave(enable)
	#else
	  #pragma omp simd
  #endif
	for (int i = 0; i < N; ++i) {
		c.a [i] += a.a[i] * b.a[i];
	}
}

int main() {
	Wrapper a, b, c;
	posix_memalign ((void**)&a.a, 64, N);
	posix_memalign ((void**)&b.a, 64, N);
	posix_memalign ((void**)&c.a, 64, N);

	op (a, b, c);

	free (a.a);
	free (b.a);
	free (c.a);

	exit (0);
}
