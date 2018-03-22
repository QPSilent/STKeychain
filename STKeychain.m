//
//  STKeychain.m
//  test
//
//  Created by silent on 2018/3/22.
//  Copyright © 2018年 ft. All rights reserved.
//

#import "STKeychain.h"

@interface STKeychain ()

/*  service:服务,方便大家使用理解,可以指定为应用的bundle-id,代表当前应用要存储
 *
 *  一个service下可以存放多组key-value键值对,也适合大家按照字典的key-value键值对的方式进行存储
 */
@property (nonatomic,copy)NSString *service;

@end

@implementation STKeychain

- (instancetype)initWithService:(NSString *)service;
{
    if (self = [super init]) {
        
        _service = service;
    }
    return self;
}

- (NSMutableDictionary *)getKeychainQuery:(NSString *)account {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            _service, (__bridge_transfer id)kSecAttrService,
            account, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

//存储数据,类比字典的key-value存储方式
- (void)saveValue:(NSString *)value forKey:(NSString *)key;
{
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取对应的字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:valueData forKey:(__bridge_transfer id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

//读取数据
- (NSString *)readValue:(NSString *)key;
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    OSStatus keychainError = noErr;

    keychainError = (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData));
    if (keychainError == errSecItemNotFound) {
        return nil;
    }else if (keychainError == noErr) {
        
        if (keyData == nil){return nil;}
        
        NSData *resultData = (__bridge_transfer NSData *)keyData;
        NSString *password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
        return password;
    }
    return nil;
}

//删除数据
- (BOOL)deleteValue:(NSString *)key;
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];

    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    if (status != noErr && status != errSecItemNotFound) {
        return NO;
    }
    return true;
}

@end
