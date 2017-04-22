//
//  DDSendBuffer.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSendBuffer : NSMutableData
{
@private
    NSMutableData *embeddedData;
    NSInteger sendPos;
}

@property (readonly) NSInteger sendPos;

+ (id)dataWithNSData:(NSData *)newdata;

- (id)initWithData:(NSData *)newdata;
- (void)consumeData:(NSInteger)length;

- (const void *)bytes;
- (NSUInteger)length;

- (void *)mutableBytes;
- (void)setLength:(NSUInteger)length;

@end
