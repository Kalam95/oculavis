//
//  TaskViewController.swift
//  Task1
//
//  Created by Moritz Werner on 10.06.21.
//

import UIKit

class TaskViewController: UIViewController {
    var taskName: String!
    
    @IBOutlet var stackQuestionAnswer: UIStackView!
    @IBOutlet var stackWebsocketEcho: UIStackView!
//    @IBOutlet var viewContent: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelQuestion: UILabel!
    @IBOutlet var labelAnswer: UILabel!
    @IBOutlet var buttonConnect: UIButton!
    @IBOutlet var buttonDisconnect: UIButton!
    @IBOutlet var textfieldInput: UITextField!
    @IBOutlet var buttonSend: UIButton!
    @IBOutlet var labelMessage: UILabel!
    
    private var question: Question?
    private var answer: Answer?
    private let queue = OperationQueue()
    private var session: URLSession?
    private var websocketTask: URLSessionWebSocketTask?
    private let imageURL = URL(string: "https://www.wired.com/images_blogs/wiredscience/2012/01/bluemarble.jpg")!
    private let request: URLRequest = {
        var request = URLRequest(url: URL(string: "ws://echo.websocket.org")!)
        request.timeoutInterval = 10
        return request
    }()
    private var wsDelegate: WebSocketDelegate?

    deinit {
        disconnect()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldInput.delegate = self
        navigationItem.title = taskName!
        setButtonStates(isEnabled: false)
    }

    @IBAction func onSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            stackQuestionAnswer.isHidden = false
            stackWebsocketEcho.isHidden = true
            
            updateQuestionAnswer()
        } else {
            stackQuestionAnswer.isHidden = true
            stackWebsocketEcho.isHidden = false
            
            question = nil
            answer = nil
        }
        labelQuestion.text = question?.text
        labelAnswer.text = answer?.text
    }
    
    
    private func updateQuestionAnswer() {
        question = Question(text: "How are you?")
        answer = Answer(text: "I'm fine, how about you?")
        if let answer = answer {
            question?.answers.append(answer)
        }
        downloadImage()
    }

    private func downloadImage() {
        let queue = DispatchQueue(label: "ImageFetcher")
        queue.async { [weak self] in
            guard let self = self else { return }
            let data = try? Data(contentsOf: self.imageURL)
            DispatchQueue.main.async { [weak self] in
                if let data = data {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }

    @IBAction func onConnectTapped(_ sender: UIButton) {
        connect()
    }

    @IBAction func onDisconnectTapped(_ sender: UIButton) {
        disconnect()
    }

    @IBAction func onSendTapped(_ sender: UIButton) {
        if let text = textfieldInput.attributedText {
            view.endEditing(true)
            DispatchQueue.main.async { [weak self] in
                self?.sendMessage(text: text.string)
            }
        }
    }

    func connect() {
        wsDelegate = WebSocketDelegate()
        wsDelegate?.delegate = self
        session = URLSession(configuration: .default, delegate: wsDelegate, delegateQueue: queue)
        websocketTask = session?.webSocketTask(with: request)
        websocketTask?.resume()
    }

    func disconnect() {
        wsDelegate = nil
        websocketTask?.cancel(with: .goingAway, reason: nil)
        websocketTask = nil
        session = nil
    }

    func setButtonStates(isEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.buttonConnect.isEnabled = !isEnabled
            self?.buttonDisconnect.isEnabled = isEnabled
            self?.buttonSend.isEnabled = isEnabled
        }
    }

    func handleSendError(error: Error?) {
        if let error = error {
            print(error)
        }
    }

    func handleReceiveError(error: Error?) {
        if let error = error {
            print(error)
        }
    }

    func handleText(message: String) {
        labelMessage.text = message
    }

    func listenForMessages() {
        websocketTask?.receive(completionHandler: { [weak self] result in
            DispatchQueue.main.async {[weak self] in
                self?.onMessageReceived(result: result)
            }
        })
    }

    func sendMessage(text: String) {
        websocketTask?.send(.string(text), completionHandler: { [weak self] error in
            self?.handleSendError(error: error)
        })
    }

    func onMessageReceived(result: Result<URLSessionWebSocketTask.Message, Error>) {
        switch result {
        case .failure(let error):
            handleReceiveError(error: error)
        case .success(let message):
            switch message {
            case .string(let text):
                handleText(message: text)
            default:
                fatalError("Received unknown WebSocket message")
            }
        }
//
//        listenForMessages()
    }
}

extension TaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TaskViewController: Delegate {
    func conectionOpened() {
        setButtonStates(isEnabled: true)
        listenForMessages()
    }
    
    func connectionClosed() {
        setButtonStates(isEnabled: false)
        labelMessage.text = nil
    }
}

protocol Delegate: AnyObject {
    func connectionOpened()
    func connectionClosed()
}

class WebSocketDelegate: NSObject, URLSessionWebSocketDelegate {
    weak var delegate: Delegate?
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        delegate?.connectionOpened()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        DispatchQueue.main.async {[weak self] in
            self?.delegate?.connectionClosed()
        }
    }
}

struct Answer {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}

struct Question {
    let text: String
    var answers: [Answer] = []
    
    init(text: String) {
        self.text = text
    }
}
