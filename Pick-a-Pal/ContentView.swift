//
//  ContentView.swift
//  Pick-a-Pal
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 11/01/26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var names: [String] = ["Elisha", "Andre", "Jasmine", "Po-Chun"]
    @State private var textFieldString = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            /// List
            List {
                ForEach(names, id: \.description) { name in
                    Text(name)
                }
            }
            
            /// TextField
            TextField("Add a name", text: $textFieldString)
                .autocorrectionDisabled()
                .onSubmit {
                    addName()
                }
        }
        .padding()
    }
    
    // MARK: - Private methods
    
    private func addName() {
        guard !textFieldString.isEmpty else {
            return
        }
        names.append(textFieldString)
        textFieldString = ""
    }
}

#Preview {
    ContentView()
}
