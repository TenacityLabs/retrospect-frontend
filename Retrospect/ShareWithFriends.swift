import SwiftUI
import Contacts
import MessageUI

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phoneNumber: String
}

struct ShareWithFriends: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var searchContent = ""
    @State private var contacts: [Contact] = []
    @State private var showingMessageCompose = false
    @State private var selectedPhoneNumber: String?
    
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
                                selectedPhoneNumber = contact.phoneNumber
                                showingMessageCompose = true
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .padding(.horizontal)
                    }
                    Button(action: {
                        globalState.route = "/dashboard"
                    }) {
                        Text("Next for now")
                            .font(.custom("Syne-Regular", size: 24))
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 75)
                    .background(Color.white)
                    .cornerRadius(50)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 15)
                }
            }
            .background(Color.clear)
        }
        .onAppear(perform: loadContacts)
        .sheet(isPresented: $showingMessageCompose) {
            if let phoneNumber = selectedPhoneNumber {
                MessageComposeView(recipients: [phoneNumber], body: "Join me on Retrospect!")
            }
        }
    }
    
    private func loadContacts() {
        DispatchQueue.global(qos: .userInitiated).async {
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (granted, error) in
                if granted {
                    self.fetchContacts(store: store)
                } else {
                    print("Access denied")
                }
            }
        }
    }
    
    private func fetchContacts(store: CNContactStore) {
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        var fetchedContacts: [Contact] = []
        
        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                let name = "\(contact.givenName) \(contact.familyName)"
                let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
                
                for phoneNumber in phoneNumbers {
                    fetchedContacts.append(Contact(name: name, phoneNumber: phoneNumber))
                }
            }
            DispatchQueue.main.async {
                self.contacts = fetchedContacts
            }
        } catch {
            print("Failed to fetch contacts, error: \(error)")
        }
    }
}

struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var body: String

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.recipients = recipients
        controller.body = body
        controller.messageComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
}

struct ShareWithFriends_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ShareWithFriends()
        }
    }
}
