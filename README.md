# CorePlayer.Swift
A iOS and OS X media player framework based on AVPlayer.

## Requirements
- iOS 7.0+
- OSX 10.7+

## How To Get Started
- Just compile source files
- Or make a framework by yourself


## Architecture

### `CPModuleManager`

### `CPModule`
- Conforms `CPModuleDelegate`

### `CPModuleView`
- Conforms `CPModuleViewDelegate`


## Usage

```corePlayer = CorePlayer()
corePlayer!.moduleManager()?.initModules([ModuleView.self])

corePlayer!.view().frame = self.view.bounds
view.addSubview(corePlayer!.view())

corePlayer.playURL(URL)
```

## License

CorePlayer.Swift is available under the MIT license. See the LICENSE file for more info.
