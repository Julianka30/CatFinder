//
//  CriteriaScreen.swift
//  Cat finder
//
//  Created by Julia on 11/8/22.
//

import SwiftUI

struct Criteria {
    var breed = ""
    var age = ""
    var shedding = ""
    var weight = ""
    var childrenFriendly = ""
}

struct CatApi: Codable {
    var name: String
    var max_life_expectancy: Int
    var shedding: Int
    var max_weight: Int
    var children_friendly: Int
    var image_link: String
}

struct ScrollID: Hashable {}

struct CriteriaScreen: View {
    @State var criteria: Criteria = Criteria()
    @State var requestedCats: [Cat]?
    @State var isFoundCatsActive = false
    @State private var showingAlert = false
    @State var alertText = ""
    @State var isProgressHidden = true
    @FocusState var isAnyTextfieldFocused: Bool
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack {
                    Spacer().frame(height: 40)
                        .id(ScrollID())
                    titleView
                    Spacer().frame(height: 60)
                    requirementView
                    Spacer().frame(height: 25)
                    criteriaView
                    Spacer()
                    buttonsView
                    Spacer()
                    navigationView
                }
                .onChange(of: isAnyTextfieldFocused) { newValue in
                    if !newValue {
                        proxy.scrollTo(ScrollID())
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertText)
        }
        .background(Color(red: 245.0 / 255, green: 222.0/255, blue: 179.0 / 255))
    }
    
    private var titleView: some View  {
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
    
    private var requirementView: some View {
        HStack {
            Text("Fill at least 1 parametr")
                .font(.system(size: 25, design:.serif))
                .multilineTextAlignment(.center)
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                .font(.largeTitle)
        }
    }
    
    private var criteriaView: some View {
        VStack(spacing: 35) {
            Group {
                TextField("Enter the name of cat breed", text: $criteria.breed)
                TextField("Enter max life expectancy in years", text: $criteria.age)
                TextField("Shedding (from 0 - 5)", text: $criteria.shedding)
                TextField("Enter max weight", text: $criteria.weight)
                TextField("Children friendly (from 0 - 5)", text: $criteria.childrenFriendly)
            }
            .focused($isAnyTextfieldFocused)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    private var buttonsView: some View {
        Group {
            if !isProgressHidden {
                Image(systemName: "slowmo")
            } else {
                Button(action: {
                    isAnyTextfieldFocused = false
//                    UIApplication.shared.resignFirstResponder()
                    isProgressHidden = false
                    requestCats(with: criteria) { result in
                        isProgressHidden = true

                        switch result {
                        case .success(let cats):
                            requestedCats = cats
                            isFoundCatsActive = true
                        case .failure(let error):
                            alertText = error.localizedDescription
                            showingAlert = true
                        }
                    }
                }) {
                    Text("Find")
                    Image(systemName: "sparkle.magnifyingglass")
                }
                .padding()
                .background(criteria.isValid ? .orange : .gray)
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 25))
                .disabled(!criteria.isValid)
            }
        }
    }
    
    private var navigationView: some View {
        NavigationLink(
            isActive: $isFoundCatsActive,
            destination: { FoundCatsView(cats: requestedCats ?? []) },
            label: { EmptyView() }
        )
    }
}
              
func requestCats(
    with criteria: Criteria,
    completion: @escaping (Result<[Cat], Error>) -> Void
) {
    var components = URLComponents(string: "https://api.api-ninjas.com/v1/cats")!
    var queryItems: [URLQueryItem] = []
    if !criteria.breed.isEmpty {
        queryItems.append(URLQueryItem(name: "name", value: criteria.breed))
    }
    if !criteria.age.isEmpty {
        queryItems.append(URLQueryItem(name: "max_life_expectancy", value: criteria.age))
    }
    if !criteria.shedding.isEmpty {
        queryItems.append(URLQueryItem(name: "shedding", value: criteria.shedding))
    }
    if !criteria.weight.isEmpty {
        queryItems.append(URLQueryItem(name: "max_weight", value: criteria.weight))
    }
    if !criteria.childrenFriendly.isEmpty {
        queryItems.append(URLQueryItem(name: "children_friendly", value: criteria.childrenFriendly))
    }
    components.queryItems = queryItems
    
    let url = components.url!
    var request = URLRequest(url: url)
    request.addValue("bj7I3bzD+kOke2gpKyqhbQ==OHMNpOCEFNgtadPD", forHTTPHeaderField: "X-Api-Key")
    URLSession.shared.dataTask(with: request) { data, _, error in
        if let error {
            completion(.failure(error))
        } else {
            let cats:[CatApi]
            do {
                cats = try JSONDecoder().decode([CatApi].self, from: data!)
            } catch {
                completion(.failure(error))
                return
            }
            print("Found \(cats.count) cats")
           
            let requestedCats = cats.map { cat in
                Cat(
                    image: URL(string:cat.image_link), breed: cat.name,
                    age: String(cat.max_life_expectancy),
                    shedding: String(cat.shedding),
                    weight: String(cat.max_weight),
                    childrenFriendly: String(cat.children_friendly)
                )
            }
            completion(.success(requestedCats))
//            isFoundCatsActive = true
        }
    }.resume()
}


extension Criteria {
    var isValid: Bool {
        !breed.isEmpty ||
        !age.isEmpty ||
        !shedding.isEmpty ||
        !weight.isEmpty ||
        !childrenFriendly.isEmpty 
    }
}

struct CriteriaScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
           CriteriaScreen()
        }
    }
}
