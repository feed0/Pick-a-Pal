//
//  ContentView.swift
//  Pick-a-Pal
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 11/01/26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var names = [String]()
    @State private var textFieldString = ""
    @State private var pickedName = ""
    @State private var shouldRemovePickedName: Bool = false
    
    @State private var alert: ContentViewAlertType? = nil
    
    private enum ContentViewAlertType: String {
        case repeatedName = "You already listed that name!"
        case emptyField = "You need to write a name first!"
        
        case noNamesToPick = "You need to add some names first!"
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            headerVStack

            if let alert = alert {
                alertText(alert.rawValue)
            }

            pickedNameText
            namesList
            addNameTextField
            Divider()
            removeNameToggle
            pickRandomNameButton
        }
        .padding(16)
    }
    
    // MARK: - ViewBuilder
    
    private var headerVStack: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.3.sequence.fill")
                .foregroundStyle(.tint)
                .symbolRenderingMode(.hierarchical)
            
            Text("Pick-a-Pal")
        }
        .font(.largeTitle)
        .bold()
    }
    
    private func alertText(_ alertString: String) -> some View {
        Text(alertString)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .opacity(0.4))
            .foregroundStyle(.red)
    }
    
    private var pickedNameText: some View {
        Text(!pickedName.isEmpty ? "Pal: \(pickedName)!" : "Pick a name!")
            .font(.title2)
            .bold()
            .foregroundStyle(.tint)
    }
    
    private var namesList: some View {
        List {
            ForEach(names, id: \.description) { name in
                Text(name)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var addNameTextField: some View {
        TextField("Add a name", text: $textFieldString)
            .autocorrectionDisabled()
            .onSubmit {
                handleAddNameTextFieldSubmit()
            }
    }
    
    private var removeNameToggle: some View {
        Toggle("Remove picked name",
               isOn: $shouldRemovePickedName)
    }
    
    private var pickRandomNameButton: some View {
        Button {
            handlePickRandomNameButton()
        } label: {
            Text("Pick a random name")
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
        }
        .buttonStyle(.borderedProminent)
        .font(.title2)
    }
    
    // MARK: - Private methods
    
    /// Appends user input String to the `names` list
    ///
    /// - Validation: IF `names` list is empty, THEN no name is added to the list
    /// - Validation: IF `$textFieldString` is already in `names` list, THEN show alert message
    private func handleAddNameTextFieldSubmit() {
        guard !textFieldString.isEmpty else {
            alert = .emptyField
            return
        }
        
        guard !names.description.lowercased().contains(textFieldString.lowercased()) else {
            alert = .repeatedName
            return
        }
        
        alert = nil
        names.append(textFieldString)
        textFieldString = ""
    }
    
    /// Validates `names` list before choosing a random name
    ///
    /// IF names list is empty, THEN a suggestion message takes place
    /// Also, IF toggle is on, all occurences (case insensitive) of the random name are removed from the `names` list
    private func handlePickRandomNameButton() {
        
        /// If `names` is empty update alertType
        guard let optionalRandomName = names.randomElement() else {
            alert = .noNamesToPick
            return
        }
        
        alert = nil
        
        /// Pick a random name
        pickedName = optionalRandomName
        
        /// Remove all occurences of that random name IF toggle is on
        if shouldRemovePickedName {
            names.removeAll { name in
                name.lowercased() == optionalRandomName.lowercased()
            }
        }
            
    }
}

#Preview {
    ContentView()
}
