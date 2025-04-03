**QCefView for Mingw**
编译环境:
Windows11
Msys2 UCRT Mingw
QT6.8.0 Static Library Linker

1-本项目对QCefView进行了静态编译
2-对libcef_dll_warpper进行静态编译和连接
3-默认采用命令方式输入编译参数和修改CmakeLists.txt文件内的设定两种方式编译
4-本修改仅仅只是在圆QCefView的CmakeLists.txt编译中进行了增量式修改,保留了原项目中其他平台和和MSVC的编译选项.
5-本项目可以编译QCefView的Demo和libcef_dll_warper的Demo并修复了对应的BUG.同时也是采用增量修改对Mingw编译的支持.

由于libcef的二进制库是动态下来和部署的,所以本项目会详细说明操作过程.
首先拉取原QCefView的项目.
git clone --depth 1 https://github.com/CefView/QCefView.git
这里可以采用命令行模式或者vscode自动配置.因为首次部署QCefView项目会拉取libcef二进制库
详细命令如下(命令配置,不推荐):
mkdir build
cd build
cmake ..
vscode配置:用vscode打开QCefView项目目录,并打开CMakeLists.txt文件进行保存即可自动部署.
等libcef二进制库部署完毕后,把下面的fix_mingw_patch目录和generate-win-mingw-x86_64.bat文件复制到QCefView目录下并运行generate-win-mingw-x86_64.bat(切记所有的修改都是不可逆的,请自行备份.)
运行完bat后,然后再次配置根据上面方法配置.cmake脚本会自动替换QCefView和libcef二进制库中编译文件.

部署libcef的版本号修改在fix_mingw_patch/thirdparty/CMakeLists.txt中.

本项目由于作者水平有限,方法很野,再加上libcef的二进制库是动态配置的,所以只能想到这个骚操作了.请谅解。

为什么不提交给原作者:还是那句话水平有限,修改后其他平台编译是否有影响不得而知.没脸去提交PR
