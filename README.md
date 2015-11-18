# CorePlayer.Swift
![pod](https://img.shields.io/badge/pod-v1.0-green.svg)
![platform](https://img.shields.io/badge/platform-ios%20%7C%20osx-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/flexih/CorePlayer.Swift/blob/master/LICENSE)
![weibo](https://img.shields.io/badge/weibo-%40flexih-yellow.svg)

A iOS and OSX media player framework based on AVPlayer. Make your player UI and logic quickly and easily.

## Requirements
- iOS 7.0+
- OSX 10.7+
- Xcode 7.0+

## How To Get Started
- Just compile source files
- pod 'CorePlayer'


## Architecture

##### `CPModuleManager`

##### `CPModule`
- Conforms `CPModuleDelegate`

##### `CPModuleView`
- Conforms `CPModuleViewDelegate`


## Usage


```
corePlayer = CorePlayer()
corePlayer!.moduleManager()?.initModules([ModuleView.self])
corePlayer!.view().frame = self.view.bounds
view.addSubview(corePlayer!.view())

corePlayer!.playURL(URL)
```

## Snapshot
![](snapshot/shot2.png "")

![](snapshot/shot1.png "")

## License

CorePlayer.Swift is available under the MIT license. See the LICENSE file for more info.
