cmake_minimum_required(VERSION 3.10)
project(LuaSocket C)

# ------------------------------------------------------------------------------
# 用户可通过 cmake -D... 覆盖下面的默认设置
# ------------------------------------------------------------------------------
# Lua 头文件目录和链接库路径（默认基于 Lua 5.4）
set(LUA_INCLUDE_DIR "/opt/lua54/include" CACHE PATH "Lua include directory")
set(LUA_LIBRARY "/opt/lua54/lib/liblua.a" CACHE FILEPATH "Lua library path")
set(LUAV "5.4" CACHE STRING "Lua version")

# 是否开启调试模式（默认关闭）
option(USE_DEBUG "Enable debug mode" OFF)
if(USE_DEBUG)
  set(DEBUG_DEFINE LUASOCKET_DEBUG)
else()
  set(DEBUG_DEFINE LUASOCKET_NODEBUG)
endif()

# 公共编译选项（Linux下）
set(COMMON_COMPILE_OPTIONS -Wall -Wshadow -Wextra -Wimplicit -O2 -ggdb3 -fpic)

# ------------------------------------------------------------------------------
# 自动搜索 src 下所有 C 和 H 文件（便于在 IDE 中分组显示）
# ------------------------------------------------------------------------------
file(GLOB_RECURSE ALL_SOURCE_FILES "${PROJECT_SOURCE_DIR}/src/*.c")
file(GLOB_RECURSE ALL_HEADER_FILES "${PROJECT_SOURCE_DIR}/src/*.h")

foreach(source IN LISTS ALL_SOURCE_FILES)
    get_filename_component(source_path "${source}" PATH)
    file(RELATIVE_PATH source_path_rel "${PROJECT_SOURCE_DIR}" "${source_path}")
    string(REPLACE "/" "\\" source_path_rel_win "${source_path_rel}")
    source_group("Source Files\\${source_path_rel_win}" FILES "${source}")
endforeach()

foreach(header IN LISTS ALL_HEADER_FILES)
    get_filename_component(header_path "${header}" PATH)
    file(RELATIVE_PATH header_path_rel "${PROJECT_SOURCE_DIR}" "${header_path}")
    string(REPLACE "/" "\\" header_path_rel_win "${header_path_rel}")
    source_group("Header Files\\${header_path_rel_win}" FILES "${header}")
endforeach()

# ------------------------------------------------------------------------------
# 定义各模块的源文件列表（路径均以 src/ 为前缀）
# ------------------------------------------------------------------------------
# socket 模块（原 Makefile 中生成 socket-3.1.0.so）
set(SOCKET_SOURCES
  src/luasocket.c
  src/timeout.c
  src/buffer.c
  src/io.c
  src/auxiliar.c
  src/compat.c
  src/options.c
  src/inet.c
  src/usocket.c   # 原 Makefile 中 SOCKET 对应 usocket.c
  src/except.c
  src/select.c
  src/tcp.c
  src/udp.c
)

# mime 模块（对应 mime-1.0.3.so）
set(MIME_SOURCES
  src/mime.c
  src/compat.c
)

# unix 模块（仅 Unix/Linux 有效）
set(UNIX_SOURCES
  src/buffer.c
  src/auxiliar.c
  src/options.c
  src/timeout.c
  src/io.c
  src/usocket.c
  src/unixstream.c
  src/unixdgram.c
  src/compat.c
  src/unix.c
)

# serial 模块（仅 Unix/Linux 有效）
set(SERIAL_SOURCES
  src/buffer.c
  src/compat.c
  src/auxiliar.c
  src/options.c
  src/timeout.c
  src/io.c
  src/usocket.c
  src/serial.c
)

# ------------------------------------------------------------------------------
# 定义构建各个共享库 target（输出文件名不带版本号）
# ------------------------------------------------------------------------------
# socket 模块 target
add_library(socket SHARED ${SOCKET_SOURCES})
set_target_properties(socket PROPERTIES PREFIX "" OUTPUT_NAME "socket" SUFFIX ".so")
target_include_directories(socket PRIVATE ${LUA_INCLUDE_DIR})
target_compile_options(socket PRIVATE ${COMMON_COMPILE_OPTIONS})
target_compile_definitions(socket PRIVATE ${DEBUG_DEFINE})
target_link_libraries(socket PRIVATE ${LUA_LIBRARY})

# mime 模块 target
add_library(mime SHARED ${MIME_SOURCES})
set_target_properties(mime PROPERTIES PREFIX "" OUTPUT_NAME "mime" SUFFIX ".so")
target_include_directories(mime PRIVATE ${LUA_INCLUDE_DIR})
target_compile_options(mime PRIVATE ${COMMON_COMPILE_OPTIONS})
target_compile_definitions(mime PRIVATE ${DEBUG_DEFINE})
target_link_libraries(mime PRIVATE ${LUA_LIBRARY})

# unix 模块 target
add_library(unix SHARED ${UNIX_SOURCES})
set_target_properties(unix PROPERTIES PREFIX "" OUTPUT_NAME "unix" SUFFIX ".so")
target_include_directories(unix PRIVATE ${LUA_INCLUDE_DIR})
target_compile_options(unix PRIVATE ${COMMON_COMPILE_OPTIONS})
target_compile_definitions(unix PRIVATE ${DEBUG_DEFINE})
target_link_libraries(unix PRIVATE ${LUA_LIBRARY})

# serial 模块 target
add_library(serial SHARED ${SERIAL_SOURCES})
set_target_properties(serial PROPERTIES PREFIX "" OUTPUT_NAME "serial" SUFFIX ".so")
target_include_directories(serial PRIVATE ${LUA_INCLUDE_DIR})
target_compile_options(serial PRIVATE ${COMMON_COMPILE_OPTIONS})
target_compile_definitions(serial PRIVATE ${DEBUG_DEFINE})
target_link_libraries(serial PRIVATE ${LUA_LIBRARY})
