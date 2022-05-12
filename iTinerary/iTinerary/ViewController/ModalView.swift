//
//  ModalView.swift
//  iTinerary
//
//  Created by Ze Lei on 5/11/22.
//

import Foundation
import SwiftUI

struct ModalView: View {
    
    @Binding var showModal: Bool
    @State var title: String = ""
    @State var date: Date
    let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
    
    private func saveReminder(){
//        let newItem = ReminderItem (context: context)
//        newItem.title = name
//        newItem.date = Date()
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
    private func getDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .padding()
                .foregroundColor(Color.primary)
            
            Text(getDate(date: self.date))
                .padding()
                .foregroundColor(Color.primary)
            
            Button("Save"){
                saveReminder()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            Button("Dismiss") {
                self.showModal.toggle()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

