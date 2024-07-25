//
//  ContentView.swift
//  BucketList
//
//  Created by Oliver Hu on 7/24/24.
//

import SwiftUI
import MapKit


struct ContentView: View {
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38, longitude: -122), span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
    )
    )
    //    @State private var isUnlocked = false
    @State private var locations = [Location]()
    @State private var selectedPlace: Location?
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "tortoise.circle.fill")
                            .resizable()
                            .foregroundStyle(.green)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture {
                                selectedPlace = location
                            }
                    }
                }
            }
                .mapStyle(.hybrid)
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        locations.append(newLocation)
                    }
                }
                .sheet(item: $selectedPlace) { place in
                    Text(place.name)
                }
        }
    }
}
//        VStack {
//            if isUnlocked {
//                Text("Unlocked")
//            } else {
//                Text("Locked")
//            }
//        }
//        .onAppear(perform: authenticate)
//        Button("Read and Write") {
//            let data = Data("Test Message".utf8)
//            let url = URL.documentsDirectory.appending(path: "message.txt")
//            
//            do {
//                try data.write(to: url, options: [.atomic, .completeFileProtection])
//                let input = try String(contentsOf: url)
//                print(input)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        // check whether biometric authentication is possible
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            // it's possible, so go ahead and use it
//            let reason = "We need to unlock your data."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                // authentication has now completed
//                if success {
//                    isUnlocked = true
//                } else {
//                    // there was a problem
//                }
//            }
//        } else {
//            // no biometrics
//        }
//    }


//extension FileManager {
//    func decode<T: Codable>(_ file: String, withExtension fileExtension: String = "json") -> T {
//        guard let url = Bundle.main.url(forResource: file, withExtension: fileExtension) else {
//            fatalError("Failed to locate \(file) in bundle.")
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load \(file) from bundle.")
//        }
//
//        let decoder = JSONDecoder()
//
//        do {
//            return try decoder.decode(T.self, from: data)
//        } catch DecodingError.keyNotFound(let key, let context) {
//            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
//        } catch DecodingError.typeMismatch(_, let context) {
//            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
//        } catch DecodingError.valueNotFound(let type, let context) {
//            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
//        } catch DecodingError.dataCorrupted(_) {
//            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
//        } catch {
//            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
//        }
//    }
//}

#Preview {
    ContentView()
}
