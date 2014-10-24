//
//  HFLocalManager.m
//  HFPlugsDemo
//
//  Created by wangmeng on 14-10-22.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import "HFLocalManager.h"
#import "GCDAsyncUdpSocket.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>

#import "NSData+HFHexBin.h"
#import "HFConfig.h"

static HFLocalManager * localManager;
@implementation HFLocalManager{
    NSMutableArray *delegateArray;
    GCDAsyncUdpSocket *udpsock;
}
+(HFLocalManager*)getInstance{
    if(localManager == nil){
        localManager = [[HFLocalManager alloc]init];
    }
    return localManager;
}

-(id)init{
    self = [super init];
    if(self){
        delegateArray = [[NSMutableArray alloc]init];
        udpsock = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [udpsock enableBroadcast:YES error:nil];
    }
    return self;
}
-(void)startBeat{

    while (YES) {
       // [NSTimer scheduledTimerWithTimeInterval:SERVER_TIMEOUT/1000 target:self selector:@selector(sendBeat) userInfo:nil repeats:NO];
        [self sendBeat];
        sleep(SERVER_TIMEOUT/100);
    }
}
-(void)sendBeat{
    NSData *data =  [NSData toData:DATA_LOCAL_BEAT];
    [udpsock sendData:data toHost: [self localBroadCastIP] port:LOCAL_PORT withTimeout:SERVER_TIMEOUT/1000 tag:-1];
    NSLog(@"send beat %@",DATA_LOCAL_BEAT);
}
-(void)startEventRecv{
     NSLog(@"start recv");
    NSError *err = [[NSError alloc]init];
    [udpsock beginReceiving:&err];
}
-(void)registerEvent:(id<EventDelegate>)del{
    if([delegateArray containsObject:del]){
        [delegateArray removeObject:del];
    }
    [delegateArray addObject:del];
}
-(void)unregisterEvent:(id<EventDelegate>)del{
    if([delegateArray containsObject:del]){
        [delegateArray removeObject:del];
    }
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{

    NSString * msg = [data hexString];
    NSLog(@"%@",msg);
}


-(NSString *)localBroadCastIP
{
    NSString *address = @"error";
    struct ifaddrs *interface = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    UInt32 uip,umask,ubroadip;
    
    success = getifaddrs(&interface);
    
    if(success == 0){
        temp_addr = interface;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name]isEqualToString:@"en0"]) {
                    uip = NTOHL(((struct sockaddr_in *)(temp_addr->ifa_addr))->sin_addr.s_addr);
                    umask = NTOHL((((struct sockaddr_in *)(temp_addr->ifa_netmask))->sin_addr).s_addr);
                    ubroadip = (uip&umask)+(0XFFFFFFFF&(~umask));
                    struct in_addr inadd;
                    inadd.s_addr = HTONL(ubroadip);
                    address = [NSString stringWithUTF8String:inet_ntoa(inadd)];
                    break;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interface);
    NSLog(@"local BroadCast %@",address);
    return address;
}


@end
