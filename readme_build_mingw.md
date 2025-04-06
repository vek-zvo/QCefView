<p><strong>QCefView for Mingw</strong><br />
编译环境:<br />
Windows11<br />
Msys2 UCRT Mingw<br />
QT6.8.0 Static Library Linker</p>
<p>1-本项目对QCefView进行了静态编译<br />
2-对libcef_dll_warpper进行静态编译和连接<br />
3-默认采用命令方式输入编译参数和修改CmakeLists.txt文件内的设定两种方式编译<br />
4-本修改仅仅只是在圆QCefView的CmakeLists.txt编译中进行了增量式修改,保留了原项目中其他平台和和MSVC的编译选项.<br />
5-本项目可以编译QCefView的Demo和libcef_dll_warper的Demo并修复了对应的BUG.同时也是采用增量修改对Mingw编译的支持.</p>
<p>由于libcef的二进制库是动态下来和部署的,所以本项目会详细说明操作过程.<br />
首先拉取原QCefView的项目.<br />
git clone --depth 1 https://github.com/CefView/QCefView.git<br />
这里可以采用命令行模式或者vscode自动配置.因为首次部署QCefView项目会拉取libcef二进制库<br />
详细命令如下(命令配置,不推荐):<br />
mkdir build<br />
cd build<br />
cmake …<br />
vscode配置:用vscode打开QCefView项目目录,并打开CMakeLists.txt文件进行保存即可自动部署.<br />
等libcef二进制库部署完毕后,把下面的fix_mingw_patch目录和generate-win-mingw-x86_64.bat文件复制到QCefView目录下并运行generate-win-mingw-x86_64.bat(切记所有的修改都是不可逆的,请自行备份.)<br />
运行完bat后,然后再次配置根据上面方法配置.cmake脚本会自动替换QCefView和libcef二进制库中编译文件.</p>
<p>部署libcef的版本号修改在fix_mingw_patch/thirdparty/CMakeLists.txt中.</p>
<p>本项目由于作者水平有限,方法很野,再加上libcef的二进制库是动态配置的,所以只能想到这个骚操作了.请谅解。</p>
<p>为什么不提交给原作者:还是那句话水平有限,修改后其他平台编译是否有影响不得而知.没脸去提交PR</p>
<P>切换libcef二进制库版本后,需要手动删除build目录下CMakeCache.txt文件重新配置

2024-4-6 <br />
1-固定cef_binray版本号为set(CEF_SDK_VERSION "133.0.0+g2197e2d+chromium-133.0.6886.0") # GOOD Support MP3 MP4 AAC Play<br />
2-其他cef二进制库版本请自行修改,大致存在不同在demo的文件中,也就是tests/cefclient/CMakelists.txt中<br />
3-固定cef_binray版本目的不想过快更新版本导致兼容性问题<133版本存在js脚本执行溢出BUG,所以固定版本为133+<br />
4-本次提供cef_binray二进制库,放在cef_binary中,请自行配合fix_mingw_pacth中thirdparty或者thirdparty中的CMakeLists.txt版本修改使用<br />

