//
//  ContactListCell.swift
//  MockProject
//
//  Created by Jared Davidson on 11/6/21.
//

import Foundation
import SwiftUI

struct ContactListCell: View {
	var user: User
	var body: some View {
		HStack(spacing: 20) {
			Image(user.image)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 70, height: 70, alignment: .center)
				.clipShape(Circle())
			Text(user.name)
				.bold()
		}
		.padding()
	}
}
