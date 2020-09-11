 
FROM sxscollaboration/spectrebuildenv

ARG PARALLEL_MAKE_ARG=-j2

WORKDIR /work

RUN pip3 install matplotlib jupyterlab pandas

RUN git clone https://github.com/sxs-collaboration/spectre \
  && mkdir spectre/build && cd spectre/build \
  && cmake \
    -D CMAKE_C_COMPILER=clang-10 \
    -D CMAKE_CXX_COMPILER=clang++-10 \
    -D CMAKE_Fortran_COMPILER=gfortran-10 \
    -D CHARM_ROOT=/work/charm_6_10_2/multicore-linux-x86_64-clang \
    -D CMAKE_BUILD_TYPE=Release \
    -D DEBUG_SYMBOLS=OFF \
    -D BUILD_PYTHON_BINDINGS=ON \
    -D PYTHON_EXECUTABLE=/usr/bin/python3 \
    -D MEMORY_ALLOCATOR=SYSTEM \
    .. \
  && make $PARALLEL_MAKE_ARG all-pybindings \
  && pip3 install -e ./bin/python

ENV SPECTRE_HOME /work/spectre

ENV PATH $SPECTRE_HOME/build/bin:$PATH

WORKDIR /home
