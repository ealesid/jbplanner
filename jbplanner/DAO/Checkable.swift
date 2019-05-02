import Foundation


protocol Checkable: class {
    var checked: Bool { get set }
}


// protocol adoption - адаптация классов под нужные интерфейсы
extension Priority: Checkable {}

extension Category: Checkable {}
