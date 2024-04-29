//
//  Edit.swift
//  Macro
//
//  Created by Reema Alsmari on 29/04/2024.
//

import Foundation
import SwiftUI
import UIKit

struct FontPickerView: View {
    // Array of font names
    let fontNames = UIFont.familyNames.sorted()

    // State variable to track the selected font
    @Binding var selectedFont: String
    @Binding var isPickerVisible: Bool

    var body: some View {
        VStack {
            // Picker to select font
            Picker(selection: $selectedFont, label: Text("Font")) {
                ForEach(fontNames, id: \.self) { fontName in
                    Text(fontName).font(.custom(fontName, size: 20))
                }
            }
            .pickerStyle(WheelPickerStyle()) // Use any picker style you prefer
            
            // Button to close the font picker
            Button("Done") {
                isPickerVisible = false
            }
        }
        .padding()
    }
}

struct ContentView: View {
    @State private var selectedFont = "Helvetica"
    @State private var isPickerVisible = false
    @State private var userText = ""

    var body: some View {
        VStack {
            // Button to trigger font picker
            Button(action: {
                isPickerVisible = true
            }) {
                Text("Select Font")
            }
            .padding()

            // Text field for user to enter their own text
            CustomTextField(font: UIFont(name: selectedFont, size: 20), text: $userText, prompt: "What would you like to say...?")
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Optionally, display the selected font name
            Text("Selected Font: \(selectedFont)")
            

        }
        .sheet(isPresented: $isPickerVisible, content: {
            FontPickerView(selectedFont: $selectedFont, isPickerVisible: $isPickerVisible)
        })
    }
}
struct CustomTextField: UIViewRepresentable {
    var font: UIFont?
    @Binding var text: String
    var prompt: String // Prompt text

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.font = font
        textField.delegate = context.coordinator
        textField.text = text
        textField.placeholder = prompt // Set the prompt text
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.font = font
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ textField: CustomTextField) {
            self.parent = textField
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let font = parent.font {
                let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
                let attributedText = NSAttributedString(string: newText, attributes: [.font: font])
                textField.attributedText = attributedText
                
                // Update parent text
                parent.text = newText
            }
            return false
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
