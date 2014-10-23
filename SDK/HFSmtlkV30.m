//
//  HFSmtlkV30.m
//  物联工场
//
//  Created by Peter on 14-1-7.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import "HFSmtlkV30.h"
#import "GCDAsyncUdpSocket.h"
//#import "getgateway.h"

//#define SMTV30UDPBCADD @"255.255.255.255"
#define SMTV30UDPLOCALPORT 49999
#define SMTV30UDPRMPORT    48899 //49998

#define SMTV30_BASELEN      76
#define SMTV30_STARTCODE      '\r'
#define SMTV30_STOPCODE       '\n'

@implementation HFSmtlkV30

- (id)initWithDelegate:(id)cls
{
    if (self = [super init])
    {
        delegate = cls;
        started= FALSE;
        sendLoop= 0;
        for (int i= 0; i< 600; i++)
            sendData[i]= '5';
        //[self initSmatlkV30UDP];
    }
    return self;
}


- (void)initSmatlkV30UDP
{
    
    SMTV30UDPBCADD = [self localBroadCastIP];
    NSLog(SMTV30UDPBCADD);
	tmpSock = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    udpLocalPort= SMTV30UDPLOCALPORT;
    udpRmPort= SMTV30UDPRMPORT;
    
	NSError *error = nil;
	if (![tmpSock bindToPort:udpLocalPort error:&error])
	{
		NSLog(@"Error binding: %@", error);
		return;
	}
    
    udpSock = tmpSock;
    if (![udpSock beginReceiving:&error])
	{
		NSLog(@"Error receiving: %@", error);
		return;
	}
    // Peter: enable BroadCast
    [udpSock enableBroadcast:TRUE error:&error];
    
    NSLog(@"UDP Connected, localHost= %@, port=%hu!", udpSock.localHost, udpSock.localPort);
}

- (void)SmtlkV30StartWithKey:(NSString *)key
{
    [self initSmatlkV30UDP];
    started= TRUE;
    sendKey= key;
    sendTimes= 0;
    sendLoop= 0;
    [self SmtlkV30SendHead];
}

- (void)SmtlkV30SendHead
{
    if ((sendTimes>=200)||(started== FALSE))
    {
        [timer invalidate];
        timer = nil;
        sendTimes = 0;
        if (started== TRUE)
            [self SmtlkV30SendStartCode];
        return;
    }

    [self SmtlkV30SendOneByte:SMTV30_BASELEN];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(SmtlkV30SendHead) userInfo:nil repeats:NO];
    sendTimes++;
}

- (void)SmtlkV30SendStartCode
{
    if ((sendTimes>=3)||(started== FALSE))
    {
        [timer invalidate];
        timer = nil;
        sendTimes = 0;
        if (started== TRUE)
            [self SmtlkV30SendKeyCode];
        return;
    }
    NSInteger code=SMTV30_BASELEN+ SMTV30_STARTCODE;
    [self SmtlkV30SendOneByte:code];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(SmtlkV30SendStartCode) userInfo:nil repeats:NO];
    sendTimes++;
}

- (void)SmtlkV30SendKeyCode
{
    NSInteger len= sendKey.length;
    if ((sendTimes>=len)||(started== FALSE))
    {
        [timer invalidate];
        timer = nil;
        sendTimes = 0;
        if (started== TRUE)
            [self SmtlkV30SendStopCode];
        return;
    }
    NSInteger code=SMTV30_BASELEN+ [sendKey characterAtIndex:sendTimes];
    [self SmtlkV30SendOneByte:code];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(SmtlkV30SendKeyCode) userInfo:nil repeats:NO];
    sendTimes++;
}

- (void)SmtlkV30SendStopCode
{
    if ((sendTimes>=3)||(started== FALSE))
    {
        [timer invalidate];
        timer = nil;
        sendTimes = 0;
        if (started== TRUE)
            [self SmtlkV30SendVerifyCode];
        return;
    }
    NSInteger code=SMTV30_BASELEN+ SMTV30_STOPCODE;
    [self SmtlkV30SendOneByte:code];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(SmtlkV30SendStopCode) userInfo:nil repeats:NO];
    sendTimes++;
}

- (void)SmtlkV30SendVerifyCode
{
    if ((sendTimes>=3)||(started== FALSE))
    {
        [timer invalidate];
        timer = nil;
        sendTimes = 0;
        if ((started== TRUE)&&(sendLoop< 4))
        {
            sendLoop++;
            [self SmtlkV30SendStartCode];
            NSLog(@"Send %d times, keyLen=%d", (int)sendLoop, (int)(sendKey.length));
        }
        else
        {
            started= FALSE;
            [delegate SmtlkV30Finished];
        }
        return;
    }
    NSInteger code=SMTV30_BASELEN+ sendKey.length+ 256;
    [self SmtlkV30SendOneByte:code];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(SmtlkV30SendVerifyCode) userInfo:nil repeats:NO];
    sendTimes++;
}

- (void)SmtlkV30SendOneByte:(NSInteger)len
{
    NSData *sd;
    
    if ((len> 0)&&(started== TRUE))
    {
        sd= [[NSData alloc] initWithBytes:sendData length:len];
        [udpSock sendData:sd toHost:SMTV30UDPBCADD port:udpLocalPort withTimeout:-1 tag:0];
    }
}

- (void)SendSmtlkFind
{
    NSLog(@"SendSmtlkFind");
    NSString *aStr=@"smartlinkfind";
    NSData *sd=[aStr dataUsingEncoding: NSASCIIStringEncoding];
    [udpSock sendData:sd toHost:SMTV30UDPBCADD port:udpRmPort withTimeout:-1 tag:0];
}


-(void)SendSmartlinkEnd:(NSString*)msg  moduelIp:(NSString*)ip
{
    NSLog(@"SendSmtlkEnd %@",msg);
    NSData *sd=[msg dataUsingEncoding: NSASCIIStringEncoding];
    [udpSock sendData:sd toHost:ip port:udpLocalPort withTimeout:-1 tag:0];
}

- (void)SmtlkV30Stop
{
    started= FALSE;
//    [udpSock closeAfterSending];
}

#pragma mark - delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                            fromAddress:(NSData *)address
                                        withFilterContext:(id)filterContext
{
    NSString *host = nil;
    uint16_t port = 0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    NSArray *a = [s componentsSeparatedByString:@" "];

    if (host == nil) {
        return;
    }
    
    if (a.count==2)
    {
        NSLog(@"s === %@", s);
        NSLog(@"a === %@", a);
        NSString * smartConfig =[a objectAtIndex:0];
        NSString * macID = [a objectAtIndex:1];
        
        if ([smartConfig isEqualToString:@"smart_config"] )
        {
            if ([host rangeOfString:@":"].location != NSNotFound || [host isEqualToString:@"0.0.0.0"]) {
                return;
            }
            [delegate SmtlkV30ReceivedRspMAC:macID fromHost:host];
        }
    }
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
    return address;
    
}

@end
