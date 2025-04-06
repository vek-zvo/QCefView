#
# The main config file for QCefView
#
cmake_minimum_required(VERSION 3.21)
project(QCefView)

set(CMAKE_FOLDER "QCefView")

# arguments:
# CEF_SDK_VERSION:
# - specify the CEF version to be used,
# - refer to: cmake\CefViewCoreConfig.cmake
#
# QT_SDK_DIR:
# - specify the Qt SDK path
# - refer to: cmake\QtConfig.cmake
#

#[Edit:JackLee]mingw build
# options
if(NOT DEFINED BUILD_ARGS_INPUT_MODE)
  SET(BUILD_ARGS_INPUT_MODE OFF CACHE BOOL "Build Args Input Mode")
endif()
if(NOT DEFINED BUILD_QCefView_DEMO)
  SET(BUILD_QCefView_DEMO OFF CACHE BOOL "Build the demo")
endif()
if(NOT DEFINED BUILD_LIBCEF_CEFSIMPL_DEMO)
  SET(BUILD_LIBCEF_CEFSIMPL_DEMO OFF CACHE BOOL "Build the libcef in test to cefsimpl demo")
endif()
if(NOT DEFINED BUILD_LIBCEF_CEFCLIENT_DEMO)
  SET(BUILD_LIBCEF_CEFCLIENT_DEMO OFF CACHE BOOL "Build the libcef in test to cefclient demo")
endif()
if(NOT DEFINED BUILD_STATIC)
  SET(BUILD_STATIC OFF CACHE BOOL "Build QCefView as static library")
endif()
if(NOT DEFINED STATIC_CRT)
  SET(STATIC_CRT OFF CACHE BOOL "Use MultiThreaded linkage for MSVC")
endif()
if(NOT DEFINED USE_SANDBOX)
  SET(USE_SANDBOX OFF CACHE BOOL "Enable CEF Sandbox")
endif()
if(NOT DEFINED USE_WIN_DCOMPOSITION)
  SET(USE_WIN_DCOMPOSITION OFF CACHE BOOL "Enabled Windows direct composition for hardware rendering, _WIN32_WINNT >= 0x602 (Windows 8) is required")
endif()
if(NOT DEFINED BUILD_COMPILER)
  SET(BUILD_COMPILER "MSVC" CACHE STRING "compiler")
endif()
#9.编译版本
if(NOT DEFINED CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE "Debug" CACHE STRING "build type")
endif()
# Only works for Windows & Linux, always enabled on macOS
# If enable then:
# CefSettings.multi_threaded_message_loop = false && CefSettings.external_message_pump = true
# else:
# CefSettings.multi_threaded_message_loop = true && CefSettings.external_message_pump = false
if(NOT DEFINED USE_QT_EVENT_LOOP)
  SET(USE_QT_EVENT_LOOP OFF CACHE BOOL "Enable the integration of CEF message loop thread into Qt event loop")
endif()
#11.support ATL
if(NOT DEFINED USE_ATL)
  SET(USE_ATL OFF CACHE BOOL "MSVC support ATL")
endif()
#12.support Mingw
if(NOT DEFINED BUILD_FIX_MINGW)
  SET(BUILD_FIX_MINGW ON CACHE BOOL "support Mingw")
endif()


#[Edit:JackLee]mingw build
if(BUILD_ARGS_INPUT_MODE)
   if(NOT DEFINED QT_SDK_DIR)
       MESSAGE(FATAL_ERROR "QT_SDK_DIR Not Set, use -DQT_SDK_DIR=/path/to/qt/cmake")
   endif()
else()#cmakelists set build args
   SET(QT_SDK_DIR "D:/Dev/Qt/6.8.0/mingw1310_static_x64/lib/cmake")
   if (!BUILD_FIX_MINGW)
      SET(BUILD_FIX_MINGW ON)
   endif()
   SET(BUILD_QCefView_DEMO ON)
   SET(BUILD_LIBCEF_CEFSIMPL_DEMO ON)
   SET(BUILD_LIBCEF_CEFCLIENT_DEMO ON)
   SET(BUILD_STATIC ON)
   SET(STATIC_CRT OFF)
   SET(USE_SANDBOX OFF)
   SET(USE_ATL OFF)
   SET(USE_WIN_DCOMPOSITION ON)
   SET(USE_QT_EVENT_LOOP ON)
   SET(CMAKE_BUILD_TYPE "Release")
   SET(BUILD_COMPILER "MINGW")
endif()
message(STATUS "----------build option state-------------")
message(STATUS "BUILD_ARGS_INPUT_MODE:" ${BUILD_ARGS_INPUT_MODE})
message(STATUS "QT_SDK_DIR:" ${QT_SDK_DIR})
message(STATUS "BUILD_FIX_MINGW:" ${BUILD_FIX_MINGW})
message(STATUS "BUILD_QCefView_DEMO:" ${BUILD_QCefView_DEMO})
message(STATUS "BUILD_LIBCEF_CEFSIMPL_DEMO:" ${BUILD_LIBCEF_CEFSIMPL_DEMO})
message(STATUS "BUILD_LIBCEF_CEFCLIENT_DEMO:" ${BUILD_LIBCEF_CEFCLIENT_DEMO})
message(STATUS "BUILD_STATIC:" ${BUILD_STATIC})
message(STATUS "STATIC_CRT:" ${STATIC_CRT})
message(STATUS "USE_SANDBOX:" ${USE_SANDBOX})
message(STATUS "USE_WIN_DCOMPOSITION:" ${USE_WIN_DCOMPOSITION})
message(STATUS "USE_QT_EVENT_LOOP:" ${USE_QT_EVENT_LOOP})
message(STATUS "CMAKE_BUILD_TYPE:" ${CMAKE_BUILD_TYPE})
message(STATUS "BUILD_COMPILER:" ${BUILD_COMPILER})
message(STATUS "-----------------------------------------")
# 禁用弃用警告
if ("${BUILD_COMPILER}" STREQUAL MSVC AND OS_WINDOWS) 
  add_definitions(-D_SILENCE_CXX17_RESULT_OF_DEPRECATION_WARNING=1)
else()
  add_compile_options(-Wno-deprecated-declarations)
endif()

# append cmake config module path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

#[Edit:JackLee]mingw build
# Only generate Debug and Release configuration types.
# set(CMAKE_CONFIGURATION_TYPES Debug Release)

# if(NOT CMAKE_BUILD_TYPE)
#   set(CMAKE_BUILD_TYPE "Debug")
# endif()

# Use folders in the resulting project files.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# C standard
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)

# C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

add_definitions(-D_SILENCE_CXX17_RESULT_OF_DEPRECATION_WARNING=1)

# Determine the project architecture.
if(NOT DEFINED PROJECT_ARCH)
  if(OS_WINDOWS AND "${CMAKE_GENERATOR_PLATFORM}" STREQUAL "arm64")
    set(PROJECT_ARCH "arm64")
  elseif(CMAKE_SIZEOF_VOID_P MATCHES 8)
    set(PROJECT_ARCH "x86_64")
  else()
    set(PROJECT_ARCH "x86")
  endif()
endif()

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
  set(OS_MACOS 1)
  set(OS_POSIX 1)
  add_definitions(
    -DOS_MACOS=1
    -DOS_POSIX=1
  )
  add_compile_options(
    "-g"
    "$<$<CONFIG:DEBUG>:-O0>"
    "$<$<CONFIG:RELEASE>:-O3>"
  )

  # Target architecture.
  if(PROJECT_ARCH STREQUAL "x86_64")
    set(CMAKE_OSX_ARCHITECTURES "x86_64")
  elseif(PROJECT_ARCH STREQUAL "arm64")
    set(CMAKE_OSX_ARCHITECTURES "arm64")
  else()
    set(CMAKE_OSX_ARCHITECTURES "i386")
  endif()
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  set(OS_LINUX 1)
  set(OS_POSIX 1)
  add_definitions(-DOS_LINUX=1 -DOS_POSIX=1)
  add_compile_options(
    "-g"
    "$<$<CONFIG:DEBUG>:-O0>"
    "$<$<CONFIG:RELEASE>:-O3>"
  )

  if(PROJECT_ARCH STREQUAL "x86_64")
    # x86 64-bit architecture.
    add_compile_options(-m64 -march=x86-64)
    add_link_options(-m64)
  elseif(PROJECT_ARCH STREQUAL "x86")
    # x86 32-bit architecture.
    add_compile_options(-m32)
    add_link_options(-m32)
  endif()
#[Edit:JackLee]mingw build
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  if("${BUILD_COMPILER}" STREQUAL MSVC)
      set(OS_WINDOWS 1)
      # Disable the sandbox on Windows, because the sandbox.lib is MT which is conflict with Qt
      set(USE_SANDBOX OFF CACHE BOOL "Disable sandbox on Windows" FORCE)
      add_definitions(
        -DOS_WINDOWS=1
        -D_WIN32_WINNT=0x601
      )
      if(USE_WIN_DCOMPOSITION)
         add_definitions(
           -DENABLE_WINDOWS_DIRECT_COMPOSITION=ON
         )
      endif()
    add_compile_options(
      /W3
      /WX
      /M$<IF:$<BOOL:${STATIC_CRT}>,T,D>$<$<CONFIG:Debug>:d>
    )
    add_link_options(/DEBUG)
  else()
    add_definitions(
      -DOS_WINDOWS=1
      -D_WIN32_WINNT=0x0A00
    )
    SET(OS_WINDOWS 1)
    SET(_WIN32_WINNT 0x0A00)
    if(USE_WIN_DCOMPOSITION)
      add_definitions(
        -DENABLE_WINDOWS_DIRECT_COMPOSITION=ON
      )
    endif()
  endif()
endif()

if(BUILD_STATIC)
  SET(QCEFVIEW_LIB_TYPE STATIC)
  SET(CMAKE_EXE_LINKER_FLAGS -static)
  add_definitions(-DQCEFVIEW_STATIC=1)
else()
  set(QCEFVIEW_LIB_TYPE SHARED)
endif()

# detect whether we are in sub folder
get_directory_property(QCefView_HAS_PARENT_DIRECTORY PARENT_DIRECTORY)

if(NOT QCefView_HAS_PARENT_DIRECTORY)
  message(STATUS "QCefView is not in subdirectory, put all output together")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/bin)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/bin)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/output/$<CONFIG>/lib)
endif()

# Config the QT package
# ##############################################################
set(QT_SDK_DIR "" CACHE PATH "Qt build toolchain path")
include(QtConfig)
set(Qt_VERSION ${Qt${QT_VERSION_MAJOR}Core_VERSION})

# ##############################################################
# thirdparty CefViewCore
add_subdirectory(thirdparty)

if(OS_MACOS)
  # detect minimum deployment target by Qt
  if(${Qt_VERSION} VERSION_GREATER_EQUAL 6.5)
    set(QT_MIN_DEPLOYMENT_TARGET 11.0)
  elseif(${Qt_VERSION} VERSION_GREATER_EQUAL 6.2)
    set(QT_MIN_DEPLOYMENT_TARGET 10.14)
  elseif(${Qt_VERSION} VERSION_GREATER_EQUAL 5.14)
    set(QT_MIN_DEPLOYMENT_TARGET 10.13)
  elseif(${Qt_VERSION} VERSION_GREATER_EQUAL 5.13)
    set(QT_MIN_DEPLOYMENT_TARGET 10.12)
  elseif(${Qt_VERSION} VERSION_GREATER_EQUAL 5.10)
    set(QT_MIN_DEPLOYMENT_TARGET 10.11)
  else()
    set(QT_MIN_DEPLOYMENT_TARGET 10.10)
  endif()

  # detect minimum deployment target by CEF
  # plese refer to: https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding.md
  if(${CEF_VERSION_MAJOR} VERSION_GREATER_EQUAL 117)
    set(CEF_MIN_DEPLOYMENT_TARGET 10.15)
  elseif(${CEF_VERSION_MAJOR} VERSION_GREATER_EQUAL 104)
    set(CEF_MIN_DEPLOYMENT_TARGET 10.13)
  else()
    set(CEF_MIN_DEPLOYMENT_TARGET 10.11)
  endif()

  # use the greater one as the minimum deployment target
  if(${QT_MIN_DEPLOYMENT_TARGET} VERSION_LESS ${CEF_MIN_DEPLOYMENT_TARGET})
    set(CMAKE_OSX_DEPLOYMENT_TARGET ${CEF_MIN_DEPLOYMENT_TARGET})
  else()
    set(CMAKE_OSX_DEPLOYMENT_TARGET ${QT_MIN_DEPLOYMENT_TARGET})
  endif()
endif()

# Config QCefView target
# ##############################################################
add_subdirectory(src)

# Config the Demo project
# ##############################################################
if(BUILD_QCefView_DEMO)
  add_subdirectory(example/QCefViewTest)
endif()

# ##############################################################
