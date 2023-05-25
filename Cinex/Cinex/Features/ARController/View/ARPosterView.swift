//
//  ARPosterView.swift
//  AR_Poster
//
//  Created by Nicholas Yvees on 25/05/23.
//

import SwiftUI

struct ARPosterViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ARController")
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ARPosterView: View {
    var body: some View {
        NavigationView{
            ARPosterViewController()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ARPosterView_Previews: PreviewProvider {
    static var previews: some View {
        ARPosterView()
    }
}
