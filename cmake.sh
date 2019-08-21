#!/bin/bash

while getopts ":c:s:p:b:a:n:l:f:t:o:e:m:r:w:g:u:" opt
do
    case $opt in
        c)
        echo "chip: $OPTARG"
        chip="$OPTARG"
        ;;
        s)
        echo "system: $OPTARG"
        system="$OPTARG"
        ;;
        p)
        echo "path: $OPTARG"
        path="$OPTARG"
        ;;
        b)
        echo "blas: $OPTARG"
        blas="$OPTARG"
        ;;
        a)
        echo "acl: $OPTARG"
        acl="$OPTARG"
        ;;
        n)
        echo "ndk: $OPTARG"
        ndk="$OPTARG"
        ;;
        l)
        echo "android_level: $OPTARG"
        android_level="$OPTARG"
        ;;
        f)
        echo "FP16: $OPTARG"
        FP16="$OPTARG"
        ;;
        t)
        echo "TFLIFE: $OPTARG"
        TFLIFE=$OPTARG
        ;;
        o)
        echo "ONNX: $OPTARG"
        ONNX=$OPTARG
        ;;
        e)
        echo "CAFFE: $OPTARG"
        CAFFE=$OPTARG
        ;;
        m)
        echo "MXNET: $OPTARG"
        MXNET=$OPTARG
        ;;
        r)
        echo "TF: $OPTARG"
        TF=$OPTARG
        ;;
        w)
        echo "FRAMEWORK: $OPTARG"
        FRAMEWORK=$OPTARG
        ;;
        g)
        echo "tengine: $OPTARG"
        tengine=$OPTARG
        ;;
        u)
        echo "protobuf: $OPTARG"
        protobuf=$OPTARG
        ;;
    esac
done


function change_android_path() {
    grep "android-ndk" -rl ${1} | xargs sed -i "s:/home/usr/android-ndk-r16b:/root/peter/android-ndk-${ndk}:g"
    if [[ ${FP16} = "true" ]]; then
	    grep "protobuf_lib" -rl ${1} | xargs sed -i "s:/home/usr/protobuf_lib:/root/peter/protobuf_r19:g"
    else
    	    grep "protobuf_lib" -rl ${1} | xargs sed -i "s:/home/usr/protobuf_lib:/root/peter/protobuf_lib:g"
    fi
    grep "jni" -rl ${1} | xargs sed -i "s:/home/usr/opencv/sdk/native/jni:/root/peter/opencv/sdk/native/jni:g"
    grep "Openblas0220" -rl ${1} | xargs sed -i "s:/home/usr/Openblas0220-android:/root/peter/Openblas0220-android:g"
    grep "ComputeLibrary" -rl ${1} | xargs sed -i "s:/home/usr/ComputeLibrary:/root/peter/ComputeLibrary:g"
}

function android_config() {
        if [[ -n "${path}"  ]]; then
           grep "/home/usr/tengine_model_test" -rl ${1} | xargs sed -i "s:/home/usr/tengine_model_test:${path}tengine_model_test:g"
        fi
        if [[ ${blas} = "true" ]]; then
            grep "BLAS_DIR" -rl ${1} | xargs sed -i "s:#export BLAS_DIR=/root/peter/Openblas0220-android:export BLAS_DIR=/root/peter/Openblas0220-android:g"
        fi
        if [[ ${acl} = "true" ]]; then
            grep "ACL_DIR" -rl ${1} | xargs sed -i "s:#export ACL_DIR=/root/peter/ComputeLibrary:export ACL_DIR=/root/peter/ComputeLibrary:g"
        fi
        if [[ -n "${android_level}"  ]]; then
           grep "DANDROID_PLATFORM" -rl ${1} | xargs sed -i "s:android-21:android-${android_level}:g"
        fi
        if [[ -n "${ndk}"  ]]; then
           grep "android-ndk" -rl ${1} | xargs sed -i "s:android-ndk-r16b:android-ndk-${ndk}:g"
        fi
}

function CMakeLists() {
        if [ ${tengine} != "true" ]; then
	        grep "option(TENGINE_TEST \"test tengine models\" ON)" -rl CMakeLists.txt  | xargs sed -i "s:option(TENGINE_TEST \"test tengine models\" ON):option(TENGINE_TEST \"test tengine models\" OFF):g"
        fi
        if [ ${TF} != "true" ]; then
	        grep "option(TF_TEST \"test tensforflow model\" ON)" -rl CMakeLists.txt  | xargs sed -i "s:option(TF_TEST \"test tensforflow model\" ON):option(TF_TEST \"test tensforflow model\" OFF):g"
        fi
        if [ ${CAFFE} != "true" ]; then
		grep "option(CAFFE_TEST \"test caffe model\" ON)" -rl CMakeLists.txt | xargs sed -i "s:option(CAFFE_TEST \"test caffe model\" ON):option(CAFFE_TEST \"test caffe model\" OFF):g"
        fi
        if [ ${TFLIFE} != "true" ]; then
		grep "option(TF_LITE_TEST \"test tf lite model\" ON)" -rl CMakeLists.txt  | xargs sed -i "s:option(TF_LITE_TEST \"test tf lite model\" ON):option(TF_LITE_TEST \"test tf lite model\" OFF):g"
        fi
        if [ ${MXNET} != "true" ]; then
		grep "option(MXNET_TEST \"test mxnet model\" ON)" -rl CMakeLists.txt  | xargs sed -i "s:option(MXNET_TEST \"test mxnet model\" ON):option(MXNET_TEST \"test mxnet model\" OFF):g"
        fi
        if [ ${ONNX} != "true" ]; then
		grep "option(ONNX_TEST \"test onnx model\" ON)" -rl CMakeLists.txt  | xargs sed -i "s:option(ONNX_TEST \"test onnx model\" ON):option(ONNX_TEST \"test onnx model\" OFF):g"
        fi
        if [ ${blas} != "true" ]; then
		grep "option(USE_BLAS \"use blas\" ON)" -rl CMakeLists.txt  | xargs sed -i "s:option(USE_BLAS \"use blas\" ON):option(USE_BLAS \"use blas\" OFF):g"
        fi
        if [ ${protobuf} != "true" ]; then
		grep "option(USE_PROTOBUF \"use protobuf \" ON)" -rl CMakeLists.txt | xargs sed -i "s:option(USE_PROTOBUF \"use protobuf \" ON):option(USE_PROTOBUF \"use protobuf\" OFF):g"
        fi
}

android_armv7="android_build_armv7.sh"
android_armv8="android_build_armv8.sh"
cmake="CMakeLists.txt"
#if [[ ${wrapper} = "false" ]]; then
#    grep "wrapper" -rl CMakeLists.txt | xargs sed -i "s:add_subdirectory(wrapper):#add_subdirectory(wrapper):g"
#fi

if [[ ${system} = "linux" ]]; then
    if [[ -n "${path}" ]]; then
        grep "/home/usr/tengine_model_test" -rl linux_build.sh | xargs sed -i "s:/home/usr/tengine_model_test:${path}tengine_model_test:g"
    fi
else
    if [[ ${chip} = "armv7" ]]; then
        change_android_path ${android_armv7}
        android_config ${android_armv7}
    else
        change_android_path ${android_armv8}
        android_config ${android_armv8}
    fi
fi
CMakeLists ${cmake}
