import Foundation

protocol PagesCoordinator {
    
    func goToFirstViewController(with event: NavigationEvent)
    func goToSecondViewController(with event: NavigationEvent)
    func goToThirdViewController(with event: NavigationEvent)
    func goToFourthViewController(with event: NavigationEvent)
    func goToFifthViewController(with event: NavigationEvent)
}

enum ButtonNavigationDirection { case backward, forward }
enum NavigationEvent {
    case buttonTapped(ButtonNavigationDirection)
    case dataLoaded
    case other
}

struct FirstState<Context: PagesCoordinator>: State {
    func nextState(with event: NavigationEvent) throws -> any State<Context, NavigationEvent> {
        if case .buttonTapped(.forward) = event {
            return SecondState()
        }
        throw StateError.invalidTransition
    }
    
    func canTransition(to state: any State<Context, NavigationEvent>) -> Bool {
        if state is SecondState<Context> {
            return true
        }
        return false
    }
    
    func process(event: NavigationEvent, with context: Context) throws {
        context.goToFirstViewController(with: event)
    }
}

struct SecondState<Context: PagesCoordinator>: State {

    func nextState(with event: NavigationEvent) throws -> any State<Context, NavigationEvent> {
        if case .buttonTapped(.forward) = event {
            return ThirdState()
        }
        if case .buttonTapped(.backward) = event {
            return FirstState()
        }
        throw StateError.invalidTransition
    }
        
    func canTransition(to state: any State<Context, NavigationEvent>) -> Bool {
        if state is ThirdState<Context> || state is FirstState<Context> {
            return true
        }
        return false
    }

    func process(event: NavigationEvent, with context: Context) {
        context.goToSecondViewController(with: event)
    }
}

struct ThirdState<Context: PagesCoordinator>: State {
    func nextState(with event: NavigationEvent) throws -> any State<Context, NavigationEvent> {
        if case .buttonTapped(.forward) = event {
            return FourthState()
        }
        if case .buttonTapped(.backward) = event {
            return SecondState()
        }
        throw StateError.invalidTransition
    }
    
    func canTransition(to state: any State<Context, NavigationEvent>) -> Bool {
        if state is SecondState<Context> || state is FourthState<Context> {
            return true
        }
        return false
    }

    func process(event: NavigationEvent, with context: Context) throws {
        context.goToThirdViewController(with: event)
    }
}

struct FourthState<Context: PagesCoordinator>: State {
    func nextState(with event: NavigationEvent) throws -> any State<Context, NavigationEvent> {
        if case .buttonTapped(.forward) = event {
            return FifthState()
        }
        if case .buttonTapped(.backward) = event {
            return ThirdState()
        }
        throw StateError.invalidTransition
    }
    
    func canTransition(to state: any State<Context, NavigationEvent>) -> Bool {
        if state is ThirdState<Context> || state is FifthState<Context> {
            return true
        }
        return false
    }

        
    func process(event: NavigationEvent, with context: Context) {
        context.goToFourthViewController(with: event)
    }
}


struct FifthState<Context: PagesCoordinator>: State {
    func nextState(with event: NavigationEvent) throws -> any State<Context, NavigationEvent> {
        if case .buttonTapped(.backward) = event {
            return FourthState()
        }
        throw StateError.invalidTransition
    }
    
    func canTransition(to state: any State<Context, NavigationEvent>) -> Bool {
        if state is FourthState<Context> {
            return true
        }
        return false
    }

    
    func process(event: NavigationEvent, with context: Context) throws {
        context.goToFifthViewController(with: event)
    }
}
