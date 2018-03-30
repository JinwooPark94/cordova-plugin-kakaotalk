#import "KakaoTalk.h"
#import <Cordova/CDVPlugin.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@implementation KakaoTalk

- (void)login:(CDVInvokedUrlCommand*)command
{
  [[KOSession sharedSession] close];

  [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
    if ([[KOSession sharedSession] isOpen]) {
      // 로그인 성공
      // 사용자 정보 요청
      [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error) {
        CDVPluginResult* pluginResult = nil;
        if (result) {

          // 리턴
          NSDictionary *userSession = @{
            @"id": result.ID,
            @"nickname": [result propertyForKey:KOUserNicknamePropertyKey],
            @"email": result.email,
            @"profileImage":[result propertyForKey:KOUserProfileImagePropertyKey]
          };
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userSession];
        } else {
          // 사용자 정보 요청 실패
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      }];
    } else {
      // 로그인 실패
      CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
  } authType: (KOAuthType)KOAuthTypeTalk, nil];
}

@end

@implementation AppDelegate (CDVAppDelegate)

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([KOSession isKakaoAccountLoginCallback:url]){return [KOSession handleOpenURL:url];}
}

- (void)applicationDidBecomeActive:(UIApplication *)application{[KOSession handleDidBecomeActive];}

@end
