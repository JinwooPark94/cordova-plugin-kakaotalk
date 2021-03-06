Cordova Plugin KakaoTalk
========================

### ionic1, ionic2+ 에서 사용할 수 있습니다.

이 Cordova 플러그인은 taejaehan의 Cordova-Kakaotalk-Plugin를 수정하였습니다.

 - https://github.com/taejaehan/Cordova-Kakaotalk-Plugin

해당 플러그인을 사용하기에 앞서 카카오 개발자 홈페이지에서 카카오 앱을 등록하여 KAKAO_APP_KEY를 발급 받아야합니다.

- [https://developers.kakao.com](https://developers.kakao.com)

## 추가사항

- 최신버전의 카카오링크 사용이 가능합니다.

설치 방법
========================

## Cordova Plugin 설치

플러그인 추가
```
cordova plugin add https://github.com/leeduyoung/cordova-plugin-kakaotalk.git --variable KAKAO_APP_KEY=YOUR_KAKAO_APP_KEY
```

안드로이드

* 카카오 개발자 센터에서 키 해시를 등록해야 합니다 (https://developers.kakao.com/docs/android#getting-started-launch-sample-app)

아이폰
 
* 카카오링크 v2를 사용하기 위해서는 ios용 최신 sdk를 다운받고(https://developers.kakao.com/docs/sdk) 추가해줘야합니다.
* KakaoLink.framework, KakaoCommon.framework, KakaoMessageTemplate.framework 프로젝트 -> Frameworks drag & drop 하여 추가합니다.

## Ionic Plugin v1 설치

* cordova 플러그인만 추가하면 됩니다. (위 내용 참조)

* 사용법은 아래 v2  동일합니다.

## Ionic Plugin v2+ 설치
Ionic에서 사용하기 위해서는 Cordova 플러그인을 앞서 설치해야합니다.

Ionic 카카오톡 플러그인 설치

```
npm install --save ionic-plugin-kakaotalk
```

app.module.ts Provider 추가

```
  providers: [
    ...
    KakaoTalk,
    ...
  ]
```

How to use the plugin
========================

### Usage

This plugin adds an object to the window. Right now, you can login, logout and share.

##### Login

Login using the `.login` method:
```
KakaoTalk.login(
    function (result) {
      console.log('Successful login!');
      console.log(result);
    },
    function (message) {
      console.log('Error logging in');
      console.log(message);
    }
);
```

The login reponse object is defined as:
```
{
  id: '<KakaoTalk User Id>',
  nickname: '<KakaoTalk User Nickname>',
  profile_image: '<KakaoTalk User ProfileImage>'
}
```

##### Logout

Logout using the `.logout` method:
```
KakaoTalk.logout(
	function() {
		console.log('Successful logout!');
	}, function() {
		console.log('Error logging out');
	}
);
```

##### Share

Share using the `.share` method:
```
KakaoTalk.share({
    text : 'Share Message',
    image : {
      src : 'https://developers.kakao.com/assets/img/link_sample.jpg',
      width : 138, 
      height : 90,
    },
    weblink :{
      url : 'YOUR-WEBSITE URL',
      text : 'web사이트로 이동'
    },
    applink :{
      url : 'YOUR-WEBSITE URL', 
      text : '앱으로 이동',
    },
    params :{
      paramKey1 : 'paramVal',
      param1 : 'param1Value',
      cardId : '27',
      keyStr : 'hey'
    }
  },
  function (success) {
    console.log('kakao share success');
  },
  function (error) {
    console.log('kakao share error');
  });
```

- you can use text, image, weblink and applink(params) separately or together
- Min image width(80)xheight(80)
- weblink(text-link), applink(button-link)
- if you use applink, you can set any params(optional)

- https://developers.kakao.com/docs/ios#카카오링크
- https://developers.kakao.com/docs/android#카카오링크
