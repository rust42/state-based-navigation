import UIKit

class Coordinator {
    
    private let window: UIWindow
    private var rootViewController: ContainerViewController!
    private lazy var stateMachine: any StateManaging<Coordinator, NavigationEvent> = StateMachine(initialState: FirstState(), context: self)
    
    
    func start() {
        (stateMachine as? StateMachine<Coordinator, NavigationEvent>)?.start()
    }
    
    init(window: UIWindow) {
        self.window = window
        
        let viewController = ViewController()
        self.window.rootViewController = viewController
        viewController.delegate = self
        self.rootViewController = viewController
    }
}

extension Coordinator: PagesCoordinator {
    func goToFirstViewController(with event: NavigationEvent) {
        if case .dataLoaded = event {
            let viewController = makeViewController(with: "First")
            rootViewController.show(viewController: viewController, in: .forward)
        }
        
        if case .buttonTapped(let direction) = event {
            let viewController = makeViewController(with: "First")

            rootViewController.show(viewController: viewController, in: direction == .forward ? .forward : .reverse)
        }
    }
    
    func goToSecondViewController(with event: NavigationEvent) {
        if case .buttonTapped(let direction) = event {
            let viewController = makeViewController(with: "Second")
            rootViewController.show(viewController: viewController, in: direction == .forward ? .forward : .reverse)
        }

    }
    
    func goToThirdViewController(with event: NavigationEvent) {
        if case .buttonTapped(let direction) = event {
            let viewController = makeViewController(with: "Third")
            rootViewController.show(viewController: viewController, in: direction == .forward ? .forward : .reverse)
        }
    }
    
    func goToFourthViewController(with event: NavigationEvent) {
        if case .buttonTapped(let direction) = event {
            let viewController = makeViewController(with: "Fourth")
            rootViewController.show(viewController: viewController, in: direction == .forward ? .forward : .reverse)
        }
    }
    
    func goToFifthViewController(with event: NavigationEvent) {
        if case .buttonTapped(let direction) = event {   
            let viewController = makeViewController(with: "Fifth")
            rootViewController.show(viewController: viewController, in: direction == .forward ? .forward : .reverse)
        }
    }
    
    func makeViewController(with title: String) -> UIViewController {
        PageViewController(title: title)
    }
}


extension Coordinator: ViewControllerDelegate {
    func didPresssNextButton() {
        stateMachine.transition(with: .buttonTapped(.forward))
    }
    
    func didPressPreviousButton() {
        stateMachine.transition(with: .buttonTapped(.backward))
    }
}
