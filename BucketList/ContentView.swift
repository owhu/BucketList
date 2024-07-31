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
@State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "binoculars.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapViewStandard ? .standard : .hybrid)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        Text(place.name)
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
                
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.mapViewStandard.toggle()
                        } label: {
                            Image(systemName: "map.fill")
                                .frame(width: 15, height: 15)
                                .padding(10)
                                .foregroundStyle(.gray)
                                .background {
                                    Color.white
                                        .cornerRadius(5.0)
                                        .shadow(color: .gray, radius:40, x: 0.0, y: 0.0)
                                }
                        }
                    }
                    
                    Spacer()
                }
                
                
                
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication failed", isPresented: $viewModel.showingAlert) {
                    Button("OK", role: .cancel) {
                        
                    }
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
