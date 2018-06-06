# serverchan_flutter_demo

效果：
![这里写图片描述](https://github.com/zhanglihow/serverchan_flutter_demo/blob/master/pic/demo.gif)

server酱：[http://sc.ftqq.com/3.version](http://sc.ftqq.com/3.version)  
Server酱 设计的非常简单，你只需要用 Github 账号登录，然后绑定微信同时关注公众号，就可以通过 Http 服务，向绑定的微信号发送通知消息。

发送消息非常简单，只需要向以下URL发一个GET或者POST请求：
```
https://sc.ftqq.com/[SCKEY].send
```
接受两个参数：
text：消息标题，最长为256，必填。
desp：消息内容，最长64Kb，可空，支持MarkDown。

用Flutter写了这样一个Demo，就当熟悉下Flutter吧。
使用到了 Flutter 的 Url跳转，Http请求，数据本地持久化SharedPreferences，及一些基础控件。
代码：[https://github.com/zhanglihow/serverchan_flutter_demo](https://github.com/zhanglihow/serverchan_flutter_demo)

  
    
    
参考：
[Flutter交互控件](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)
[Flutter 网络操作](http://flutter.link/2018/04/16/%E7%BD%91%E7%BB%9C%E6%93%8D%E4%BD%9C/)
[Flutter 本地存储](http://flutter.link/2018/04/13/Flutter%E4%B8%AD%E7%9A%84%E6%9C%AC%E5%9C%B0%E5%AD%98%E5%82%A8/)

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
