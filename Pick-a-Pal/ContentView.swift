//
//  ContentView.swift
//  Pick-a-Pal
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 11/01/26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var names: [String] = []
    @State private var textFieldString = ""
    @State private var pickedName = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            pickedNameText
            namesList
            addNameTextField
            Divider()
            pickRandomNameButton
        }
        .padding()
    }
    
    // MARK: - ViewBuilder
    
    private var pickedNameText: some View {
        Text(
            !pickedName.isEmpty ? pickedName : "Pick a name!"
        )
    }
    
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

    private var pickRandomNameButton: some View {
        Button("Pick a random name") {
            handlePickRandomNameButton()
        }
    }
    
    // MARK: - Private methods
    
    /// Appends user input String to the `names` list
    ///
    /// Validation: IF `names` list is empty, THEN no name is added to the list
    private func addName() {
        guard !textFieldString.isEmpty else {
            return
        }
        names.append(textFieldString)
        textFieldString = ""
    }
    
    /// Validates `names` list before choosing a random name
    ///
    /// IF names list is empty, THEN a suggestion message takes place
    private func handlePickRandomNameButton() {
        if let optionalRandomName = names.randomElement() {
            pickedName = optionalRandomName
        } else {
            pickedName = "Empty names list! You can ADD SOME NAMES down there."
        }
    }
}

#Preview {
    ContentView()
}
