# PropertyPublisher

_PropertyPublisher_ provides `Publisher`s for properties of `ObservableObject`s. It is useful especially for computed properties whose values are derived from other `@Published` stored properties.

```swift
viewModel
    .publisher(for: \.isButtonEnabled) // ✅
    .assign(to: \.isEnabled, on: button)
    .store(in: &cancellables)
```

## Example

```swift
import UIKit
import Combine
import PropertyPublisher

@MainActor final class CounterViewModel: ObservableObject {
    @Published var count: Int = 0
    var countText: String { count.description }
    var isResetButtonEnabled: Bool { count != 0 }
    // ...
}

final class CounterViewController: UIViewController {
    private let viewModel: CounterViewModel = .init()
    
    @IBOutlet private var countLabel: UILabel!
    @IBOutlet private var resetButton: UIButton!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .publisher(for: \.countText) // ✅
            .sink { [weak self] text in
                self?.countLabel.text = text
            }
            .store(in: &cancellables)
        
        viewModel
            .publisher(for: \.isResetButtonEnabled) // ✅
            .assign(to: \.isEnabled, on: resetButton)
            .store(in: &cancellables)
    }
    // ...
}
```

## License

MIT
