import UIKit

class ViewController: UIViewController {
    
    
    enum FontStyle {
        case normal
        case italic
    }
    let string = "Hello, World of Swift!"
    
    var attributedText: NSMutableAttributedString!
    
    var atributes: [NSAttributedString.Key: Any] = [:]
    
    var fontSize = 16 {
        didSet {
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize)), range: NSMakeRange(0, string.count))
            label.attributedText = attributedText
        }
    }
    
    var fontStyle: FontStyle = FontStyle.normal {
        didSet {
            if(fontStyle == FontStyle.normal) {
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize)), range: NSMakeRange(0, string.count))
            } else {
                attributedText.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: CGFloat(fontSize)), range: NSMakeRange(0, string.count))
            }
            
            label.attributedText = attributedText
        }
    }
    
    var label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    var updateButton = {
        let updateButton = UIButton()
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setTitle("Update attributes", for: .normal)
        updateButton.layer.cornerRadius = 8
        updateButton.backgroundColor = .systemBlue
        return updateButton
    }()
    
    var resetButton = {
        let updateButton = UIButton()
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setTitle("Reset attributes", for: .normal)
        updateButton.layer.cornerRadius = 8
        updateButton.backgroundColor = .systemBlue
        return updateButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel()
        setupUpdateButton()
        setupResetButton()
        attributedText = NSMutableAttributedString(string: string)
        label.attributedText = attributedText
        
        addFontSizeControl()
        addFontStyleControl()
    }
    
    
    private func generateAtrribute() {
        atributes = [
            .foregroundColor: UIColor.random(),
            .font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        
        attributedText = NSMutableAttributedString(string: string)
        
        atributes.keys.forEach { key in
            attributedText.addAttribute(key, value: atributes[key] as Any, range: NSRange(location: 0, length:Int.random(in: 1..<string.count) ))
        }
        self.label.font = fontStyle == FontStyle.normal ? .systemFont(ofSize: CGFloat(self.fontSize)) : .italicSystemFont(ofSize: CGFloat(self.fontSize))
        label.attributedText = attributedText
    }
    
    private func setupLabel() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupUpdateButton() {
        view.addSubview(updateButton)
        
        NSLayoutConstraint.activate([
            updateButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 70),
            updateButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        let updateButtonAction = UIAction {_ in
            self.generateAtrribute()
        }
        
        updateButton.addAction(updateButtonAction, for: .touchUpInside)
    }
    
    func addFontSizeControl() {
        let stackView = UIStackView()
        let label = {
            let label = UILabel()
            label.text = "Font Size: "
            return label
        }()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let segmentItems = ["Small", "Medium",  "Large"]
        let control = UISegmentedControl(items: segmentItems)
        control.addTarget(self, action: #selector(onFontSizeSegmenControlValueChanged), for: .valueChanged)
        control.selectedSegmentIndex = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(control)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20)
        ])
    }
    
    func addFontStyleControl() {
        let stackView = UIStackView()
        let label = {
            let label = UILabel()
            label.text = "Font Style: "
            return label
        }()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let segmentItems = ["Normal", "Italic"]
        let control = UISegmentedControl(items: segmentItems)
        control.addTarget(self, action: #selector(onFontStyleSegmenControlValueChanged), for: .valueChanged)
        control.selectedSegmentIndex = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(control)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 120),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20)
        ])
    }
    
    private func setupResetButton() {
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 70),
            resetButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        let resetButtonAction = UIAction {_ in
            if self.atributes.isEmpty {return}
            self.atributes.keys.forEach { key in
                self.attributedText.removeAttribute(key , range:NSMakeRange(0, self.string.count))
            }
            self.atributes = [:]
            self.label.attributedText =  self.attributedText
            self.label.font = .systemFont(ofSize: CGFloat(self.fontSize))
            
        }
        
        resetButton.addAction(resetButtonAction, for: .touchUpInside)
    }
    
    @objc func onFontSizeSegmenControlValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fontSize = 16
        case 1:
            fontSize = 20
            
        case 2:
            fontSize = 24
        default:
            print("Out of range")
        }
    }
    
    @objc func onFontStyleSegmenControlValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fontStyle = FontStyle.normal
        case 1:
            fontStyle = FontStyle.italic
        default:
            print("Out of range")
        }
    }
}
