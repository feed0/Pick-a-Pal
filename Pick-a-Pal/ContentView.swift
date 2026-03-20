//
//  ContentView.swift
//  Pick-a-Pal
//
//  Created by Felipe Eduardo Campelo Ferreira Osorio on 11/01/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \PalModel.name) private var palsList: [PalModel]
    
    @State private var alert: ContentViewAlertType? = nil
    
    @State private var pickedName = ""
    
    @State private var textFieldString = ""
    
    @State private var shouldRemovePickedName: Bool = false
    
    private enum ContentViewAlertType: String {
        // MARK: Errors
        case repeatedName = "You ALREADY listed that name!"
        case emptyField = "You need to WRITE a name first!"
        case noNamesToPick = "You need to ADD some names first!"
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
            ForEach(palsList) { pal in
                Text(pal.name)
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
    
    // MARK: Depth 1
    
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
        guard !isRepeatedName(for: trimmedString) else {
            alert = .repeatedName
            return
        }
        
        /// Reset alerts
        alert = nil
        
        /// Insert
        let newPal = PalModel(name: trimmedString)
        context.insert(newPal)
        
        /// Reset field
        textFieldString = ""
    }
    
    /// Validates `names` list before choosing a random name
    ///
    /// IF names list is empty, THEN a suggestion message takes place
    /// Also, IF toggle is on, all occurences (case insensitive) of the random name are removed from the `names` list
    private func handlePickRandomNameButton() {
        
        /// If `names` is empty update alertType
        guard let optionalRandomPal = palsList.randomElement() else {
            alert = .noNamesToPick
            pickedName = ""
            return
        }
        
        alert = nil
        
        /// Pick a random name
        pickedName = optionalRandomPal.name
        
        /// Remove all occurences of that random name IF toggle is on
        if shouldRemovePickedName {
            removeAllPals(matching: pickedName)
        }
    }
    
    // MARK: Depth 2
    
    /// Checks if a given name is already in the `palsList`
    private func isRepeatedName(for name: String) -> Bool {
        palsList.contains {
            $0.name.lowercased() == name.lowercased()
        }
    }
    
    private func removeAllPals(matching name: String) {
        
        /// Find all occurences
        let matchingPals = palsList.filter {
            $0.name.lowercased() == name.lowercased()
        }
        
        /// Delete each occurence
        for pal in matchingPals {
            context.delete(pal)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(
            for: PalModel.self,
            inMemory: true
        )
}
