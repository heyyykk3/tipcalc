import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!   // Bill Amount Input
    @IBOutlet weak var tipTextField: UITextField!      // Displays calculated tip
    @IBOutlet weak var totalTextField: UITextField!    // Displays Final Total
    @IBOutlet weak var manualTipTextField: UITextField! // Manual Tip Input
    @IBOutlet weak var perPersonAmountTextField: UITextField! // Shows Amount Per Person

    // Stepper for Splitting the Bill
    @IBOutlet weak var splitLabel: UILabel!            // Displays Split count
    @IBOutlet weak var splitStepper: UIStepper!        // Stepper to change split count

    // Slider for Custom Tip
    @IBOutlet weak var tipPercentageLabel: UILabel!    // Shows only slider tip percentage
    @IBOutlet weak var tipSlider: UISlider!            // Custom Tip Slider

    var selectedTipPercentage: Double? = nil  // Keeps track of button tip percentage

    override func viewDidLoad() {
        super.viewDidLoad()
        resetValues()
    }

    // Reset Default Values
    func resetValues() {
        tipSlider.minimumValue = 1
        tipSlider.maximumValue = 100
        tipSlider.value = 10
        tipPercentageLabel.text = "Tip: 10%"
        splitStepper.value = 1
        splitLabel.text = "Split: 1 Person"
        manualTipTextField.text = ""
        tipTextField.text = ""
        totalTextField.text = ""
        perPersonAmountTextField.text = ""
        selectedTipPercentage = nil
        calculateTotal()
    }

    // Calculate Total Amount
    func calculateTotal() {
        guard let billAmount = Double(amountTextField.text ?? "0"), billAmount > 0 else {
            totalTextField.text = "0.00"
            perPersonAmountTextField.text = "0.00"
            return
        }

        let manualTipAmount = Double(manualTipTextField.text ?? "0") ?? 0
        let buttonTipAmount = selectedTipPercentage != nil ? billAmount * (selectedTipPercentage! / 100) : 0
        let sliderTipAmount = selectedTipPercentage == nil ? Double(tipSlider.value) / 100 * billAmount : 0

        let tipAmount = max(manualTipAmount, buttonTipAmount, sliderTipAmount)
        let splitCount = Int(splitStepper.value)
        let totalAmount = billAmount + tipAmount
        let perPersonAmount = totalAmount / Double(splitCount)

        tipTextField.text = String(format: "%.2f", tipAmount)
        totalTextField.text = String(format: "%.2f", totalAmount)
        perPersonAmountTextField.text = String(format: "%.2f", perPersonAmount)
    }

    // Tip Percentage Buttons (10%, 15%, 20%) - Works only once per selection
    @IBAction func tipButtonTapped(_ sender: UIButton) {
        guard let billAmount = Double(amountTextField.text ?? "0"), billAmount > 0 else { return }

        if let tipValue = sender.titleLabel?.text?.dropLast(), let tipPercent = Double(tipValue) {
            selectedTipPercentage = tipPercent  // Store selected tip percentage
            manualTipTextField.text = ""  // Reset manual input
            tipSlider.value = 10  // Reset slider to 10%
            tipPercentageLabel.text = "Tip: 10%"  // Reset slider label
            calculateTotal()
        }
    }

    // Custom Tip Slider Action - Updates Tip Percentage Label & Resets Other Methods
    @IBAction func tipSliderChanged(_ sender: UISlider) {
        let tipPercent = Int(sender.value)
        tipPercentageLabel.text = "Tip: \(tipPercent)%"
        
        // Reset other methods
        selectedTipPercentage = nil
        manualTipTextField.text = ""

        calculateTotal()
    }

    // Manual Tip Entry - Updates Total Immediately
    @IBAction func manualTipEntered(_ sender: UITextField) {
        selectedTipPercentage = nil  // Reset button selection
        tipSlider.value = 10  // Reset slider to default
        tipPercentageLabel.text = "Tip: 10%"  // Reset slider label
        calculateTotal()
    }

    // Split Bill Stepper Action - Updates Split and Per Person Amount
    @IBAction func splitStepperChanged(_ sender: UIStepper) {
        let splitValue = Int(sender.value)
        splitLabel.text = "Split: \(splitValue) People"
        calculateTotal()
    }

    // Dismiss Keyboard on Tap
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

