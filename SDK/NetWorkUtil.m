//
//  NetWorkUtil.m
//  HFPlugs
//
//  Created by wangmeng on 14-10-23.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import "NetWorkUtil.h"
#import "HFConfig.h"
#import "GCDAsyncUdpSocket.h"
#import "NSData+HFHexBin.h"

#include<stdio.h>
#include<stdlib.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<syslog.h>
#include<unistd.h>
#include<errno.h>
#include<string.h>
#define BUFSIZE 1024


@implementation NetWorkUtil

+(void)udpsendAsyc:(NSString*)data delegate:(id<UdpDelegate>)del{
    GCDAsyncUdpSocket *udpsock = [[GCDAsyncUdpSocket alloc]init];
}
+(void)httpsendAsyc:(NSString *)data delegate:(id<HttpPostDelegate>)del{
    
}

+(NSString*)udpsendSync:(NSString*)data{
    int sockfd;
    struct sockaddr_in server_addr;
    int server_ip;
    int nrecv;
    char buffer[BUFSIZE];
    unsigned int alen;
    
    memset(&server_addr,0,sizeof(server_addr));
    server_addr.sin_family=AF_INET;
    server_addr.sin_port=htons(LOCAL_PORT);
    inet_pton(AF_INET,"192.168.11.105",(void*)&server_ip);
    server_addr.sin_addr.s_addr=server_ip;
    
    sockfd=socket(AF_INET,SOCK_DGRAM,0);
    if(sockfd<0){
        NSLog(@"ruptime_udp:socket() failed!\n");
        return nil;
    }
    memset(buffer, 0, BUFSIZE);
    alen=sizeof(struct sockaddr);
    char * buf = [data UTF8String];
    strcpy(buffer, buf);
    
    if(sendto(sockfd,buffer,1,0,(struct sockaddr*)&server_addr,sizeof(struct sockaddr))<0){
        return nil;
    }
    
    if((nrecv=recvfrom(sockfd,buffer,BUFSIZE,0,(struct sockaddr*)&server_addr,&alen))<=0){
        return nil;
    }
        //write(STDOUT_FILENO,buffer,nrecv);

    NSString *rsp = [NSData toHexString:[NSData dataWithBytes:buffer length:nrecv]];
    NSLog(@"recv %@",rsp);
    return rsp;
}

+(NSString *)httpsendSyc:(NSString *)data{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:SERVER_TIMEOUT/1000];
    [request setHTTPMethod:@"POST"];
    NSString *str = data;
    NSData *mdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    //    [request setValue:@"application/json" forKey:@"Content-Type"];
    //    [request setValue:@"uft-8" forKey:@"Content-Encodeing"];
    [request setHTTPBody:mdata];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *rsp = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    return rsp;
}

@end
