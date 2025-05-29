#!/bin/bash
BUILD_DIR="build"
mkdir -p $BUILD_DIR

apt-get update -y
apt-get install -y lcov  python3-pip

pip3 install gcovr -i   https://pypi.mirrors.ustc.edu.cn/simple/

MPI_HOME=/usr/local/mpi
make USE_NVIDIA=1 CFLAGS="--coverage" LDFLAGS="--coverage"

cd test/perf
make USE_NVIDIA=1 
mpirun --allow-run-as-root -np 1 ./test_alltoall -b 128M -e 1G -f 2 -p 1

#lcov --capture --directory . --output-file coverage.info
#genhtml coverage.info --output-directory coverage_html

#gcovr --xml-pretty --root .. --output coverage.xml


gcovr --xml-pretty --root ../.. --output ../../coverage.xml
