#!/usr/bin/env bash
set -x
set -e

g++ \
-Isrc \
-I${RENODE_ROOT}/src/Plugins/SystemCPlugin/SystemCModule/include \
-I${RENODE_ROOT}/src/Plugins/SystemCPlugin/SystemCModule/lib \
${RENODE_ROOT}/src/Plugins/SystemCPlugin/SystemCModule/lib/socket-cpp/Socket/Socket.cpp \
${RENODE_ROOT}/src/Plugins/SystemCPlugin/SystemCModule/lib/socket-cpp/Socket/TCPClient.cpp \
${RENODE_ROOT}/src/Plugins/SystemCPlugin/SystemCModule/src/renode_bridge.cpp \
src/dbg_test.cpp \
src/main.cpp \
src/top.cpp \
-lsystemc \
-o dbg_exe
