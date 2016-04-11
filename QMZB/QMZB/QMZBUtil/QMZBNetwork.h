//
//  QMZBNetwork.h
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define BaseServiceUrl	@"http://gotyelive.gotlive.com.cn:20000"
#define BaseServiceUrl	@"http://192.168.1.166:11000"

@interface QMZBNetwork : NSObject

-(void)postddByByUrlPath:(NSString *)path andParams:(NSDictionary*)params andCallBack:(void(^)(id back))callback;

-(void)getddByByUrlPath:(NSString *)path andParams:(NSString *)params andCallBack:(void(^)(id back))callback;

-(void)reLogin_andCallBack:(void(^)(BOOL back))callback;

@end
