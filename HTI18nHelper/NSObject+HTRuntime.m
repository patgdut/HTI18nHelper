//
//  NSObject+HTRuntime.m
//  
//
//  Created by 任健生 on 13-4-10.
//
//

#import "NSObject+HTRuntime.h"


@implementation NSObject (HTRuntime)

- (void)printClassMethods:(Class)clazz {
    
    unsigned int count;
    Ivar* ivars = class_copyIvarList(clazz, &count);
    for(unsigned int i = 0; i < count; ++i) {
        NSLog(@"%s",ivar_getName(ivars[i]));
    }
    free(ivars);
    
    NSLog(@"\n");
    
    unsigned int numMethods = 0;
    Method * methods = class_copyMethodList(clazz, &numMethods);
    for (int i = 0; i < numMethods; ++i) {
        SEL selector = method_getName(methods[i]);
        NSLog(@"%@",NSStringFromSelector(selector));
    }
    free(methods);
}

+ (void)add:(Class)class seletor:(SEL)seletor imp:(IMP)imp type:(const char *)type {
    class_addMethod(class, seletor, imp, type);
}

// 动态替换方法实现
// 原有方法保留为ORIGxxx

+ (void)swizzle:(Class)class from:(SEL)original to:(SEL)new imp:(IMP)newImp {
    
    Method originalMethod = class_getInstanceMethod(class, original);
    
    IMP imp = class_getMethodImplementation(class, original);
    IMP prevImp = class_replaceMethod(class, original, imp, method_getTypeEncoding(originalMethod));
    const char *selectorName = sel_getName(original);
    char newSelectorName[strlen(selectorName) + 10];
    strcpy(newSelectorName, "ORIG");
    strcat(newSelectorName, selectorName);
    SEL newSelector = sel_getUid(newSelectorName);
    if(!class_respondsToSelector(class, newSelector)) {
        class_addMethod(class, newSelector, prevImp, method_getTypeEncoding(originalMethod));
    }
    
    class_addMethod(class, new, newImp, method_getTypeEncoding(originalMethod));
    class_replaceMethod(class, original, newImp, method_getTypeEncoding(originalMethod));
    

}


+ (void)swizzleClassMethod:(Class)class from:(SEL)original to:(SEL)new {
    Method a = class_getClassMethod(class, original);
    Method b = class_getClassMethod(class, new);
    method_exchangeImplementations(a, b);
}


+ (void)swizzle:(Class)class from:(SEL)original to:(SEL)new {
    
    Method a = class_getInstanceMethod(class, original);
    Method b = class_getInstanceMethod(class, new);
    if (class_addMethod(class, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(class, new, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
}


// 获取私有成员变量
- (id)memberWithName:(NSString *)name {
    void *member = nil;
    object_getInstanceVariable(self, [name UTF8String], &member);
    return (id)member;
}

- (SEL)seletorWithName:(const char *)name {
    void *member = nil;
    object_getInstanceVariable(self, name, &member);
    return (SEL)member;
}

@end
