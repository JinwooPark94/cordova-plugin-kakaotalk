#import "KakaoTalk.h"
#import <Cordova/CDVPlugin.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>

@implementation KakaoTalk

- (void)login:(CDVInvokedUrlCommand*)command
{
  [[KOSession sharedSession] close];

  [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
    if ([[KOSession sharedSession] isOpen]) {
      // 로그인 성공
      CDVPluginResult* pluginResult = pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[KOSession sharedSession].accessToken];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
      // 로그인 실패
      CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
  } authType: (KOAuthType)KOAuthTypeTalk, nil];
}

- (void) share:(CDVInvokedUrlCommand*)command;
{
    KMTTemplate *template = [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
        NSMutableDictionary *options = [[command.arguments lastObject] mutableCopy];

        NSString* params = options[@"params"];
        if(params) {
            NSLog(@"params=%@", params);
            
            NSDictionary *paramsDic = [params copy];;
            NSString* paramsTitle = paramsDic[@"title"];
            NSString* paramsDesc = paramsDic[@"desc"];
            NSString* paramsImageUrl = paramsDic[@"imageUrl"];
            NSString* paramsLink = paramsDic[@"link"];
            
            // 콘텐츠
            feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
                contentBuilder.title = paramsTitle;
                contentBuilder.desc = paramsDesc;
                contentBuilder.imageURL = [NSURL URLWithString:paramsImageUrl];
                contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                    linkBuilder.mobileWebURL = [NSURL URLWithString:paramsLink];
                }];
            }];
        }
        
        NSString* text = options[@"text"];
        if(text) {
            NSLog(@"text=%@", text);
        }
        
        NSString* image = options[@"image"];
        if(image) {
            NSLog(@"image=%@", image);
        }
        
        NSString* weblink = options[@"weblink"];
        if(weblink) {
            NSLog(@"weblink=%@", weblink);

            NSDictionary *weblinkDic = [weblink copy];;
            NSString* url = weblinkDic[@"url"];
            [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
                buttonBuilder.title = @"웹으로 이동";
                buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                    linkBuilder.mobileWebURL = [NSURL URLWithString: url];
                }];
            }]];
        }
        
        NSString* applink = options[@"applink"];
        if(applink) {
            NSLog(@"applink=%@", applink);
            
            [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
                buttonBuilder.title = @"앱으로 이동";
                buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                    linkBuilder.iosExecutionParams = @"param1=value1&param2=value2";
                    linkBuilder.androidExecutionParams = @"param1=value1&param2=value2";
                }];
            }]];
        }
    
    }];    
    
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        // 성공
    } failure:^(NSError * _Nonnull error) {
        // 에러
    }];
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
