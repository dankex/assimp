#!/bin/sh

# Points to a standalone Android toolchain
# See https://developer.android.com/ndk/guides/standalone_toolchain.html
# and http://www.myandroidonline.com/2015/06/09/compile-assimp-open-source-library-for-android/
export ANDROID_NDK=$HOME/s/android-ndk-r10e

# Points to the Android SDK
export ANDROID_SDK=$HOME/work/software/sdk

# This file must be downloaded from the android-cmake project on github:
# https://github.com/taka-no-me/android-cmake](https://github.com/taka-no-me/android-cmake
export ANDTOOLCHAIN=$HOME/s/android-cmake/android.toolchain.cmake

# Do not touch these
export PATH=$PATH:$ANDROID_SDK/tools
export PATH=$PATH:$ANDROID_SDK/platform-tools
export PATH=$PATH:$ANDROID_SDK/android-toolchain/bin

# Two targets
# arm64-v8a
# armeabi-v7a with NEON

# Add additional args here as appropriate
cmake -DCMAKE_TOOLCHAIN_FILE=$ANDTOOLCHAIN \
      -DANDROID_NDK=$ANDROID_NDK \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="arm64-v8a" \
      -DANDROID_NATIVE_API_LEVEL=android-21 \
      -DANDROID_FORCE_ARM_BUILD=TRUE \
      -DCMAKE_INSTALL_PREFIX=install \
      ..

# This is to remove the versioned shared libs in assimp.
# Might be useful for other CMake-based projects, otherwise remove this line.
sed -i s/-soname,libassimp.so.3/-soname,libassimp.so/g code/CMakeFiles/assimp.dir/link.txt

make -j
make install
