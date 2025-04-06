#include <QApplication>
#include <QDir>
#include <QStandardPaths>

#include <QCefContext.h>

#include "MainWindow.h"

int
main(int argc, char* argv[])
{
#if (QT_VERSION <= QT_VERSION_CHECK(6, 0, 0))
  // For off-screen rendering, Qt::AA_EnableHighDpiScaling must be enabled. If not,
  // then all devicePixelRatio methods will always return 1.0,
  // so CEF will not scale the web content
  // NOET: There is bugs in Qt 6.2.4, the HighDpi doesn't work
  QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
  QApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
#endif
#endif
  //#[Edit:JackLee]mingw build
  QString currentExePath=QDir::currentPath();
  // create QApplication instance
  QApplication a(argc, argv);

  // build QCefConfig
  QCefConfig config;
  config.setBrowserSubProcessPath(currentExePath+"/QCefViewTest.exe");
  // set user agent
  config.setUserAgent("QCefViewTest");
  // set log level
  config.setLogLevel(QCefConfig::LOGSEVERITY_DEFAULT);
  // set JSBridge object name (default value is CefViewClient)
  config.setRootCachePath(currentExePath + "/user");
  config.setCachePath(currentExePath + "/user");
  config.setBridgeObjectName("CallBridge");
  config.setBuiltinSchemeName("CefView");
  // 浏览器标识
  config.setUserAgent("Mozilla/5.0 (Windows NT 10.0; CEF/3.2272.2035) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 SoftwareInformer/1.6.1400");
  // 日志输出级别
  config.setLogLevel(QCefConfig::LOGSEVERITY_VERBOSE);
  // 无窗口渲染模式
  config.setWindowlessRenderingEnabled(false);
  // 远程Debug端口
  // config.setRemoteDebuggingPort(9000);
  // 请求头的语言
  config.setAcceptLanguageList("zh-CN");
  // 允许忽略 localhost 上的 TLS/SSL 错误
  config.addCommandLineSwitch("ignore-certificate-errors-spki-list");
  config.addCommandLineSwitch("ignore-ssl-errors");
  // 单进程模式
  // config.addCommandLineSwitch("single-process");
  // 启用GPU加速
  config.addCommandLineSwitch("enable-gpu");
  // GPU加速合成
  //config.addCommandLineSwitch("enable-gpu-compositing");
  // 在进程中使用GPU渲染-开启后只有一个进程
  //config.addCommandLineSwitch("in-process-gpu");
  // 无头模式
  // config.addCommandLineSwitch("headless");
  // chrome运行时环境
  config.addCommandLineSwitch("enable-chrome-runtime");
  config.addCommandLineSwitch("use-native");
  // 离屏渲染
  config.addCommandLineSwitch("off-screen-rendering-enabled");
  // 网络服务In进程
  //config.addCommandLineSwitchWithValue("enable-features", "NetworkServiceInProcess");
  // 语言
  config.addCommandLineSwitchWithValue("lang", "zh-CN");
  // 跨域进行远程
  // config.addCommandLineSwitchWithValue("remote-allow-origins", "*");

  //  禁用沙盒
  config.addCommandLineSwitchWithValue("no-sandbox", "ture");
  // 渲染进程限制
  config.addCommandLineSwitchWithValue("renderer-process-limit", "1");
  // 外部消息循环
  config.addCommandLineSwitchWithValue("external-message-pump", "false");
  // 多线程消息循环
  config.addCommandLineSwitchWithValue("multi-threaded-message-loop", "false");

  // create QCefContext instance with config,
  // the lifecycle of cefContext must be the same as QApplication instance
  QCefContext cefContext(&a, argc, argv, &config);

  // application window
  MainWindow w;
  w.show();

  // flying
  return a.exec();
}
