//
//  QNConnectChecker.h
//  QiniuSDK_Mac
//
//  Created by yangsen on 2021/1/8.
//  Copyright © 2021 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNConnectChecker : NSObject

+ (BOOL)check;

+ (void)check:(void(^)(BOOL isConnected))complete;

@end

NS_ASSUME_NONNULL_END
