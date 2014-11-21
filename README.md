## cordova-wechat ![NPM version](https://img.shields.io/npm/v/cordova-wechat.svg?style=flat) 

just another wechat plugin for cordova, which will be always updated with the lastest Wechat Official SDK

### Installation
```bash
$ cordova plugin add https://github.com/turingou/cordova-wechat.git
```

### Plugin Setup

1. The very first, follow the setup guide on [Wechat Open Platform](https://open.weixin.qq.com/cgi-bin/frame?t=resource/res_main_tmpl&verify=1&lang=zh_CN)
2. Put offcial SDK `./src/<platform>/lib/<version>/WXApi.h` and `./src/<platform>/lib/<version>/WXApiObject.m` to your xcode project. (Replace <platform> and <version> with your pefer)
3. On your xcode project `TARGETS > Build Settings > Basic`, Add field `Library Seach Paths` and set it as previous offcial SDK's real abs path.
4. On your xcode project `TARGETS > Info`, Add Id `weixin` to your `URL Types` with `URL Schemes = YOUR_WECHAT_APP_ID` 

Then try to run `$ cordova build` in your project root.

**Tips**: If xcode build error, make sure all `xcode` projects in your root project have a correct `Build Settings > All > Architectures > armv7 armv7s` instead of `armv6`.

### Example
```js
var Wechat = window.Wechat;
var myWechatApp = new Wechat('MY_WECHAT_APP_ID');

myWechatApp.on('success', function(){
  alert('Share success!');
});

myWechatApp.on('error', function(err){
  alert('Opps, ' + err);
});

myWechatApp.share('timeline', {
  title: 'Message to be shared to Wechat timelime'
});
```

### Contributing
- Fork this repo
- Clone your repo
- Install dependencies
- Checkout a feature branch
- Feel free to add your features
- Make sure your features are fully tested
- Open a pull request, and enjoy <3

### MIT license
Copyright (c) 2014 turing &lt;o.u.turing@Gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

---
![docor](https://raw.githubusercontent.com/turingou/docor/master/docor.png)
built upon love by [docor](https://github.com/turingou/docor.git) v0.2.0