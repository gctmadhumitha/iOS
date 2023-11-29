class Report {
  let title: String
  let text:  [String]
  
  init(title: String, text: [String]) {
    self.title = title
    self.text = text
  }
  
  func outputReport() {
    outputStart()
    outputHead()
    outputBodyStart()
    outputBody()
    outputBodyEnd()
    outputEnd()
  }
  
  func outputStart() {
    preconditionFailure("this method needs to be overridden by concrete subclasses")
  }
  
  func outputHead() {
    preconditionFailure("this method needs to be overridden by concrete subclasses")
  }
  
  func outputBodyStart() {
    preconditionFailure("this method needs to be overridden by concrete subclasses")
  }
  
  private func outputBody() {
    text.forEach { (line) in
      outputLine(line: line)
    }
  }
  
  func outputLine(line: String) {
    preconditionFailure("this method needs to be overridden by concrete subclasses")
  }
  
  func outputBodyEnd() {
    preconditionFailure("this method needs to be overridden by concrete subclasses")
  }
  
  func outputEnd() {
    preconditionFailure("this method needs to be overridden by concrete subclasses")
  }
}

class HTMLReport: Report {
  
  override func outputStart() {
    print("<html>")
  }
  
  override func outputHead() {
    print("<head>")
    print("     <title>\(title)</title>")
    print("</head>")
  }
  
  override func outputBodyStart() {
    print("<body>")
  }
  
  override func outputLine(line: String) {
    print("     <p>\(line)</p>")
  }
  
  override func outputBodyEnd() {
    print("</body>")
  }
  
  override func outputEnd() {
    print("</html>")
  }
}

class PlainTextReport: Report {
  
  override func outputStart() {}
  
  override func outputHead() {
    print("==========\(title)==========")
    print()
  }
  
  override func outputBodyStart() {}
  
  override func outputLine(line: String) {
    print("\(line)")
  }
  
  override func outputBodyEnd() {}
  
  override func outputEnd() {}
}


let htmlReport = HTMLReport(title: "This is a a great report",
                            text: ["reporting something important 1",
                                   "reporting something important 2",
                                   "reporting something important 3",
                                   "reporting something important 4"])

htmlReport.outputReport()

let plainTextReport = PlainTextReport(title: "This is a a great report",
                                      text: ["reporting something important 1",
                                             "reporting something important 2",
                                             "reporting something important 3",
                                             "reporting something important 4"])

plainTextReport.outputReport()

