//
//  HFSmtlkV30.h
//  物联工场
//
//  Created by Peter on 14-1-7.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>

@class GCDAsyncUdpSocket;

@protocol SmtlkV30Delegate  <NSObject>
@required//这个可以是required，也可以是optional

/*SmartLink 发送结束后（并非整个SmartLink流程结束），回调函数。建议在第一次收到这个回调时，再调用SmtlkV30StartWithKey:函数
 *完成2次发送流程*/
- (void)SmtlkV30Finished;
/*SmartLink成功收到模块回复时，回调函数。参数为模块MAC地址*/
- (void)SmtlkV30ReceivedRspMAC:(NSString *)mac fromHost:(NSString *)host;

@end

@interface HFSmtlkV30 : NSObject
{
    id<SmtlkV30Delegate> delegate;
    GCDAsyncUdpSocket *udpSock;
    GCDAsyncUdpSocket *tmpSock;
    
    NSString *udpHost;
    uint16_t udpLocalPort;
    uint16_t udpRmPort;
    
    NSString * SMTV30UDPBCADD;
    
    BOOL started;
    NSInteger sendLoop;
    NSInteger sendTimes;
    NSString *sendKey;
    Byte sendData[600];

    NSTimer *timer;
}

/*HFSmtlkV30初始化函数，参数为Delegate的类*/
- (id)initWithDelegate:(id)cls;
/*SmartLink开始发送密码，只发密码，模块会从收到的数据中提取出路由器的SSID*/
- (void)SmtlkV30StartWithKey:(NSString *)key;
/*停止发送*/
- (void)SmtlkV30Stop;
/*发送完成后，用这个函数发送查询命令，模块收到这个命令后会回复MAC地址*/
- (void)SendSmtlkFind;

/*通知模块收到配置成功的信息，让模块停止响应 smartlinkfind*/
-(void)SendSmartlinkEnd:(NSString*)msg  moduelIp:(NSString*)ip;

@end
