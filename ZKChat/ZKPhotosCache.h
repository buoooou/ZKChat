//
//  ZKPhotosCache.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^cacheblock)(BOOL isFinished);

@interface ZKPhotoEnity : NSObject
@property(nonatomic,strong)NSString *localPath;
@property(nonatomic,strong)NSString *resultUrl;
@property(nonatomic,assign)CGImageRef imageRef;
@property(nonatomic,strong)UIImage* image;
@end

@interface ZKPhotosCache : NSObject
+(void)calculatePhotoSizeWithCompletionBlock:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock;
+ (ZKPhotosCache *)sharedPhotoCache;
- (void)storePhoto:(NSData *)photos forKey:(NSString *)key toDisk:(BOOL)toDisk ;
- (NSData *)photoFromDiskCacheForKey:(NSString *)key;
- (void)removePhotoForKey:(NSString *)key;
- (NSString *)defaultCachePathForKey:(NSString *)key;
- (NSUInteger)getSize;
- (int)getDiskCount;
- (void)removePhotoFromNSCacheForKey:(NSString *)key;
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(void (^)(NSData *voice))doneBlock;
-(NSString *)getKeyName;
-(void)clearAllCache:(void(^)(bool isfinish))block;;
-(NSMutableArray *)getAllImageCache;
@end
