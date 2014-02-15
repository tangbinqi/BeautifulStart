//
//  ProtocolHelper.m
//  Cloud
//
//  Created by wujin on 12-9-27.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import "ProtocolHelper.h"
#import "Reachability.h"
#import "Extension.h"
#import "iOSShare.h"
#import "Statement.h"
#import "ASINetworkQueue.h"

@implementation ProtocolHelper

-(id)init
{
    self=[super init];
    if (self) {
        self.requestMethod=@"POST";//默认为POST请求
        postDictionary=[[NSMutableDictionary alloc] init];
        headerDictionary=[[NSMutableDictionary alloc] init];
        fileDictionary=[[NSMutableDictionary alloc] init];
        self.async=YES;
        self.useCache=YES;
        self.timeOut=10;
        str_response=[[NSMutableString alloc] init];
    }
    return self;
}

-(void)dealloc
{
    if (self.finishBlock) {
        self.finishBlock=nil;
    }
    if (self.failBlock) {
        self.failBlock=nil;
    }
    DDLogInfo(@"Protocol %@ dealloc susess!",[self description]);
    self.requestUrl=nil;
    self.requestMethod=nil;
    self.ext_args=nil;
    [postDictionary release];
    [headerDictionary release];
    [fileDictionary release];
    
    [asiRequest clearDelegatesAndCancel];
    [asiRequest release];
    self.ext_args=nil;
    [str_response release];
#ifdef _Protocol_DEBUG
    [date_request release];
    [dete_response release];
    [date_successBlockBegin release];
    [date_sucessBlockEnd release];
#endif
    [super dealloc];
}


-(ASIHTTPRequest*)asiRequest
{
    return asiRequest;
}

#pragma mark -
#pragma mark -request
-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
    self.finishBlock=susessBlock;
    self.failBlock=failBlock;
    
    if (self.useCache) {
        //先返回缓存读取到的数据
        [self dataFromCache];
        if (cacheLParam!=nil||cacheRParam!=nil) {
            [self cacheSusessWithlParam:cacheLParam RParam:cacheRParam];
        }
        
        //如果断网状态下，如果缓存读取失败，调用失败方法
        else if (![self reachablityToInternet]) {
            [self failWithParam:nil RParam:kConnectFailedKey];
        }
        cacheLParam=nil;
        cacheRParam=nil;
    }
    
    if (asiRequest!=nil) {
        [asiRequest clearDelegatesAndCancel];
        asiRequest=nil;
    }
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    
    //URL不为空并且能够联网的情况下再请求
    if (StringNotNullAndEmpty(self.requestUrl)&&[reach currentReachabilityStatus]!=kNotReachable)
    {
        asiRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:self.requestUrl]];
        
        
        
        for (int i=0; i<headerDictionary.allKeys.count; i++) {
            [asiRequest addRequestHeader:headerDictionary.allKeys[i] value:headerDictionary.allValues[i]];
        }
        
        for (int i=0; i<fileDictionary.allKeys.count; i++) {
            [asiRequest addFile:fileDictionary.allValues[i] forKey:fileDictionary.allKeys[i]];
        }
        
        asiRequest.requestMethod=self.requestMethod;
        asiRequest.delegate=self;
        asiRequest.useCookiePersistence=NO;
        asiRequest.timeOutSeconds=self.timeOut;//默认10S超时
        [asiRequest setPersistentConnectionTimeoutSeconds:60*10];//默认保持连接10分钟
        [asiRequest setShouldAttemptPersistentConnection:YES];//默认启用keep alive
        
        [asiRequest setDidFailSelector:@selector(requestFailed:)];
        [asiRequest setDidFinishSelector:@selector(requestFinished:)];
        [asiRequest setDidStartSelector:@selector(requestStarted:)];
        
        for (NSString *key in postDictionary.allKeys) {
            [asiRequest setPostValue:[postDictionary objectForKey:key] forKey:key];
        }
        ///如果自动开始请求，则开始请求
        if(self.startManual==NO)
        {
            [self startRequest];
        }
        
    }else{//如果不使用缓存，调用失败
        if (!self.useCache) {
            [self failWithParam:nil RParam:kConnectFailedKey];
        }
    }
}

-(void)startRequest
{
    
    
    if (self.async==YES) {
        [asiRequest startAsynchronous];
    }else{
        [asiRequest startSynchronous];
    }
    
    
    if (self.autoRetainRelease) {
        [self retain];
    }
}

/*
 调用成功处理逻辑
 */
-(void)susessWithlParam:(id)lParam RParam:(id)rParam
{
    if(self.finishBlock!=nil){
        
#ifdef _Protocol_DEBUG
            [date_successBlockBegin release];
            date_successBlockBegin = [[NSDate date] retain];
#endif
        __block ProtocolHelper *block_self=self;
        @autoreleasepool {
            block_self.finishBlock(lParam,rParam);
        }

#ifdef _Protocol_DEBUG
            [date_sucessBlockEnd release];
            date_sucessBlockEnd = [[NSDate date] retain];
            NSTimeInterval timeSpend = [date_sucessBlockEnd timeIntervalSinceDate:date_successBlockBegin];
            [str_response appendFormat:@"\n.........\n%@:finishBlock spend time: %f ms\n.........\n",[[self class] description],timeSpend*1000];
#endif
        
        self.finishBlock=nil;
        self.failBlock=nil;
    }
}
/*
 调用成功处理逻辑
 */
-(void)cacheSusessWithlParam:(id)lParam RParam:(id)rParam
{
    if(self.finishBlock!=nil){
        __block ProtocolHelper *block_self=self;
        @autoreleasepool {
            block_self.finishBlock(lParam,rParam);
        }
    }
}

/*
 调用失败处理逻辑
 */
-(void)failWithParam:(id)lParam RParam:(id)rParam
{
    if (self.failBlock!=nil) {
        __block ProtocolHelper *block_self=self;
        @autoreleasepool {
            block_self.failBlock(lParam,rParam);
        }

        self.failBlock=nil;
        self.finishBlock=nil;
    }
}

/*
 从缓存读取数据
 */
-(void)dataFromCache
{
    cacheLParam=nil;
    cacheRParam=nil;
}

#pragma mark -
#pragma mark -add param and resolve
/*
 解析返回成功报文的参数
 请将解析完成后的数据传回
 */
-(id)handleSusessParam:(NSString*)str Susess:(BOOL*)result
{
    *result=YES;
    id dic= [str objectFromJSONString];
    
#ifdef _Protocol_DEBUG
    
    [str_response appendFormat:@"%@-<%p> response-%@",[[self class] description],self,self.requestUrl];
    
    [str_response appendString:@"\n*********************************************\n"];
    [str_response appendFormat:@"response:%@\n",str];
    if (asiRequest.responseCookies.count>1) {
        [str_response appendFormat:@"\ncookies:%@\n",asiRequest.responseCookies.description];
    }
    [str_response appendString:@"\n*********************************************\n"];
    
    DDLogInfo(str_response);
#endif
    
    
    if ([dic isKindOfClass:[NSDictionary class]]) {

        NSNumber *retcode=[dic objectForKey:@"status"];
        
        if (![retcode isKindOfClass:[NSNumber class]]) {
            *result=NO;
            return nil;
        }
        
        self.resultCode=[retcode intValue];

        if (self.resultCode!=200) {//不等于200，结果错误
            *result=NO;

            NSString *code=_S(@"%d",self.resultCode);
            DDLogError(@"protocol return resultcode-%@",code);
            dic=nil;
        }
    }
    return dic;
}


/*
 解析失败报文的参数
 请将解析完成后的数据传回
 */
-(id)handleFailParam:(NSString*)str
{
#ifdef _Protocol_DEBUG
    DDLogInfo(@"%@:fail-%@<%p> \nparam:\n*********************************************\n%@\n%@\n*********************************************\n",[[self class ]description],self.requestUrl,self,str,self.asiRequest.error.description);
#endif
    id result= [str objectFromJSONString];
    
    return result;
}

#pragma mark-
#pragma mark asihttprequest delegate
- (void)requestStarted:(ASIHTTPRequest *)nrequest
{
    
#ifdef _Protocol_DEBUG
    //[NSMutableString stringWithFormat:@"%p %@:request-%@\n param:\n*********************************************\n%@\n \ncookie:%@ method:%@"
    NSMutableString *str=[NSMutableString stringWithFormat:@"%@ <%p>: request start-%@",[[self class] description],self,self.requestUrl];
    [str appendFormat:@"\n*********************************************"];
    if(postDictionary.allKeys.count>0)
    {
        [str appendFormat:@"\nrequest-param:{%@}\n",postDictionary.description];
    }
    if (nrequest.requestCookies.count) {
        [str appendFormat:@"\nrequest-cookie:{%@}\n",nrequest.requestCookies.description];
    }
    
    [str appendFormat:@"\nrequest-method:%@",self.requestMethod];

    if (headerDictionary.allKeys.count>0) {
        [str appendString:_S (@"\nrequest-header:{\n%@}\n",headerDictionary.description)];
    }
    if (fileDictionary.allKeys.count>0) {
        [str appendString:_S(@"\nrequest-file:{\n%@}\n",fileDictionary.description)];
    }
    [str appendFormat:@"\n*********************************************"];
    DDLogInfo(str);
    [date_request release];
    date_request=[[NSDate date] retain];
#endif
}

- (void)requestFinished:(ASIHTTPRequest *)nrequest
{
    __block ProtocolHelper *block_self=self;
    //防止模型层产生过多的对象，加入自动回收池
    @autoreleasepool {
        if (nrequest.responseStatusCode==200) {
            if (StringIsNullOrEmpty(nrequest.responseString)) {
                [block_self failWithParam:nil RParam:nil];
            }else if ([nrequest.responseString objectFromJSONString]==nil){
                DDLogInfo(@"%@: response not json object",[[block_self class]description]);
                
                //结果不为json对象
                [block_self failWithParam:@"-1" RParam:self];
            }else{
                BOOL susess=NO;

                id result=[block_self handleSusessParam:nrequest.responseString Susess:&susess];
                
                if (susess) {
                    [block_self susessWithlParam:result RParam:block_self];
                }else{
                    [block_self failWithParam:_S(@"%d",self.resultCode) RParam:block_self];
                }
            }
        }else{
            [block_self failWithParam:[self handleFailParam:nrequest.responseString] RParam:block_self];
        }
    }
    if (self.autoRetainRelease) {
        [self release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)nrequest
{
    [self failWithParam:@"-1" RParam:[self handleFailParam:nrequest.responseString]];
    if (self.autoRetainRelease) {
        [self release];
    }
}

-(BOOL)reachablityToInternet
{
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    return [reach currentReachabilityStatus]!=kNotReachable;
}

/*
 取消此次显示请求
 */
-(void)cancel
{
    if (self.asiRequest) {        
        [asiRequest clearDelegatesAndCancel];
    }
    if (self.finishBlock) {
        self.finishBlock=nil;
    }
    if (self.failBlock) {
        self.failBlock=nil;
    }
}

/*
 返回用默认方法进行协议缓存的文件夹
 
 位于  <appdir>/Documents/protocol_cache/
 */
+(NSString*)protocolCacheDir
{
    NSString *dir=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"protocol_cache"];
    BOOL isDir=NO;
    if (([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir]&&isDir)==NO) {//文件夹不存在，创建
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}
/*
 返回用默认方法进行协议缓存的文件名
 
 位于  <appdir>/Documents/protocol_cache/<协议名称>
 */
-(NSString*)protocolCacheFileName
{
    return [[ProtocolHelper protocolCacheDir] stringByAppendingPathComponent:_S(@"%s",object_getClassName(self))];
}
+(id)shareProtocol
{
    DDLogInfo(@"please impletion +(id)shareProtocol method and then invoke this method");
    return nil;
}

+(id)protocol
{
    return [[[[self class] alloc] init] autorelease];
}

+(id)protocolAutoRelease
{
    id obj= [[[[self class] alloc] init] autorelease];
    [obj setAutoRetainRelease:YES];
    return obj;
}

+(ASINetworkQueue*)shareNetworkQueue
{
    static ASINetworkQueue *_shareNetworkQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareNetworkQueue=[[ASINetworkQueue alloc] init];
        _shareNetworkQueue.maxConcurrentOperationCount=4;
    });
    return _shareNetworkQueue;
}
@end
