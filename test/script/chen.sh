#!/bin/bash
BUILD_DIR="build"

mkdir -p $BUILD_DIR

MPI_HOME=/usr/local/mpi 
make USE_NVIDIA=1

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

cd test/perf
make USE_NVIDIA=1

if [ $? -ne 0 ]; then
    echo "Test compilation failed!"
    exit 1
fi


mpirun --allow-run-as-root  -np 8   ./test_alltoall -b 128M -e 1G -f 2 -p 1
if [ $? -ne 0 ]; then
    echo "test_alltoall execution failed!"
    exit 1
fi


mpirun --allow-run-as-root  -np 8 ./test_allreduce -b 128M -e 1G -f 2 -p 1
if [ $? -ne 0 ]; then
    echo "test_allreduce execution failed!"
    exit 1
fi

echo "All tests completed successfully!"

