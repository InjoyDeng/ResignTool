# ResignTool
This is an app for macOS that can (re)sign apps and bundle them into ipa files that are ready to be installed on an iOS device. 

这是一个运行在 macOS 上的 ipa 文件签名（重签）工具，并且不受 ProvisioningProfile 文件中的 applicationIdentifier 限制，支持含有 Framework、dylib 的 ipa 文件

![ResignTool](https://i.imgur.com/U4rGoDQ.png)

## Usage

This app requires Xcode to be installed.

You need a provisioning profile and signing certificate, you can get these from Xcode by creating a new project.

You can then open up iOS App Signer and select your input file, signing certificate, provisioning file, and optionally specify a new application ID and/or application display name.

## License
Copyright (c) 2017 Injoy . All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Thanks To
[maciekish / iReSign](https://github.com/maciekish/iReSign): The basic process was gleaned from the source code of this project.

