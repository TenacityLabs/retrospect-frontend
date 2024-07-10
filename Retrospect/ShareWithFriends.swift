//
//  ShareWithFriends.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-23.
//

import SwiftUI

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phoneNumber: String
}

struct ShareWithFriends: View {
    @State private var searchContent = ""
    
    let contacts: [Contact] = [
        Contact(name: "lowercase larry", phoneNumber: "000-000-0000"),
        Contact(name: "PEACH_COBBLER123", phoneNumber: "456-545-6544"),
        Contact(name: "Sonia Joseph", phoneNumber: "123-456-7890"),
        Contact(name: "Aubrey Drake Graham", phoneNumber: "222-222-2222"),
        Contact(name: "Silly Snail", phoneNumber: "987-654-3210"),
        Contact(name: "Kanye East", phoneNumber: "345-123-0000"),
        Contact(name: "Queen Elizabeth", phoneNumber: "416-416-4164"),
        Contact(name: "BLACKMAMBA447", phoneNumber: "447-123-2313"),
        Contact(name: "BLACKMAMBA447", phoneNumber: "447-123-2313"),
        Contact(name: "BLACKMAMBA447", phoneNumber: "447-123-2313"),
        Contact(name: "BLACKMAMBA447", phoneNumber: "447-123-2313"),
        Contact(name: "BLACKMAMBA447", phoneNumber: "447-123-2313"),
    ]
    
    var filteredContacts: [Contact] {
        if searchContent.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.lowercased().contains(searchContent.lowercased()) || $0.phoneNumber.lowercased().contains(searchContent.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            Image("Logo White")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .padding(.top, 75)
            Spacer().frame(height: 20)
            Text("Better Together")
                .font(.system(size: 28))
                .foregroundColor(.white)
            Text("Share with two friends to begin using Retrospect.")
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            HStack {
                TextField("", text: $searchContent)
                    .placeholder(when: searchContent.isEmpty) {
                        Text("Invite a Friend")
                            .foregroundColor(.white)
                            .font(.custom("Syne-Regular", size: 18))
                    }
                    .font(.custom("Syne-Regular", size: 18))
                Image(systemName: "plus")
            }
            .padding(.vertical)
                .overlay(Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.white), alignment: .bottom)
                
                .foregroundColor(.white)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack {
                    ForEach(filteredContacts) { contact in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button(action: {
                                // Action to invite the contact
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color.clear)
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        ShareWithFriends()
    }
}
