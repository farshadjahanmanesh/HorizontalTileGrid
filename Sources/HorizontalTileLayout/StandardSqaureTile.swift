//
//  StandardSquareTile.swift
//  
//
//  Created by Farshad Macbook M1 Pro on 12/13/22.
//

import SwiftUI
public struct StandardSquareTile<Content: View> : View {
	@ViewBuilder var content: () -> Content
	public init(@ViewBuilder builder: @escaping () -> Content) {
		self.content = builder
	}

	public var body: some View {
		content()
			.layoutValue(key: HorizontalTileDisplayKey.self, value: .fullSquare)
	}
}
