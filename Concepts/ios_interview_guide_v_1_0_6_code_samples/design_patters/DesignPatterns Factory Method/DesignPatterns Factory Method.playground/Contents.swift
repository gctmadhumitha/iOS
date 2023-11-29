protocol WorkableInterface {
  func work()
}

class Worker: WorkableInterface {
  func work() {
    print("worker's working")
  }
}

class Contractor: WorkableInterface {
  func work() {
    print("contractor's working")
  }
}

class Robot: WorkableInterface {
  func work() {
    print("robot's working")
  }
}

enum WorkerType {
  case worker, contractor, robot
}

class TrainingAndPreparationCenter {
  func workerableUnit(_ workerType: WorkerType) -> WorkableInterface {
    switch workerType {
    case .contractor:
      return Contractor()
    case .robot:
      return Robot()
    default:
      return Worker()
    }
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

let trainingAndPreparationCenter = TrainingAndPreparationCenter()

let worker1 = trainingAndPreparationCenter.workerableUnit(.worker)
let worker2 = trainingAndPreparationCenter.workerableUnit(.worker)
let contractor = trainingAndPreparationCenter.workerableUnit(.contractor)
let robot = trainingAndPreparationCenter.workerableUnit(.robot)

let manager = Manager(workers: [worker1, worker2, contractor, robot])
manager.manage()
