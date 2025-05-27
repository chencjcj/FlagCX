#!/bin/bash
BUILD_DIR="build"
mkdir -p $BUILD_DIR

MPI_HOME=/usr/local/mpi
make USE_NVIDIA=1 CFLAGS="--coverage" LDFLAGS="--coverage"

cd test/perf
make USE_NVIDIA=1 
mpirun --allow-run-as-root -np 8 ./test_alltoall -b 128M -e 1G -f 2 -p 1
mpirun --allow-run-as-root -np 8 ./test_allreduce -b 128M -e 1G -f 2 -p 1

lcov --capture --directory . --output-file coverage.info
genhtml coverage.info --output-directory coverage_html

gcovr --xml-pretty --root .. --output coverage.xml
