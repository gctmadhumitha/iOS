import UIKit

class MyViewModel {
  
  let title: String
  
  init(title: String) {
    self.title = title
  }
  
  func printAction() {
    print("executing business logic")
    print("printing button title: \(title)")
  }
}

class MyViewController: UIViewController {
  
  private let viewModel: MyViewModel
  
  private let someButton: UIButton
  
  init(viewModel: MyViewModel) {
    self.viewModel = viewModel
    someButton = UIButton()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupButton(title: viewModel.title)
  }
  
  private func setupButton(title: String) {
    someButton.setTitle(title, for: .normal)
    someButton.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
  }
  
  @objc func buttonClick(sender: AnyObject) {
    // trigger business logic here
    viewModel.printAction()
  }
}

// creating an instance of MyViewModel to keep track of state
// and to execute business logic
let myViewModel = MyViewModel(title: "some button title")

// creating a new instance of our VC and injecting our viewmodel
let myVC = MyViewController(viewModel: myViewModel)
// simulating our VC's appearance on the screen
myVC.view

// simulating the user clicking our button
myVC.buttonClick(sender: NSObject())


// output:
// executing business logic
// printing button title: some button title
