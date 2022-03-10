import Combine
import Dispatch

extension ObservableObject {
    public typealias PropertyPublisher<T> = Publishers
        .RemoveDuplicates<
            Publishers.Concatenate<
                Publishers.Sequence<[T], Never>,
                Publishers.Map<
                    Publishers.ReceiveOn<ObjectWillChangePublisher, DispatchQueue>,
                    T>>>
    
    public func publisher<T>(for keyPath: KeyPath<Self, T>)
            -> PropertyPublisher<T> where T: Equatable {
        objectWillChange
            .receive(on: DispatchQueue.main)
            .map { _ in self[keyPath: keyPath] }
            .prepend(self[keyPath: keyPath])
            .removeDuplicates()
    }
}
