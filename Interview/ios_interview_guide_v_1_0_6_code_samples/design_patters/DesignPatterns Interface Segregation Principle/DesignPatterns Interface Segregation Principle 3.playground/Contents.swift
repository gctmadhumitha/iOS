protocol WorkableInterface {
  func work()
}

protocol FeedableInterface {
  func eat()
}

class Worker: WorkableInterface, FeedableInterface {
  func eat() {
    print("worker's eating lunch")
  }
  
  func work() {
    print("worker's working")
  }
}

class Contractor: WorkableInterface, FeedableInterface {
  
  func eat() {
    print("contractor's eating lunch")
  }
  
  func work() {
    print("contractor's working")
  }
}

class Robot: WorkableInterface {  
  func work() {
    print("robot's working")
  }
}


class Manager {
  
  private let workers: [WorkableInterface]
  
  init(workers: [WorkableInterface]) {
    self.workers = workers
  }
  
  func manage() {
    workers.forEach { (worker: WorkableInterface) in
      worker.work()
    }
  }
}

let worker1 = Worker()
let worker2 = Worker()
let contractor = Contractor()
let robot = Robot()

let manager = Manager(workers: [worker1, worker2, contractor, robot])

manager.manage()

