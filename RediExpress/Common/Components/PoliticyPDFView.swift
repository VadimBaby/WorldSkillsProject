//
//  PoliticyPDFView.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 08.02.2024.
//

import SwiftUI
import PDFKit

struct PoliticyPDFView: UIViewRepresentable {
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        
        if let url = Bundle.main.url(forResource: "document", withExtension: "pdf") {
            if let document = PDFDocument(url: url) {
                pdfView.document = document
            }
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        
    }
}
