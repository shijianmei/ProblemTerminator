//
//  JMHotFixManage.m
//  AWMangoFix
//
//  Created by jianmei on 2023/2/24.
//

#import "JMHotFixManage.h"
#import <MangoFix/MangoFix.h>
#import <MangoFix/NSData+AESEncryption.h>

#define kPatchIdDictKey @"kPatchIdDictKey"

@interface JMHotFixManage ()
@property (nonatomic, strong) MFContext *context;

@end

@implementation JMHotFixManage

+ (instancetype)shareInstance {
    static JMHotFixManage *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [JMHotFixManage new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kAES128Key = @"123456";
        _kAES128Iv = @"abcdef";        
    }
    return self;
}

#pragma mark - hot Fix

- (void)loadHotFix {
    
    @try {
        //从缓存加载patch，如果存在
        [self evalLastPatchIfExit];
    }
    @catch (NSException *exception) {
        NSLog(@"mango_pare_error:%@", exception);
        [self deleteLocalMangoScript];
    }
    @finally {
        //从网络加载,如果缓存已经存在patch，则解析这个patch，
        [self getHotFixFromNetworkIfExit];
    }
            
    //从本地加载 以验证脚本是否有效
//    [self loadHotFixFromLocal];
    
}


/// 解析缓存中的补丁包，如果存在
- (void)evalLastPatchIfExit {
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    
    NSString *filePath = [[self cachesPath] stringByAppendingPathComponent:@"demo.mg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *scriptData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        if (scriptData && scriptData.length > 0) {
            [self.context evalMangoScriptWithAES128Data:scriptData];
            CFTimeInterval end = CFAbsoluteTimeGetCurrent();
            NSLog(@"evalLastPatchIfNeed_cost%f", (end - begin) * 1000);
        }
    }
}

/// 删除缓存中的补丁包
- (void)deleteLocalMangoScript {
    NSError *error = nil;
    NSString *filePath = [[self cachesPath] stringByAppendingPathComponent:@"demo.mg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        NSLog(@"The local patch was successfully deleted! Please restart app!");
    }
}

- (void)userDefaultsSave:(NSString*)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getPatchIdFromLocal {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPatchIdDictKey];
    NSString *patchId = [[dict valueForKey:[self appVertion]] stringValue];
    return patchId;
}

/// 请求服务端是否存在最新的patch
- (void)getHotFixFromNetworkIfExit {
    if (self.kExitHotUrl.length == 0) {
        NSLog(@"kExitHotUrl must be defined");
        return;
    }
    NSString *urlStr = self.kExitHotUrl;
    NSString *patchId = [self getPatchIdFromLocal];
    
    if ([self appVertion].length > 0) {
        urlStr = [NSString stringWithFormat:@"%@?version=%@",self.kExitHotUrl,[self appVertion]];
        if (patchId.length > 0) {
            // 请求是否存在最新的patch，存在则拉取最新的
            urlStr = [NSString stringWithFormat:@"%@&patch=%@",urlStr, patchId];
        } else {
          //直接获取最新patch
            [self requestHotFixFromNetwork];
            //也要继续请求，为了保存：vertion:patchid
        }
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
       cachePolicy:NSURLRequestUseProtocolCachePolicy
       timeoutInterval:5.0];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
        
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
       if (error) {
          NSLog(@"loadHotfix_exit_%@", error);
       } else {
           if (data) {
               NSError *parseError = nil;
               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
               if ([responseDictionary[@"exitNew"] boolValue]) {
                   if (patchId.length > 0) {
                       [strongSelf requestHotFixFromNetwork];
                   }
                   //该版本没有拉取过patch，则缓存该patchId
                   NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPatchIdDictKey];
                   NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                   [mutDict setObject:responseDictionary[@"id"] forKey:[strongSelf appVertion]];
                   [strongSelf userDefaultsSave:kPatchIdDictKey value:mutDict];
               }
           }
       }
    }];
    [dataTask resume];
}

/// 从服务端拉取最新有效的补丁包
- (void)requestHotFixFromNetwork {
    if (self.kHotUrl.length == 0) {
        NSLog(@"kHotUrl must be defined");
        return;
    }
    
    NSString *urlStr = self.kHotUrl;
    if ([self appVertion].length > 0) {
        urlStr = [NSString stringWithFormat:@"%@?version=%@",self.kHotUrl,[self appVertion]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
       cachePolicy:NSURLRequestUseProtocolCachePolicy
       timeoutInterval:5];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
        
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
       if (error) {
          NSLog(@"%@", error);
       } else {
           if (data.length > 0) {
               NSString *filePath = [[strongSelf cachesPath] stringByAppendingPathComponent:@"demo.mg"];
               if (![data writeToFile:filePath atomically:YES]) {
                   NSLog(@"Failed to save the latest patch!");
                   return;
               }
               [strongSelf.context evalMangoScriptWithAES128Data:data];
           }
       }
    }];
    [dataTask resume];
}

/// 从沙盒文件加载解析修复脚本，以验证脚本是否有效
- (void)loadHotFixFromLocal {
    // 1.本地方式修复crash
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"local" ofType:@"mg"];
    NSString *hotFixContent = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    NSData *hotFixData = [hotFixContent dataUsingEncoding:NSUTF8StringEncoding];
    NSData  *aesData = [hotFixData AES128ParmEncryptWithKey:self.kAES128Key iv:self.kAES128Iv];
    MFContext *context = [[MFContext alloc] initWithAES128Key:self.kAES128Key iv:self.kAES128Iv];
    [context evalMangoScriptWithAES128Data:aesData];
}

- (NSString *)appVertion {
    NSDictionary *infoDictionary = NSBundle.mainBundle.infoDictionary ?: @{};
    NSString *app_Version = [NSString stringWithFormat:@"%@" , infoDictionary[@"CFBundleShortVersionString"] ?: @""];
    return app_Version;
}

- (NSString*)cachesPath {
    return (NSString *)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (MFContext *)context {
    if (!_context) {
        _context = [[MFContext alloc] initWithAES128Key:self.kAES128Key iv:self.kAES128Iv];
    }
    return _context;
}

@end
