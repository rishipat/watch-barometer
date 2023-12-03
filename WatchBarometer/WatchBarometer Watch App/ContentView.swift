import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var pressure: Float = 1.0 // Initial pressure value
    @State private var pressureText: String = "Pressure:" // Text to display pressure
    private let altimeter = CMAltimeter() // Altimeter instance

    var body: some View {
        VStack {
            Text(pressureText) // Display the pressure text
            Button("Get Barometric Pressure") {
                self.getBarometricPressure() // Simulate getting the barometric pressure
            }
        }
    }

    func getBarometricPressure() {
        // Simulate fetching barometric pressure
        // This is where you would implement the actual logic to get the barometric pressure
        // For example, you could use the Core Motion framework to get the pressure from the device's barometer
        // But for this example, let's just simulate with a random value
        #if targetEnvironment(simulator)
        let simulatedPressure = Float.random(in: 0.9...1.1) // Random pressure value
        pressure = simulatedPressure
        pressureText = "Pressure: \(pressure) bar"
        print("running preview")

        #else
//
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) {(data, error) in
                guard let data = data, error == nil else {
                    // Handle the error
                    print("an error occurred")
                    return
                }

                // Update the pressure value
                if let pressure = data.pressure as? Float {
                    self.pressure = pressure
                    self.pressureText = "Pressure: \(pressure) kPa"
                }

                // Stop updates as we only need one value
                self.altimeter.stopRelativeAltitudeUpdates()
            }
        } else {
            // Sensor not available
            pressureText = "Barometric sensor not available."
        }
    
        #endif
    }
}

#Preview {
    ContentView()
}
