#!/bin/bash

export ROOT_DIR=/home/usr/tengine_model_test

export ANDROID_NDK=/home/usr/android-ndk-r16b
export PROTOBUF_DIR=/home/usr/protobuf_lib
export OpenCV_DIR=/home/usr/opencv/sdk/native/jni
#export BLAS_DIR=/home/usr/Openblas0220-android
#export ACL_DIR=/home/usr/ComputeLibrary

cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
     -DANDROID_ABI="armeabi-v7a" \
     -DANDROID_PLATFORM=android-21 \
     -DANDROID_STL=c++_shared \
     -DROOT_DIR=$ROOT_DIR \
     -DOpenCV_DIR=$OpenCV_DIR \
     -DPROTOBUF_DIR=$PROTOBUF_DIR \
     -DBLAS_DIR=$BLAS_DIR \
     -DACL_DIR=$ACL_DIR \
     ..

