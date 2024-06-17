import Foundation

protocol StateManaging<Context, Event>: AnyObject {
    associatedtype Context
    associatedtype Event

    func start()
    func transition(with event: Event)
    func transition(to state: any State<Context, Event>, with event: Event)
}

extension StateManaging {
    func start() { }
}

protocol State<Context, Event> {
    associatedtype Context
    associatedtype Event
    
    func nextState(with event: Event) throws -> any State<Context, Event>
    func canTransition(to state: any State<Context, Event>) -> Bool
    func process(event: Event, with context: Context) throws
}

enum StateError: Error {
    case invalidTransition
}


class StateMachine<C, E>: StateManaging {
    private var currentState: any State<C, E>
    private let context: C

    init(initialState: any State<C, E>, context: C) {
        self.currentState = initialState
        self.context = context
    }

    func transition(with event: E) {
        do {
            let nextState = try currentState.nextState(with: event)
            transition(to: nextState, with: event)
        } catch {
            handle(error: error)
        }
    }
    
    func transition(to state: any State<C, E>, with event: E) {
        do {
            guard currentState.canTransition(to: state) else {
                throw createCustomTransitionError(from: currentState, to: state, event: event)
            }
            self.currentState = state
            try currentState.process(event: event, with: context)
        } catch {
            handle(error: error)
        }
    }
    
    private func createCustomTransitionError(from: any State<C, E>, to: any State<C, E>, event: E) -> Error {
        return NSError(domain: "com.Walmart.Vc_assoc.StateMachine.ErrorDomain",
                     code: 101,
                       userInfo: [NSLocalizedFailureReasonErrorKey:
                                    "Invalid transition from state: \(type(of: from)), to: \(type(of: to)) with event: \(event)"])
    }
    
    private func handle(error: Error) {
        print("Error occurred: \(error)")
    }
}


extension StateMachine where C == Coordinator, E == NavigationEvent {
    func start() {
        do {
            try currentState.process(event: .dataLoaded, with: context)
        } catch {
            
        }
    }
}
