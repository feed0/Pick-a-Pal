//
//  ContentView.swift
//  Pick-a-Pal
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 11/01/26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var alert: ContentViewAlertType? = nil
    
    @State private var pickedName = ""
    
    @State private var currentNamesList = [String]()
    @State private var savedNamesList = [String]()
    
    @State private var textFieldString = ""
    
    @State private var shouldRemovePickedName: Bool = false
    
    private enum ContentViewAlertType: String {
        // MARK: Errors
        case repeatedName = "You ALREADY listed that name!"
        case emptyField = "You need to WRITE a name first!"
        
        case noNamesToPick = "You need to ADD some names first!"
        
        case savingEmptyList = "You are trying to SAVE an empty list!"
        case loadingEmptyList = "You are trying to LOAD an empty list!"
        
        // MARK: Updates
        case listSaved = "Your list has been SAVED!"
        case listLoaded = "Your list has been LOADED!"
    }
        
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            headerVStack

            if let alert = alert {
                alertText(alert)
            }

            pickedNameText
            namesList
            addNameTextField
            Divider()
            removeNameToggle
            pickRandomNameButton
            
            HStack {
                saveNamesListButton
                loadNamesListButton
            }
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
    
    @ViewBuilder
    private func alertText(_ alert: ContentViewAlertType) -> some View {
        let foregroundColour: Color = switch alert {
            case .listLoaded, .listSaved:
                .blue
            default:
                .red
        }
        
        Text(alert.rawValue)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .opacity(0.4))
            .foregroundStyle(foregroundColour)
    }
    
    private var pickedNameText: some View {
        Text(!pickedName.isEmpty ? "Pal: '\(pickedName)'!" : "Pick a name!")
            .font(.title2)
            .bold()
            .foregroundStyle(.tint)
    }
    
    private var namesList: some View {
        List {
            ForEach(currentNamesList, id: \.description) { name in
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
    
    private var saveNamesListButton: some View {
        Button("Save names") {
            handleSaveNamesListButton()
        }
        .buttonStyle(.bordered)
    }
    
    private var loadNamesListButton: some View {
        Button("Load names") {
            handleLoadNamesListButton()
        }
        .buttonStyle(.bordered)
        
    }
    
    // MARK: - Private methods
    
    /// Appends user input String to the `names` list
    ///
    /// - Validation: IF `names` list is empty, THEN no name is added to the list
    /// - Validation: IF `$textFieldString` is already in `names` list, THEN show alert message
    private func handleAddNameTextFieldSubmit() {
        
        /// Trim
        let trimmedString = textFieldString.trimmingCharacters(in: .whitespacesAndNewlines)

        /// Empty string alert
        guard !trimmedString.isEmpty else {
            alert = .emptyField
            return
        }
        
        /// Repeated name alert
        guard !currentNamesList.description.lowercased().contains(trimmedString.lowercased()) else {
            alert = .repeatedName
            return
        }
        
        /// Reset alerts
        alert = nil
        
        /// Append
        currentNamesList.append(trimmedString)
        
        /// Reset field
        textFieldString = ""
    }
    
    /// Validates `names` list before choosing a random name
    ///
    /// IF names list is empty, THEN a suggestion message takes place
    /// Also, IF toggle is on, all occurences (case insensitive) of the random name are removed from the `names` list
    private func handlePickRandomNameButton() {
        
        /// If `names` is empty update alertType
        guard let optionalRandomName = currentNamesList.randomElement() else {
            alert = .noNamesToPick
            return
        }
        
        alert = nil
        
        /// Pick a random name
        pickedName = optionalRandomName
        
        /// Remove all occurences of that random name IF toggle is on
        if shouldRemovePickedName {
            currentNamesList.removeAll { name in
                name.lowercased() == optionalRandomName.lowercased()
            }
        }
    }
    
    /// Saves the `currentNamesList` in `savedNamesList`
    ///
    /// IF `currentNamesList` is empty, THEN updates alert to an error
    private func handleSaveNamesListButton() {
        
        /// Empty saved names list
        guard !currentNamesList.isEmpty  else {
            alert = .savingEmptyList
            return
        }
        
        savedNamesList = currentNamesList
        
        alert = .listSaved
    }
    
    /// Loads the `savedNamesList` into the `currentdNamesList`
    ///
    /// IF `savedNamesList` is empty, THEN updates alert to an error
    private func handleLoadNamesListButton() {
        
        /// Empty saved names list
        guard !savedNamesList.isEmpty  else {
            alert = .loadingEmptyList
            return
        }
        
        currentNamesList = savedNamesList
        
        alert = .listSaved
    }
}

#Preview {
    ContentView()
}
