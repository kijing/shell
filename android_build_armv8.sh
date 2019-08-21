#!/bin/bash

export ROOT_DIR=/root/peter/autoTest/sj/tengine_model_test

export ANDROID_NDK=/root/peter/android-ndk-r19c
export PROTOBUF_DIR=/root/peter/protobuf_r19
export OpenCV_DIR=/root/peter/opencv/sdk/native/jni
export BLAS_DIR=/root/peter/Openblas0220-android
export ACL_DIR=/root/peter/ComputeLibrary

cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
     -DANDROID_ABI="arm64-v8a" \
     -DANDROID_PLATFORM=android-21 \
     -DANDROID_STL=c++_shared \
     -DROOT_DIR=$ROOT_DIR \
     -DOpenCV_DIR=$OpenCV_DIR \
     -DPROTOBUF_DIR=$PROTOBUF_DIR \
     -DBLAS_DIR=$BLAS_DIR \
     -DACL_DIR=$ACL_DIR \
     ..

