import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var headsButton: UIButton!
    @IBOutlet weak var tailsButton: UIButton!
    
    var flipCount = 0
    var gameCount = 0
    var winCount = 0
    var loseCount = 0
    var isFlipping = false
    
    var coinImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...80 {
            if let image = UIImage(named: "silver_\(i)") {
                coinImages.append(image)
            } else {
                print("Error: silver_\(i) kép nem található.")
            }
        }
        if coinImages.isEmpty {
            print("Hiba: A képek listája üres!")
        }
        resetGame()
    }

    @IBAction func headsButtonTapped(_ sender: UIButton) {
        if !isFlipping {
            playGame(userGuess: 1)
        }
    }
    
    @IBAction func tailsButtonTapped(_ sender: UIButton) {
        if !isFlipping {
            playGame(userGuess: 0)
        }
    }

    func playGame(userGuess: Int) {
        if gameCount >= 5 {
            return
        }

        flipCount += 1
        flipCountLabel.text = "Fordulat: \(flipCount)"
        
        let programChoice = Int.random(in: 0...1)

        isFlipping = true
        headsButton.isEnabled = false
        tailsButton.isEnabled = false

        if programChoice == 1 {
            runFlipAnimation(totalFrames: 51, userGuess: userGuess, programChoice: programChoice)
        } else {
            runFlipAnimation(totalFrames: 41, userGuess: userGuess, programChoice: programChoice)
        }
    }
    
    func runFlipAnimation(totalFrames: Int, userGuess: Int, programChoice: Int) {
        var currentFrame = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if currentFrame < totalFrames {
                self.coinImageView.image = self.coinImages[currentFrame]
                currentFrame += 1
            } else {
                timer.invalidate()
                
                if programChoice == 1 {
                    self.coinImageView.image = self.coinImages[50]
                } else {
                    self.coinImageView.image = self.coinImages[40]
                }
                
                if userGuess == programChoice {
                    self.winCount += 1
                    self.showToast(message: "Eltaláltad!")
                } else {
                    self.loseCount += 1
                    self.showToast(message: "Nem találtad el!")
                }

                self.gameCount += 1
                if self.gameCount == 5 {
                    self.showEndGameDialog()
                }

                self.isFlipping = false
                self.headsButton.isEnabled = true
                self.tailsButton.isEnabled = true
            }
        }
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showEndGameDialog() {
        let resultMessage: String
        if winCount > loseCount {
            resultMessage = "Nyertél! Összesen \(winCount) nyertes játékod volt."
        } else {
            resultMessage = "Vesztettél! Összesen \(loseCount) vesztett játékod volt."
        }

        let alert = UIAlertController(title: "Játék vége", message: resultMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Új játék", style: .default, handler: { _ in
            self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "Kilépés", style: .cancel, handler: { _ in
            exit(0)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetGame() {
        flipCount = 0
        gameCount = 0
        winCount = 0
        loseCount = 0
        flipCountLabel.text = "Fordulat: 0"
        coinImageView.image = UIImage(named: "silver_1")
        
        headsButton.isEnabled = true
        tailsButton.isEnabled = true
    }
}

