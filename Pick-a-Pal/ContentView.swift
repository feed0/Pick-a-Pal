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
            namesList
            addNameTextField
        }
        .padding()
    }
    
    // MARK: - ViewBuilder
    
    private var namesList: some View {
        List {
            ForEach(names, id: \.description) { name in
                Text(name)
            }
        }
    }
    
    private var addNameTextField: some View {
        TextField("Add a name", text: $textFieldString)
            .autocorrectionDisabled()
            .onSubmit {
                addName()
            }
    }
    
    // MARK: - Private methods
    
    /// Appends user input String to the names list
    ///
    /// Validation: it must not be empty
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
