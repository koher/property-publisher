#if canImport(UIKit)

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

#endif
