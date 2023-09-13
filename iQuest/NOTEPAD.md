
    private func setUpTabs(){
       
        //Tab 1
        let triviaVC = self.createNav(with: "Trivia", and: UIImage(systemName:  "circle"), vc: TriviaViewController())
        
        //Tab 2
        let layout = UICollectionViewFlowLayout()
        let factsVC = self.createNav(with: "Facts", and: UIImage(systemName:  "circle"), vc: FactsViewController(collectionViewLayout: layout))
        
        let chatgptVC = self.createNav(with: "Chat GPT", and: UIImage(systemName:  "circle"), vc: UIHostingController(rootView:ChatView()))
        
        self.viewControllers = [triviaVC, factsVC, chatgptVC]

    }


    private func createNav(with title: String, and image: UIImage?, vc:UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image

        return nav
    }
   

    func card() async   {
        Task { () -> SwipeCardView in
            let card = SwipeCardView()
            let response = await APIService().fetchFact()
            guard let fact = response.fact  else {
                print("Error Message is \(response.error)")
                return card
            }
            card.dataSource = FactDataModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: fact.text)
            print("fact is \(fact)")
            return card
        }
    }
