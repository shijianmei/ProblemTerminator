# ProblemTerminator

[![CI Status](https://img.shields.io/travis/jianmei/ProblemTerminator.svg?style=flat)](https://travis-ci.org/jianmei/ProblemTerminator)
[![Version](https://img.shields.io/cocoapods/v/ProblemTerminator.svg?style=flat)](https://cocoapods.org/pods/ProblemTerminator)
[![License](https://img.shields.io/cocoapods/l/ProblemTerminator.svg?style=flat)](https://cocoapods.org/pods/ProblemTerminator)
[![Platform](https://img.shields.io/cocoapods/p/ProblemTerminator.svg?style=flat)](https://cocoapods.org/pods/ProblemTerminator)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

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

## License

ProblemTerminator is available under the MIT license. See the LICENSE file for more info.
