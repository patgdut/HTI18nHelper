//
//  NSObject+HTRuntime.h
//  
//
//  Created by 任健生 on 13-4-10.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSObject (HTRuntime)

+ (void)add:(Class)clazz seletor:(SEL)seletor imp:(IMP)imp type:(const char *)type;
+ (void)swizzle:(Class)clazz from:(SEL)original to:(SEL)newSeletor imp:(IMP)newImp;
+ (void)swizzle:(Class)clazz from:(SEL)original to:(SEL)newSeletor;
+ (void)swizzleClassMethod:(Class)clazz from:(SEL)original to:(SEL)newSeletor;
- (void)printClassMethods:(Class)clazz;
- (id)memberWithName:(NSString *)name;
- (SEL)seletorWithName:(const char *)name;


@end
