//
//  ContactListView.swift
//  MockProject
//
//  Created by Jared Davidson on 11/6/21.
//

import Foundation
import SwiftUI

struct ContactListView: View {
	@State var contacts = [User(image: "gurl", name: "Something"), User(image: "gurl", name: "Something"), User(image: "gurl", name: "Something")]
	var body: some View {
		NavigationView {
			List(self.$contacts, rowContent: {
				contact in
				NavigationLink(destination: FacetimeView(viewModel: .init()), label: {
					ContactListCell(user: contact.wrappedValue)
				})
			})
				.navigationTitle("Facetime Clone")
		}
	}
}
