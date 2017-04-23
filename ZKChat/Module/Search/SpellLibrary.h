//
//  SpellLibrary.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpellLibrary : NSObject
+ (SpellLibrary*)instance;

/**
 *  清除所有数据
 */
- (void)clearAllSpell;
-(void)clearSpellById:(NSString *)objctid;
/**
 *  添加一个用户名称的拼音数据
 *
 *  @param sender user or group
 */
- (void)addSpellForObject:(id)sender;

-(BOOL)isEmpty;
/**
 *  根据给出拼音找出相关的用户名
 *
 *  @param spell 拼音
 */
- (NSMutableArray*)checkoutForWordsForSpell:(NSString*)spell;
- (NSMutableArray*)checkoutForWordsForSpell_Deparment:(NSString*)spell;

/**
 *  获得某个词的拼音
 *
 *  @param word 某个词
 *
 *  @return 词的拼音
 */
- (NSString*)getSpellForWord:(NSString*)word;

/**
 *  将拼音进行简全缩写
 *
 *  @param sender 完整拼音的数组
 *  @param count  完整拼音的个数
 *
 *  @return 结果
 */
- (NSString*)briefSpellWordFromSpellArray:(NSArray*)sender fullWord:(int)count;


@end
