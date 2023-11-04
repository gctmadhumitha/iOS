protocol WorkerInterface {
  func eat()
  func work()
}

class Worker: WorkerInterface {
  func eat() {
    print("worker's eating lunch")
  }
  
  func work() {
    print("worker's working")
  }
}

class Contractor: WorkerInterface {
  func eat() {
    print("contractor's eating lunch")
  }
  
  func work() {
    print("contractor's working")
  }
}

class Robot: WorkerInterface {  
  // do nothing here. cuz robots don't eat.
  func eat() {}
  
  func work() {
    print("robot's working")
  }
}


class Manager {
  
  private let workers: [WorkerInterface]
  
  init(workers: [WorkerInterface]) {
    self.workers = workers
  }
  
  func manage() {
    workers.forEach { (worker: WorkerInterface) in
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

