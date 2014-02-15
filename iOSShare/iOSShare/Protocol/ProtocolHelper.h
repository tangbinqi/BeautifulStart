//
//  ProtocolHelper.h
//  Cloud
//  协议请求的基类
//  每个协议请求类都应该继承此类后进行一些自己的添加请求数据和解析数据的操作
//  Created by wujin on 12-9-27.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Extension.h"

@class ASINetworkQueue;

#define kConnectFailedKey @"联网失败"
//block块的两个参数
#define BlockParam Susess:(RequestBlock)susess Fail:(RequestBlock)fail

#define BlockParamWith (RequestBlock)susess Fail:(RequestBlock)fail

//改变url请求
#define AppendUrl(str) self.requestUrl=[self.requestUrl stringByAppendingString:str]

//附加给url一个参数
#define AppendParam(key,value) self.requestUrl=[self.requestUrl stringByAppendingFormat:@"%@=%@",key,value];

//有些宏定义表示协议为调试状态，将打印报文
#define _Protocol_DEBUG

//在NSKeyedArchiver 中缓存一个协议报文
#define CacheProtocol(key)          NSMutableData *data=[NSMutableData data];\
                                    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];\
                                    [archiver encodeObject:str forKey:key];\
                                    [archiver finishEncoding];\
                                    [data writeToFile:[self protocolCacheFileName] atomically:YES];\
                                    [archiver release];
//从NSKeyedArchiver 中读取一个协议报文的key
#define DeCacheProtocol(key)        NSData *data=[NSData dataWithContentsOfFile:[self protocolCacheFileName]];\
                                    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];\
                                    NSString *str=[unarchiver decodeObjectForKey:key];\
                                    if (StringNotNullAndEmpty(str)) {\
                                        BOOL susess=YES;\
                                        cacheLParam=[self handleSusessParam:str Susess:&susess];\
                                    }\
                                    [unarchiver release];
//使用GET访问协议
#define P_GET self.requestMethod=@"GET";
//使用POST访问协议
#define P_POST self.requestMethod=@"POST";

//实现一个单例的协议对象
#define IMP_SHAREINSTANCE static id shareInstance_p;\
                            +(id)shareProtocol\
                            {\
                                if(shareInstance_p==nil)\
                                {\
                                    shareInstance_p=[[[self class] alloc] init];\
                                }\
                                return shareInstance_p;\
                            }\
/*
 用于标识一次请求的一个块语句
 */
typedef void(^RequestBlock)(id lParam,id rParam);

@interface ProtocolHelper : NSObject{
    ASIFormDataRequest *asiRequest;
    
    NSMutableDictionary *postDictionary;//用于发送参数的dictionary;
    NSMutableDictionary *headerDictionary;//用于发送Header的dictionary;
    NSMutableDictionary *fileDictionary;///要发送的文件
    
    id cacheLParam;//缓存的lParam  如果两个参数中有一个不为nil，将调用成功方法
    id cacheRParam;//缓存的rParam  如果两个参数中有一个不为nil，将调用成功方法   请在dataFromCache方法中给这两个参数赋值
    
    NSMutableString *str_response;
#ifdef _Protocol_DEBUG
    NSDate *date_request;
    NSDate *dete_response;
    NSDate *date_successBlockBegin;
    NSDate *date_sucessBlockEnd;
    
#endif
}
//用于请求的对象
@property (nonatomic,readonly) ASIFormDataRequest *asiRequest;

@property (nonatomic,retain) NSString *requestMethod;//请求方式

/*
 标记请求协议的url
 如果不设置此值，些值默认为kServerUrl常量所定义的值
 如果需要更改此值，请在init方法中调用[super init]后更改
 */
@property (nonatomic,retain) NSString *requestUrl;

/*
 标记超时时间
 如果此时间后服务器还没有返回
 将标识为调用失败
 */
@property (nonatomic,assign) int timeOut;

/**
 是否手动开始此请求
 默认为NO
 当此值设置为YES时，需要调用startRequest才会开始请求
 */
@property (nonatomic,assign) BOOL startManual;

/*
 是否为异步加载，默认为YES
 */
@property (nonatomic,assign) BOOL async;

/*
 是否从缓存加载数据，默认为YES
 */
@property (nonatomic,assign) BOOL useCache;//是否从缓存加载数据

/*
 成功后调用的block
 此block会在调用成功或者失败后释放
 */
@property (nonatomic,copy) RequestBlock finishBlock;

/*
 失败后调用的block
 此block会在调用成功或者失败后释放
 */
@property (nonatomic,copy) RequestBlock failBlock;


/*
 服务器的返回状态码，一般情况下，200表示成功
 */
@property (nonatomic,assign) int resultCode;

/*
 此次请求过程中的额外参数
 此参数请求协议不会使用，仅用来标识一些需要在susess中进行处理的全局变量
 */
@property (nonatomic,retain) id ext_args;

/**
 设置此参数后会在RequestStart时retain自己，在requestDidFinish和requestDidFail的时候release自己
 默认为NO
 */
@property (nonatomic,assign) BOOL autoRetainRelease;

#pragma mark -
#pragma mark - resolve

/*
 解析返回成功报文的参数
 请将解析完成后的数据传回
 */
-(id)handleSusessParam:(NSString*)str Susess:(BOOL*)result;


/*
 解析失败报文的参数
 请将解析完成后的数据传回
 */
-(id)handleFailParam:(NSString*)str;

#pragma mark -
#pragma mark -request
/**
 调用此方法后会开始请求
 如果需要对asiRequest做出额外的处理，请在此方法中进行
 */
-(void)startRequest;


/*
 取消此次显示请求
 */
-(void)cancel;

/*
 从缓存读取数据
 */
-(void)dataFromCache;

/*
 开始请求报文
 */
-(void)requestWithSusessBlock:(RequestBlock) susessBlock FailBlock:(RequestBlock)failBlock;

/*
 调用成功处理逻辑
 */
-(void)susessWithlParam:(id)lParam RParam:(id)rParam;

/*
 调用失败处理逻辑
 */
-(void)failWithParam:(id)lParam RParam:(id)rParam;

-(BOOL)reachablityToInternet;

/*
 返回用默认方法进行协议缓存的文件夹
 
 位于  <appdir>/Documents/protocol_cache/
 */
+(NSString*)protocolCacheDir;
/*
 返回用默认方法进行协议缓存的文件名
 
 位于  <appdir>/Documents/protocol_cache/<协议名称>
 */
-(NSString*)protocolCacheFileName;

/*
 一个单例的协议对象
 */
+(id)shareProtocol;

/**
 返回一个工厂类创建的协议对象
 */
+(id)protocol;

/**
 返回一个工厂类创建的协议对象，
 但是此对象会自动retain和Relase(在协议请求开始的结束时）
 */
+(id)protocolAutoRelease;


/**
 返回默认的请求队列
 
 默认最多支持4个请求
 @return 返回队列
 */
+(ASINetworkQueue*)shareNetworkQueue;
@end
