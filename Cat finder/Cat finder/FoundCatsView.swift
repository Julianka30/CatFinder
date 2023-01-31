//
//  FoundCats.swift
//  Cat finder
//
//  Created by Julia on 11/8/22.
//

import SwiftUI

struct Cat: Identifiable {
    let id = UUID()
    
    var image: URL?
    var breed = ""
    var age = ""
    var shedding = ""
    var weight = ""
    var childrenFriendly = ""
}

struct FoundCatsView: View {
    let cats: [Cat] 
    @State var isListView = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 40)
            headerView
            Spacer().frame(height: 30)
            viewStyleButtons
            Spacer().frame(height: 20)
            foundCountView
            if isListView {
                SimpleCatListView(cats: cats)
            } else {
                CatList(cats: cats)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 245.0 / 255, green: 222.0/255, blue: 179.0 / 255))
    }
    
    private var headerView: some View {
        HStack {
            Text("Cat Finder")
                .bold()
                .font(.system(size: 50))
                .multilineTextAlignment(.center)
                .foregroundColor(.orange)
            Image(systemName: "pawprint.fill")
                .font(.largeTitle)
        }
    }
    
    private var viewStyleButtons: some View {
        HStack(spacing: 40) {
            Button(action: {
                isListView = true
            }) {
                Image(systemName: "list.bullet")
                    .padding()
                    .font(.system(size: 35))
                    .foregroundColor(.black)
                    .bold()
            }
            Spacer().frame(width: 40)
            Button(action: {
                isListView = false
            }) {
                Image(systemName: "photo")
                    .padding()
                    .font(.system(size: 35))
                    .foregroundColor(.black)
                    .bold()
            }
        }
    }
    
    private var foundCountView: some View {
        Text("Found cats: \(cats.count)")
            .bold()
            .font(.system(size: 30))
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
    }
}

private struct CatList: View {
    let cats: [Cat]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(cats) { cat in
                    CatListItem(cat: cat)
                        .padding()
                    Divider()
                }
            }
        }
    }
}

private struct SimpleCatListView: View {
    let cats: [Cat]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(cats) { cat in
                    VStack(alignment:.leading) {
                        Text(cat.breed)
                            .padding(.bottom)
                            .bold()
                            .font(.system(size: 25))
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("Age: \(cat.age)")
                            Text("Shedding: \(cat.shedding)")
                            Text("Weight: \(cat.weight)")
                            Text("Children-Friendly: \(cat.childrenFriendly)")
                        }   
                            
                            .foregroundColor(.black)
                            .bold()
                    }.padding()
                    Divider()
                }
            }
        }
    }
}

private struct MyAsyncImage: View {
       let url: URL?
       @State private var image: UIImage?
       
       var body: some View {
           if let image {
               Image(uiImage: image)
                   .resizable()
                   .scaledToFill()
           } else {
               Image(systemName: "photo")
                   .onAppear {
                       DispatchQueue.global().async {
//                           sleep(.random(in: 2...10))
                           guard let url else { return }
                           guard let data = try? Data(contentsOf: url) else { return }
                           guard let image = UIImage(data: data) else { return }
                           self.image = image
                       }
                   }
           }
       }
   }

private struct CatListItem: View {
    let cat: Cat
 
    
    var body: some View {
        VStack(alignment:.leading) {
                Text(cat.breed)
                .bold()
                .font(.system(size: 25))
                .foregroundColor(.orange)
             
            MyAsyncImage(url: cat.image)
            
            
//                AsyncImage(url: cat.image) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                    case .success(let image):
//                        image
//                            .resizable()
//                    case .failure:
//                        Image(systemName: "wifi.slash")
//                    @unknown default:
//                        EmptyView()
//                    }
//                } .scaledToFill()

                                   
                    
            VStack(alignment: .leading) {
                Text("Age: \(cat.age)")
                Text("Shedding: \(cat.shedding)")
                Text("Weight: \(cat.weight)")
                Text("Children-Friendly: \(cat.childrenFriendly)")
            }
            .font(.system(size: 20))
            .foregroundColor(.black)
            .bold()
                
        }
    }
}



//func getImage(url: URL?, completion: @escaping (Image) -> Void) {
//    guard let url else { return }
//    URLSession.shared.dataTask(with: url) { data, _, error in
//        if let data {
//            if let image = UIImage(data: data) {
//                completion(Image(uiImage: image))
//            } else {
//                completion(Image(systemName: "photo"))
//            }
//        }
//    }.resume()
    
//}

struct FoundCatsView_Previews: PreviewProvider {
    static var previews: some View {
        FoundCatsView(cats: [
            Cat(image: URL(string: "https://api-ninjas.com/images/cats/abyssinian.jpg")!, breed: "Breed1", age: "10", shedding: "Mid", weight: "5kg", childrenFriendly: "Yes"),
            Cat(image: URL(string: "https://api-ninjas.com/images/cats/abyssinian.jpg")!, breed: "Breed1", age: "10", shedding: "Mid", weight: "5kg", childrenFriendly: "Yes"),
            Cat(image: nil, breed: "Breed4", age: "10", shedding: "Mid", weight: "5kg", childrenFriendly: "Yes"),
        ])
    }
}
