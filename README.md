# CorePlayer.Swift
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/flexih/CorePlayer.Swift/blob/master/LICENSE)

A iOS and OSX media player framework based on AVPlayer.

## Requirements
- iOS 7.0+
- OSX 10.7+

## How To Get Started
- Just compile source files
- Or make it a framework by yourself


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

## License

CorePlayer.Swift is available under the MIT license. See the LICENSE file for more info.
