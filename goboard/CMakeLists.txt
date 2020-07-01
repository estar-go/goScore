cmake_minimum_required(VERSION 0.0.1)
project(goboard)

set(CMAKE_CXX_STANDARD 14)

if(APPLE)
    include_directories(/usr/local/include/boost/)
    include_directories(/usr/local/include)
    link_directories(/usr/local/lib)
endif()

if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColorReset   "${Esc}[m")
    set(ColorBold    "${Esc}[1m")
    set(ColorRed     "${Esc}[31m")
    set(ColorBoldRed "${ColorRed}${ColorBold}")
endif()

add_executable(goboard
        main.cpp
        board.cpp
        boardhistory.cpp
        rules.cpp
        sgf.cpp
        utils/global.cpp
        utils/hash.cpp
        utils/rand_helpers.cpp
        utils/rand.cpp
        utils/sha2.cpp
        utils/test.cpp
        utils/timer.cpp
        utils/md5.cpp
        utils/bsearch.cpp
        )

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -g -O2 -Wall -lboost_filesystem -lboost_system")

target_include_directories(goboard PUBLIC ${CMAKE_CURRENT_BINARY_DIR})