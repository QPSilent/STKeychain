//
//  STKeychain.h
//  test
//
//  Created by silent on 2018/3/22.
//  Copyright © 2018年 ft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface STKeychain : NSObject

//获取STKeychain对象
- (instancetype)initWithService:(NSString *)service;

//存储数据
- (void)saveValue:(NSString *)value forKey:(NSString *)key;

//读取数据
- (NSString *)readValue:(NSString *)key;

//删除数据
- (BOOL)deleteValue:(NSString *)key;

@end
