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
    @State private var shouldRemovePickedName: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            pickedNameText
            namesList
            addNameTextField
            Divider()
            removeNameToggle
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

    private var removeNameToggle: some View {
        Toggle("Remove picked name",
               isOn: $shouldRemovePickedName)
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
    /// Also, IF toggle is on, all occurences (case insensitive) of the random name are removed from the `names` list
    private func handlePickRandomNameButton() {
        if let optionalRandomName = names.randomElement() {
            
            /// Pick a random name
            pickedName = optionalRandomName
            
            /// Remove all occurences of that random name IF toggle is on
            if shouldRemovePickedName {
                names.removeAll { name in
                    name.lowercased() == optionalRandomName.lowercased()
                }
            }
            
        } else {
            pickedName = "Empty names list! You can ADD SOME NAMES down there."
        }
    }
}

#Preview {
    ContentView()
}
