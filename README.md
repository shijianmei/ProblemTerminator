# ProblemTerminator

## Installation

ProblemTerminator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ProblemTerminator'
```
## Use
```
/// 配置
[JMHotFixManage shareInstance].kAES128Key = @"";
[JMHotFixManage shareInstance].kAES128Iv = @"";
[JMHotFixManage shareInstance].kHotUrl = @"";
[JMHotFixManage shareInstance].kExitHotUrl = @"";
/// 加载包
[[JMHotFixManage shareInstance] loadHotFix];

```
## 说明
基于 MangoFix 封装, 实现了拉修复包，缓存，修复等功能。
设计流程图:
![](https://raw.githubusercontent.com/shijianmei/blog_Images/main/%E7%83%AD%E4%BF%AE%E5%A4%8D%E8%AE%BE%E8%AE%A1/%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%97%B6%E5%BA%8F%E5%9B%BE.png)

基于补丁是从服务端拉取的,有一定的延时,为了不影响启动时间及代码修复,同时也为了减少每次冷启重复的请求，故加入缓存机制。


## License

ProblemTerminator is available under the MIT license. See the LICENSE file for more info.
