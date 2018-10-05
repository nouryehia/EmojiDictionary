/* Emoji.swift
   EmojiDictionary
   Creates a dictionary of emojis, allowing the user to add, remove, or edit items.
   Created by Nour Yehia on 8/14/18.
   Copyright © 2018 Nour Yehia. All rights reserved. */

import Foundation

class Emoji: Codable {
    
    // Declare the variables that make up an emoji.
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    // Create file path to write data to file.
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("emojis").appendingPathExtension("plist")
    
    // Initializer.
    init(symbol: String, name: String, description: String, usage: String) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
    
    // Saves data to acces it even after the app is closed.
    static func saveToFile(_ emojis: [[Emoji]]) {
        let encoder = PropertyListEncoder()
        let encodedEmojis = try? encoder.encode(emojis)
        try? encodedEmojis?.write(to: archiveURL, options: .noFileProtection)
    }
    
    // Loads previously saved data once the file is open.
    static func loadFromFile() -> [[Emoji]]?  {
        guard let codedEmojis = try? Data(contentsOf: archiveURL) else {return nil}
        let decoder = PropertyListDecoder()
        return try? decoder.decode([[Emoji]].self, from: codedEmojis)
    }
    
    // Loads the default emoji that exist without the user making any edits. Emojis are divided into categories.
    static func loadSampleEmojis() -> [[Emoji]] {
        return [[Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
            Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
            Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
            Emoji(symbol: "😭", name: "Crying Face", description: "A smiley face with with tears.", usage: "sadness; disappointment"),
            Emoji(symbol: "👮", name: "Police Officer", description: "A police officer wearing a blue cap with a gold badge.", usage: "person of authority")],
           [Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "Something slow"),
            Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
            Emoji(symbol: "🐍", name: "Snake", description: "A green snake.", usage: "Untrustworthy person")],
           [Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
            Emoji(symbol: "🎂", name: "Birthday Cake", description: "A birthday cake.", usage: "birthday; celebration")],
           [Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
            Emoji(symbol: "🎾", name: "Tennis Ball", description: "A tennis ball.", usage: "tennis"),
            Emoji(symbol: "⚽️", name: "Soccer Ball", description: "A soccer ball.", usage: "soccer")],
           [Emoji(symbol: "📱", name: "Phone", description: "an iPhone.", usage: "phone call, check phone"),
            Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying")],
           [Emoji(symbol: "❤️", name: "Red Heart", description: "A red heart.", usage: "extreme love"),
            Emoji(symbol: "💛", name: "Yellow Heart", description: "A yellow heart.", usage: "light love"),
            Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness")],
           [Emoji(symbol: "🇫🇷", name: "French Flag", description: "A French flag.", usage: "France; world cup"),
            Emoji(symbol: "🇪🇬", name: "Egyptian Flag", description: "An Egyptian flag.", usage: "Egypt; Mohamed Salah"),
            Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")]]
    }
}
