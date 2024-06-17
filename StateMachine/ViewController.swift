
import UIKit

protocol ContainerViewController: UIViewController {
    func show(viewController: UIViewController, in direction: UIPageViewController.NavigationDirection)
}


protocol ViewControllerDelegate: AnyObject {
    func didPresssNextButton()
    func didPressPreviousButton()
}

class ViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    weak var delegate: ViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        let pageView = pageViewController.view!
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageView)
        
        let previousButton = UIButton(primaryAction: .init(title: "Previous", handler: { [weak self] _ in
            guard let self else {
                return
            }
            delegate?.didPressPreviousButton()
        }))
        
        let nextButton = UIButton(primaryAction: .init(title: "Next", handler: { [weak self] _ in
            guard let self else {
                return
            }
            delegate?.didPresssNextButton()
        }))
        
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        stackView.spacing = 60
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension ViewController: ContainerViewController {
    func show(viewController: UIViewController, in direction: UIPageViewController.NavigationDirection) {
        pageViewController.setViewControllers([viewController], direction: direction, animated: true)
    }
}
