Swift Concurrency: Async/Await, Combine, MainActor, Task, @escaping...
============

 ```````````````````````ruby
Links for Random Images: 
------------------------

https://awik.io/generate-random-images-unsplash-without-using-api/ 

https://unsplash.com/developers
````````````````````````````````
 
```````````````````````ruby
  //MARK: @escaping

    func dowloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
 
  //MARK: Combine

    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }

  //MARK: async/await

    func downloadWithAsync() async throws -> UIImage? {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
         } catch {
            throw error
        }
    }

