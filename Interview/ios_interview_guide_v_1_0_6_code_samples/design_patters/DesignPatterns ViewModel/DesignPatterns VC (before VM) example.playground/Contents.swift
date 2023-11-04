import UIKit

class MyViewController: UIViewController {
  
  private let someButton: UIButton
  
  private let buttonTitle: String
  
  init(buttonTitle: String) {
    self.buttonTitle = buttonTitle
    someButton = UIButton()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupButton(title: self.buttonTitle)
  }
  
  private func setupButton(title: String) {
    someButton.setTitle(title, for: .normal)
    someButton.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
  }
  
  @objc func buttonClick(sender: AnyObject) {
    // let's assume there's some business logic happening here
    print("there's an action here that relies on the state of your application")
    print("such as button title - for example, \(buttonTitle)")
  }
}

// creating a new instance of our VC
let myVC = MyViewController(buttonTitle: "some button title")
// simulating our VC's appearance on the screen
myVC.view

// simulating the user clicking our button
myVC.buttonClick(sender: NSObject())


// output:
// there's an action here that relies on the state of your application
// such as button title - for example, some button title
