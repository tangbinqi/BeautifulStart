//
//  NSString+Extension.m
//  iTrends
//
//  Created by wujin on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#include <sys/stat.h>
#include <dirent.h>

@implementation NSString (Extension)
-(BOOL)isNullOrEmpty//字符串是否为空或者null
{
    return self==nil||[self isEqualToString:@""];
}

-(BOOL)isNotNullAndEmpty
{
    return self!=nil&&(![self isEqualToString:@""]);
}

//判断字符串是否以指定字符串开始
-(BOOL)isStartWith:(NSString*)str
{
    
    return [self isMatchedByRegex:[NSString stringWithFormat:@"^%@",str]];
}
//判断字符串是否以指定字符串结束
-(BOOL)isEndWith:(NSString*)str
{
    return [self isMatchedByRegex:[NSString stringWithFormat:@"%@$",str]];
}
//判断字符串是否包含指定字符串
-(BOOL)isContainString:(NSString*)str
{
    return [self isMatchedByRegex:[NSString stringWithFormat:@"%@+",str]];
}

+(NSString*)tokenString:(NSData *)devToken
{
    NSString *token=devToken.description;//[[deviceToken description] stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    token=[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return token;
}

//替换HTML
-(NSString*)stringByReplaceHtml:(NSString*)str
{
    MREntitiesConverter *converter=[[MREntitiesConverter alloc] init];
    NSString *retstr=[converter convertEntiesInString:str];
    [converter release];
    return retstr;
}
//获取某固定文本的显示高度
+(CGRect)heightForString:(NSString*)str Size:(CGSize)size Font:(UIFont*)font
{
    return [NSString heightForString:str Size:size Font:font Lines:0];
}

+(CGRect)heightForString:(NSString*)str Size:(CGSize)size Font:(UIFont*)font Lines:(int)lines
{
    if (StringIsNullOrEmpty(str)) {
        return CGRectMake(0, 0, 0, 0);
    }
    static UILabel *lbtext;
    if (lbtext==nil) {
        lbtext    = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }else{
        lbtext.frame=CGRectMake(0, 0, size.width, size.height);
    }
    lbtext.font=font;
    lbtext.text=str;
    lbtext.numberOfLines=lines;
    CGRect rect= [lbtext textRectForBounds:lbtext.frame limitedToNumberOfLines:lines];
    if(rect.size.height<0)
        rect.size.height=0;
    if (rect.size.width<0) {
        rect.size.width=0;
    }
    return rect;

}

//获取图片名称对应的大小
+(CGSize)sizeForImageName:(NSString*)imgName
{
    if (StringIsNullOrEmpty(imgName)) {
        return CGSizeMake(0, 0);
    }
    //确定格式是否符合
    NSString *reg=@"_size[\\d]+x[\\d]+";
    if ([imgName isMatchedByRegex:reg]) {
        NSArray *array=[imgName componentsMatchedByRegex:reg];
        if (array.count>0) {
            NSString *size=[array lastObject];
            size=[size stringByReplacingOccurrencesOfString:@"_size" withString:@""];
            NSArray *w_h=[size componentsSeparatedByString:@"x"];
            if (w_h.count==2) {
                CGSize size;
                size.width=[(NSString*)[w_h objectAtIndex:0] floatValue];
                size.height=[(NSString*)[w_h objectAtIndex:1] floatValue];
                return size;//结果正确，返回
            }
        }
    }
    return CGSizeMake(0, 0);
}

-(int)lenghtForAudioUrlString
{
    NSArray *compent=[self componentsSeparatedByString:@"_"];
    if (compent.count<2) {
        return 0;
    }
    NSString *last=[compent lastObject];
    if([last hasPrefix:@"length"]){
        last=[last stringByReplacingOccurrencesOfString:@"length" withString:@""];
        return [last intValue];
    }
    return 0;
}


//获取图片名称对应的大小
-(CGSize)sizeForImageName
{
    return [NSString sizeForImageName:self];
}

//将字符串加上宽度参数
+(NSString*)stringByAddWidth:(CGFloat)width String:(NSString*)str
{
    width=[UIScreen mainScreen].scale*width;
    return [str stringByAppendingFormat:@"?width=%d",(int)width];
}

//将字符串加上宽度参数
-(NSString*)stringByAddWidth:(CGFloat)width
{
    return [NSString stringByAddWidth:width String:self];
}

//将字符串加上高度参数
+(NSString*)stringByAddHeight:(CGFloat)height String:(NSString*)str
{
    height=[UIScreen mainScreen].scale*height;
    return [str stringByAppendingFormat:@"?height=%d",(int)height];
}

//将字符串加上高度参数
-(NSString*)stringByAddHeight:(CGFloat)height
{
    return [NSString stringByAddHeight:height String:self];
}

//根据控件size拼接url
-(NSString *)stringByAddSize:(CGSize)displaySize
{
    CGSize imgSize = [self sizeForImageName];
    if (CGSizeEqualToSize(imgSize, CGSizeZero)) {
        NSLog(@"the imge size is zero");
        return self;
    }
    if (displaySize.width/displaySize.height > imgSize.width/imgSize.height) {
        return  [self stringByAddWidth:displaySize.width];
    }else{
        return [self stringByAddHeight:displaySize.height];
    }
}

//将字符串加上高度参数
+(NSString*)stringByAddWidth:(CGFloat)width Height:(CGFloat)height String:(NSString*)str
{
    height=[UIScreen mainScreen].scale*height;
    return [ [NSString stringByAddWidth:width String:str] stringByAppendingFormat:@"&height=%d",(int)height ];
}

//将字符串加上高度参数 
-(NSString*)stringByAddWidth:(CGFloat)width Height:(CGFloat)height
{
    NSString *str= [NSString stringByAddWidth:width Height:height String:self];
//    NSLog(@"%@",str);
    return str;
}

//将字符串的高度参数移除
+(NSString*)stringByRemoveWidth:(NSString*)str
{
    NSArray *array=[str componentsSeparatedByString:@"?width="];
    if (array.count>0) {
        NSString *str2=[array lastObject];
        str2=[NSString stringWithFormat:@"?width=%@",str2];
        str=[str stringByReplacingOccurrencesOfString:str2 withString:@""];
    }
    return str;
}

-(NSString*)stringByRemoveWidth
{
    return [NSString stringByRemoveWidth:self];
}

//返回字符串经过md5加密后的字符
+(NSString*)stringDecodingByMD5:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19],
            result[20], result[21], result[22], result[23],
            result[24], result[25], result[26], result[27],
            result[28], result[29], result[30], result[31]
            ];
}

-(NSString*)md5DecodingString
{
    return [NSString stringDecodingByMD5:self];
}


+ (NSString*) base64Decode:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];// theData;
}

-(NSString*)base64Decode
{
    return [NSString base64Decode:self];
}

+ (NSString*) base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}
-(NSString*)base64Encode
{
    return [NSString base64Encode:[self dataUsingEncoding:NSUTF8StringEncoding]];
}

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long) fileSizeAtPath1:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 方法1：使用unix c函数来实现获取文件大小
+ (long long) fileSizeAtPath2:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}


#pragma mark 获取目录大小


// 方法1：循环调用fileSizeAtPath1
+ (long long) folderSizeAtPath1:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        if ([self fileSizeAtPath1:fileAbsolutePath] != [self fileSizeAtPath2:fileAbsolutePath]){
            NSLog(@"%@, %lld, %lld", fileAbsolutePath,
                  [self fileSizeAtPath1:fileAbsolutePath],
                  [self fileSizeAtPath2:fileAbsolutePath]);
        }
        folderSize += [self fileSizeAtPath1:fileAbsolutePath];
    }
    return folderSize;
}


// 方法2：循环调用fileSizeAtPath2
+ (long long) folderSizeAtPath2:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath2:fileAbsolutePath];
    }
    return folderSize;
}


// 方法3：完全使用unix c函数
+ (long long) folderSizeAtPath3:(NSString*) folderPath{
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}
+ (long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

@end


@implementation MREntitiesConverter
@synthesize resultString;
- (id)init
{
    if(self=[super init]) {
        resultString = [[NSMutableString alloc] init];
    }
    return self;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s {
    [self.resultString appendString:s];
}
- (NSString*)convertEntiesInString:(NSString*)s {
    if(s == nil) {
        NSLog(@"ERROR : Parameter string is nil");
    }
    NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
    NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSXMLParser* xmlParse = [[[NSXMLParser alloc] initWithData:data] autorelease];
    [xmlParse setDelegate:self];
    [xmlParse parse];
    return [NSString stringWithFormat:@"%@",resultString];
}
- (void)dealloc {
    [resultString release];
    [super dealloc];
}
@end