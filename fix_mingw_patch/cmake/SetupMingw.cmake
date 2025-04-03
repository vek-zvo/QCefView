SET(FIX_MINGW_SRC_FILES 
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/thirdparty/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/src/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/example/QCefViewTest/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/src/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/cmake/SetupCef.cmake
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/cmake/cef_macros.cmake
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/cmake/cef_variables.cmake
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/cmake/FindCEF.cmake
    #Fix Src Bug
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/src/QCefSetting.cpp
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/src/win/details/render/hardware/DX11RenderBackend.cpp
    #Fix example Bug
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/example/QCefViewTest/main.cpp
    #Fix Libcef Test Bug
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/tests/cefclient/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/tests/cefsimple/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/tests/cefsimple/cefsimple_win.cc
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/tests/cefclient/cefclient_win.cc
    ${PROJECT_SOURCE_DIR}/fix_mingw_patch/build/_deps/cefviewcore-src/dep/cef_binary/tests/cefclient/browser/osr_d3d11_win.cc

)
SET(FIX_MINGW_FILES 
    ${PROJECT_SOURCE_DIR}/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/thirdparty/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/src/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/example/QCefViewTest/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/src/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/cmake/SetupCef.cmake
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/cmake/cef_macros.cmake
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/cmake/cef_variables.cmake
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/cmake/FindCEF.cmake
    #Fix Src Bug
    ${PROJECT_SOURCE_DIR}/src/QCefSetting.cpp
    ${PROJECT_SOURCE_DIR}/src/win/details/render/hardware/DX11RenderBackend.cpp
    #Fix example Bug
    ${PROJECT_SOURCE_DIR}/example/QCefViewTest/main.cpp
    #Fix Libcef Test Bug
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/tests/cefclient/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/tests/cefsimple/CMakeLists.txt
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/tests/cefsimple/cefsimple_win.cc
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/tests/cefclient/cefclient_win.cc
    ${PROJECT_SOURCE_DIR}/build/_deps/cefviewcore-src/dep/${CEF_SDK_PACKAGE_NAME}/tests/cefclient/browser/osr_d3d11_win.cc
)

# 检查源文件和目标文件列表长度是否一致
list(LENGTH FIX_MINGW_SRC_FILES SOURCE_LENGTH)
list(LENGTH FIX_MINGW_SRC_FILES TARGET_LENGTH)
if(NOT ${SOURCE_LENGTH} EQUAL ${TARGET_LENGTH})
    message(FATAL_ERROR "The number of source files and target files must be the same.")
endif()

# 遍历文件列表进行覆盖操作
math(EXPR MAX_INDEX "${SOURCE_LENGTH} - 1")
foreach(INDEX RANGE ${MAX_INDEX})
    list(GET FIX_MINGW_SRC_FILES ${INDEX} SOURCE_FILE)
    list(GET FIX_MINGW_FILES ${INDEX} TARGET_FILE)

    # 检查源文件是否存在
    if(NOT EXISTS ${SOURCE_FILE})
        message(FATAL_ERROR "Source CMakeLists.txt file does not exist: ${SOURCE_FILE}")
    endif()

    # 读取源文件内容
    file(READ ${SOURCE_FILE} SOURCE_CONTENT)

    # 将源文件内容写入目标文件，实现覆盖
    file(WRITE ${TARGET_FILE} "${SOURCE_CONTENT}")

    message(STATUS "Successfully overwritten ${TARGET_FILE} with ${SOURCE_FILE}")
endforeach()    





