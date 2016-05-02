//
//  CATLogSender.h
//  CATLog
//
//  Created by zengcatch on 16/4/18.
//  Copyright © 2016年 cacth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <TargetConditionals.h>
#import <Availability.h>

extern NSString *const CATLogTransferException;
extern NSString *const CATLogTransferErrorDomain;

extern NSString *const CATLogTransferQueueName;
extern NSString *const CATLogTransferThreadName;

typedef NS_ENUM(NSInteger, CATLogTransferError) {
    CATLogTransferNoError = 0,
    CATLogTransferBadConfigError,
    CATLogTransferBadParamError,
    CATLogTransferSendTimeoutError,
    CATLogTransferClosedError,
    CATLogTransferOtherError,
};

@class CATLogTransfer;

@protocol CATLogTransferDelegate
@optional

- (void)transfer:(CATLogTransfer *)sock didConnectToAddress:(NSData *)address;

- (void)transfer:(CATLogTransfer *)sock didNotConnect:(NSError *)error;

- (void)transfer:(CATLogTransfer *)sock didSendDataWithTag:(long)tag;

- (void)transfer:(CATLogTransfer *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error;

- (void)transfer:(CATLogTransfer *)sock didReceiveData:(NSData *)data
     fromAddress:(NSData *)address
withFilterContext:(id)filterContext;

- (void)transferDidClose:(CATLogTransfer *)sock withError:(NSError *)error;

@end

typedef BOOL (^CATLogTransferReceiveFilterBlock)(NSData *data, NSData *address, id *context);

typedef BOOL (^CATLogTransferSendFilterBlock)(NSData *data, NSData *address, long tag);


@interface CATLogTransfer : NSObject

- (id)init;
- (id)initWithSocketQueue:(dispatch_queue_t)sq;
- (id)initWithDelegate:(id <CATLogTransferDelegate>)aDelegate delegateQueue:(dispatch_queue_t)dq;
- (id)initWithDelegate:(id <CATLogTransferDelegate>)aDelegate delegateQueue:(dispatch_queue_t)dq socketQueue:(dispatch_queue_t)sq;

#pragma mark Configuration

- (id <CATLogTransferDelegate>)delegate;
- (void)setDelegate:(id <CATLogTransferDelegate>)delegate;
- (void)synchronouslySetDelegate:(id <CATLogTransferDelegate>)delegate;

- (dispatch_queue_t)delegateQueue;
- (void)setDelegateQueue:(dispatch_queue_t)delegateQueue;
- (void)synchronouslySetDelegateQueue:(dispatch_queue_t)delegateQueue;

- (void)getDelegate:(id <CATLogTransferDelegate>*)delegatePtr delegateQueue:(dispatch_queue_t *)delegateQueuePtr;
- (void)setDelegate:(id <CATLogTransferDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)synchronouslySetDelegate:(id <CATLogTransferDelegate>)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (BOOL)isIPv4Enabled;
- (void)setIPv4Enabled:(BOOL)flag;

- (BOOL)isIPv6Enabled;
- (void)setIPv6Enabled:(BOOL)flag;

- (BOOL)isIPv4Preferred;
- (BOOL)isIPv6Preferred;
- (BOOL)isIPVersionNeutral;

- (void)setPreferIPv4;
- (void)setPreferIPv6;
- (void)setIPVersionNeutral;

- (uint16_t)maxReceiveIPv4BufferSize;
- (void)setMaxReceiveIPv4BufferSize:(uint16_t)max;

- (uint32_t)maxReceiveIPv6BufferSize;
- (void)setMaxReceiveIPv6BufferSize:(uint32_t)max;

- (id)userData;
- (void)setUserData:(id)arbitraryUserData;

#pragma mark Diagnostics
- (NSData *)localAddress;
- (NSString *)localHost;
- (uint16_t)localPort;

- (NSData *)localAddress_IPv4;
- (NSString *)localHost_IPv4;
- (uint16_t)localPort_IPv4;

- (NSData *)localAddress_IPv6;
- (NSString *)localHost_IPv6;
- (uint16_t)localPort_IPv6;

- (NSData *)connectedAddress;
- (NSString *)connectedHost;
- (uint16_t)connectedPort;
- (BOOL)isConnected;
- (BOOL)isClosed;
- (BOOL)isIPv4;
- (BOOL)isIPv6;

#pragma mark Binding
- (BOOL)bindToPort:(uint16_t)port error:(NSError **)errPtr;
- (BOOL)bindToPort:(uint16_t)port interface:(NSString *)interface error:(NSError **)errPtr;
- (BOOL)bindToAddress:(NSData *)localAddr error:(NSError **)errPtr;

#pragma mark Connecting
- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port error:(NSError **)errPtr;

- (BOOL)connectToAddress:(NSData *)remoteAddr error:(NSError **)errPtr;

#pragma mark Multicast
- (BOOL)joinMulticastGroup:(NSString *)group error:(NSError **)errPtr;
- (BOOL)joinMulticastGroup:(NSString *)group onInterface:(NSString *)interface error:(NSError **)errPtr;

- (BOOL)leaveMulticastGroup:(NSString *)group error:(NSError **)errPtr;
- (BOOL)leaveMulticastGroup:(NSString *)group onInterface:(NSString *)interface error:(NSError **)errPtr;

#pragma mark Reuse Port
- (BOOL)enableReusePort:(BOOL)flag error:(NSError **)errPtr;

#pragma mark Broadcast
- (BOOL)enableBroadcast:(BOOL)flag error:(NSError **)errPtr;

#pragma mark Sending
- (void)sendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (void)sendData:(NSData *)data
          toHost:(NSString *)host
            port:(uint16_t)port
     withTimeout:(NSTimeInterval)timeout
             tag:(long)tag;

- (void)sendData:(NSData *)data toAddress:(NSData *)remoteAddr withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (void)setSendFilter:(CATLogTransferSendFilterBlock)filterBlock withQueue:(dispatch_queue_t)filterQueue;

- (void)setSendFilter:(CATLogTransferSendFilterBlock)filterBlock
            withQueue:(dispatch_queue_t)filterQueue
       isAsynchronous:(BOOL)isAsynchronous;

#pragma mark Receiving
- (BOOL)receiveOnce:(NSError **)errPtr;

- (BOOL)beginReceiving:(NSError **)errPtr;

- (void)pauseReceiving;

- (void)setReceiveFilter:(CATLogTransferReceiveFilterBlock)filterBlock withQueue:(dispatch_queue_t)filterQueue;

- (void)setReceiveFilter:(CATLogTransferReceiveFilterBlock)filterBlock
               withQueue:(dispatch_queue_t)filterQueue
          isAsynchronous:(BOOL)isAsynchronous;

#pragma mark Closing
- (void)close;
- (void)closeAfterSending;

#pragma mark Advanced
- (void)markSocketQueueTargetQueue:(dispatch_queue_t)socketQueuesPreConfiguredTargetQueue;
- (void)unmarkSocketQueueTargetQueue:(dispatch_queue_t)socketQueuesPreviouslyConfiguredTargetQueue;

- (void)performBlock:(dispatch_block_t)block;

- (int)socketFD;
- (int)socket4FD;
- (int)socket6FD;

#if TARGET_OS_IPHONE
- (CFReadStreamRef)readStream;
- (CFWriteStreamRef)writeStream;
#endif

#pragma mark Utilities

+ (NSString *)hostFromAddress:(NSData *)address;
+ (uint16_t)portFromAddress:(NSData *)address;
+ (int)familyFromAddress:(NSData *)address;

+ (BOOL)isIPv4Address:(NSData *)address;
+ (BOOL)isIPv6Address:(NSData *)address;

+ (BOOL)getHost:(NSString **)hostPtr port:(uint16_t *)portPtr fromAddress:(NSData *)address;
+ (BOOL)getHost:(NSString **)hostPtr port:(uint16_t *)portPtr family:(int *)afPtr fromAddress:(NSData *)address;

@end