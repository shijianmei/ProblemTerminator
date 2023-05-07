//
//  JMHotFixManage.h
//  AWMangoFix
//
//  Created by jianmei on 2023/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMHotFixManage : NSObject

/// 秘钥
@property (nonatomic, copy) NSString *kAES128Key;
/// 秘钥
@property (nonatomic, copy) NSString *kAES128Iv;

/// 获取最新有效的热修复包接口
@property (nonatomic, copy) NSString *kHotUrl;

/// 获取是否存在最新热修复包的接口
@property (nonatomic, copy) NSString *kExitHotUrl;

+ (instancetype)shareInstance;

/**
 热修复步骤
 1、先通过本地方式修复
 2、将修复的代码转换成 patch 脚本
 3、导出热修复加密流到桌面，如文件名为：hotfix.mg
 3、通过后台管理系统将导出的修复包上传
 */
- (void)loadHotFix;

@end

NS_ASSUME_NONNULL_END
