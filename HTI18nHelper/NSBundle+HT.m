//
//  NSBundle+HT.m
//  
//
//  Created by 任健生 on 13-6-13.
//
//

#import "NSBundle+HT.h"
#import "NSObject+HTRuntime.h"

@implementation NSBundle (HT)

+(void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method origMethod = class_getInstanceMethod(self, @selector(localizedStringForKey:value:table:));
        origin_localizedStringForKey_value_table = (void *)method_getImplementation(origMethod);
        
        [NSObject swizzle:self
                     from:@selector(localizedStringForKey:value:table:)
                       to:@selector(custom_localizedStringForKey_value_table)
                      imp:(IMP)custom_localizedStringForKey_value_table];
    });
    
}

static NSString* (*origin_localizedStringForKey_value_table)(id self, SEL _cmd, NSString *key, NSString *value, NSString *tableName);

NSString* custom_localizedStringForKey_value_table(id self, SEL _cmd, NSString *key, NSString *value, NSString *tableName) {
    
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"i18n"];
    
    if (language && ![language isEqualToString:@"system"]) {
        NSString *string = [self localizedStringForKey:key language:language];
        if (string) {
            return string;
        }
    }
    
    return origin_localizedStringForKey_value_table(self, _cmd, key, value, tableName);
}



- (NSString *)localizedStringForKey:(NSString *)key language:(NSString *)language {
    
    static NSBundle *bundle;
    static NSDictionary *localizableDict;
    
    if (!bundle) {
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:path];
        [bundle load];
        
        NSString *localizablePath = [bundle pathForResource:@"Localizable" ofType:@"strings"];
        localizableDict = [[NSDictionary alloc] initWithContentsOfFile:localizablePath];
    }
    
    if (![localizableDict objectForKey:key]) {
        return nil;
    }
    
    return origin_localizedStringForKey_value_table(bundle, _cmd, key, nil, nil);
    
}


@end
