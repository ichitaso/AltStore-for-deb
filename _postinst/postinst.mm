#import <UIKit/UIKit.h>
#import <dlfcn.h>

#define INFO_PATH @"/Applications/AltStore.app/Info.plist"

static CFStringRef (*$MGCopyAnswer)(CFStringRef);

static inline NSString *getUDID(void) {
    void *gestalt(dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY));
    $MGCopyAnswer = reinterpret_cast<CFStringRef (*)(CFStringRef)>(dlsym(gestalt, "MGCopyAnswer"));
    CFStringRef result = $MGCopyAnswer(CFSTR("UniqueDeviceID"));
    return (__bridge NSString *)(result);
}

int main(int argc, char **argv, char **envp) {
    @autoreleasepool {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:INFO_PATH];
        NSMutableDictionary *mutableDict = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
        [mutableDict setValue:getUDID() forKey:@"ALTDeviceID"];
        [mutableDict writeToFile:INFO_PATH atomically:YES];
    }
    return 0;
}
