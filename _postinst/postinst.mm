#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <spawn.h>

#define APP_PATH @"/Applications/AltStore.app"
#define INFO_PATH @"/Applications/AltStore.app/Info.plist"
#define ROOT_PATH_NS(path)([[NSFileManager defaultManager] fileExistsAtPath:path] ? path : [@"/var/jb" stringByAppendingPathComponent:path])

static CFStringRef (*$MGCopyAnswer)(CFStringRef);

static inline NSString *getUDID(void) {
    void *gestalt(dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY));
    $MGCopyAnswer = reinterpret_cast<CFStringRef (*)(CFStringRef)>(dlsym(gestalt, "MGCopyAnswer"));
    CFStringRef result = $MGCopyAnswer(CFSTR("UniqueDeviceID"));
    return (__bridge NSString *)(result);
}

extern char **environ;
void run_action(const char *cmd) {
    pid_t pid;
    const char *argv[] = {"sh", "-c", cmd, NULL};
    int status;
    status = posix_spawn(&pid, "/bin/sh", NULL, NULL, (char * const *)argv, environ);
    if (status == 0) {
        printf("Child pid: %i\n", pid);
        if (waitpid(pid, &status, 0) != -1) {
            printf("Child exited with status %i\n", status);
        } else {
            perror("waitpid");
        }
    } else {
        printf("posix_spawn: %s\n", strerror(status));
    }
}

int main(int argc, char **argv, char **envp) {
    @autoreleasepool {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:ROOT_PATH_NS(INFO_PATH)];
        NSMutableDictionary *mutableDict = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
        [mutableDict setValue:getUDID() forKey:@"ALTDeviceID"];
        [mutableDict writeToFile:INFO_PATH atomically:YES];

        NSString *command1 = [NSString stringWithFormat:@"chown -R 0:0 %s", [ROOT_PATH_NS(APP_PATH) UTF8String]];
        NSString *command2 = [NSString stringWithFormat:@"chmod -R 0755 %s", [ROOT_PATH_NS(APP_PATH) UTF8String]];
        NSString *command3 = [NSString stringWithFormat:@"uicache -p %s", [ROOT_PATH_NS(APP_PATH) UTF8String]];
        run_action([command1 UTF8String]);
        run_action([command2 UTF8String]);
        run_action([command3 UTF8String]);
    }
    return 0;
}
