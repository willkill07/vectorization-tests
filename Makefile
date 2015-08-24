GCC := g++
ICC := icpc
CLANG := clang++

CXXFLAGS := -O3

GCCFLAGS := -march=native -fopenmp
CLANGFLAGS := -march=native
ICCFLAGS := -xHOST -openmp

.PHONY: all test-icc test-gcc test-clang clean

all: test-icc test-gcc test-clang

test-icc:
	@$(ICC) $(CXXFLAGS) $(ICCFLAGS) -S -o icc_test_norestrict.s test_restrict.cpp
	@$(ICC) $(CXXFLAGS) $(ICCFLAGS) -DUSE_RESTRICT -S -o icc_test_restrict.s test_restrict.cpp
	@echo "Files stored: icc_test_norestrict.s and icc_test_restrict.s"
	@echo "$(diff -q icc_test_*)"

test-gcc:
	@$(GCC) $(CXXFLAGS) $(GCCFLAGS) -S -o gcc_test_norestrict.s test_restrict.cpp
	@$(GCC) $(CXXFLAGS) $(GCCFLAGS) -DUSE_RESTRICT -S -o gcc_test_restrict.s test_restrict.cpp
	@echo "Files stored: gcc_test_norestrict.s and gcc_test_restrict.s"
	@echo "$(diff -q gcc_test_*)"

test-clang:
	@$(CLANG) $(CXXFLAGS) $(CLANGFLAGS) -S -o clang_test_norestrict.s test_restrict.cpp
	@$(CLANG) $(CXXFLAGS) $(CLANGFLAGS) -DUSE_RESTRICT -S -o clang_test_restrict.s test_restrict.cpp
	@echo "Files stored: clang_test_norestrict.s and clang_test_restrict.s"
	@echo "$(diff -q clang_test_*)"

clean:
	@rm -vf *.s
