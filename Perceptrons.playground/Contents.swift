import Foundation

struct Perceptron {
    
    // MARK: - Stored Properties
    
    var weights: [Double]
    var bias: Double
    
    // MARK: - Lifecycle
    
    /// Create a new perceptron with n inputs. Weights and bias are initialized with random values between -1 and 1.
    init(numberOfInputs: Int) {
        let lowerBound: Double = -1.0
        let upperBound: Double = 1.0
        
        self.weights = (1...numberOfInputs).map({ _ in
            Double.random(lower: lowerBound, upper: upperBound)
        })
        
        self.bias = Double.random(lower: lowerBound, upper: upperBound)
    }
    
    // MARK: - Processing / Learning
    
    /// Heaviside Step function: Returns 0 if input is less than zero OR 1 if input is zero or more.
    func heaviside(input: Double) -> Int {
        return (input < 0) ? 0 : 1
    }
    
    /**
     Core functionality of the perceptron:
     
     1. Weigh the input signals.
     2. Sum them up.
     3. Add the bias.
     4. Run result through the Heaviside Step function.
     
     - Note: The return value could be a boolean but is an int32 instead, so that we can directly use the value for adjusting the perceptron.
     */
    func process(inputs: [Int]) -> Int {
        let weightedInputs = inputs.enumerated().map { (offset: Int, input: Int) -> Double in
            return Double(input) * self.weights[offset]
        }
        
        let sum = weightedInputs.reduce(self.bias) { (previousResult, weightedInput) -> Double in
            return previousResult + weightedInput
        }
        
        return self.heaviside(input: sum)
    }
    
    
    /// Adjust the weights and the bias based on how much the perceptron’s answer differs from the correct answer.
    mutating
    func adjust(inputs: [Int], delta: Int, learningRate: Double) {
        // Adjust Weights.
        inputs.enumerated().forEach { (offset: Int, input: Int) in
            self.weights[offset] += Double(input) * Double(delta) * learningRate
        }
        
        // Adjust Bias.
        self.bias += Double(delta) * learningRate
    }
}

struct ArtificialNeuralNetwork {
    
    // MARK: - Stored Properties
    
    // `a` and `b` specify the linear function that describes the separation line.
    let a: Int
    let b: Int
    
    var perceptron: Perceptron
    
    // MARK: - Lifecycle
    
    init(a: Int, b: Int, perceptron: Perceptron) {
        self.a = a
        self.b = b
        
        self.perceptron = perceptron
    }
    
    // MARK: - Cool learning stuff
    
    /// Function describing the separation line.
    func f(x: Int) -> Int {
        return a*x + b
    }
    
    /// Acts as the "solution manual" by returning 1 if the point (x,y) is above the line y = ax + b, or 0 if below the line.
    func isAboveLine(inputs: [Int]) -> Int {
        let x = inputs[0]
        let y = inputs[1]
        
        if y > f(x: x) {
            // Above the line.
            return 1
        } else {
            // On or below the line.
            return 0
        }
    }
    
    /**
     Acts as the "teacher" by:
     
     1. Generating random test points,
     2. Feeding them to the perceptron,
     3. Comparing the answer against the "solution manual",
     4. Telling the perceptron how far it is off.
     */
    mutating
    func train(numberOfIterations: Int, learningRate: Double) {
        for _ in 1...numberOfIterations {
            
            // Generate random test point.
            let inputs = [
                Int.random(in: -100...100), // x
                Int.random(in: -100...100)  // y
            ]
            
            // Feed to perceptron.
            let actual = self.perceptron.process(inputs: inputs)
            
            // Compare against "solution manual".
            let expected = self.isAboveLine(inputs: inputs)
            let delta = expected - actual
            
            // Tell perceptron how far off so it can adjust.
            self.perceptron.adjust(inputs: inputs, delta: delta, learningRate: learningRate)
        }
    }
    
    func verify() -> Int {
        // TODO: Add draw code.
        
        var correctAnswers = 0
        
        for _ in 1...100 {
            
            // Generate random inputs.
            let inputs = [
                Int.random(in: -100...100), // x
                Int.random(in: -100...100)  // y
            ]
            
            // Feed perceptron and evaluate result.
            let result = self.perceptron.process(inputs: inputs)
            if result == self.isAboveLine(inputs: inputs) {
                correctAnswers += 1
            }
        }
        
        return correctAnswers
    }
}

// Create the network.
var artificialNeuralNetwork = ArtificialNeuralNetwork(
    a: Int.random(lower: -5, upper: 5),
    b: Int.random(lower: -50, upper: 50),
    perceptron: Perceptron(numberOfInputs: 2)
)

// Train the network. Try changing `numberOfIterations` and `learningRate`.
artificialNeuralNetwork.train(
    numberOfIterations: 1,
    learningRate: 0.1 // Allowed range: 0 < learningRate <= 1.
)


// Measure the accuracy of the network.
for iteration in 1...100 {
    let successRate: Int
    
    // Set the first result to 0 and last to 100 to give graph scale.
    switch iteration {
    case 1:
        successRate = 0
    case 100:
        successRate = 100
    default:
        successRate = artificialNeuralNetwork.verify()
    }
    
    successRate
}
