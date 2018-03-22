//
//  ViewController.m
//  KeychainDemo
//
//  Created by 王庆朋 on 2018/3/22.
//  Copyright © 2018年 ftsafe. All rights reserved.
//

#import "ViewController.h"
#import "STKeychain.h"

#define kService @"com.ft.keychain"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *key;
@property (strong, nonatomic) IBOutlet UITextField *value;
@property (strong, nonatomic) IBOutlet UILabel *result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)save:(id)sender
{
    STKeychain *keychain = [[STKeychain alloc]initWithService:kService];
    [keychain saveValue:_value.text forKey:_key.text];
}

- (IBAction)read:(id)sender
{
    STKeychain *keychain = [[STKeychain alloc]initWithService:kService];
    _result.text =  [keychain readValue:_key.text];
}

- (IBAction)deleteValue:(id)sender
{
    STKeychain *keychain = [[STKeychain alloc]initWithService:kService];
    _result.text = [NSString stringWithFormat:@"%d",[keychain deleteValue:_key.text]];
}

@end
