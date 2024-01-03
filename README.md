Swift Concurrency: Async/Await, Combine, MainActor, Task, Thread, AsyncLet, @escaping...
============

Links for Random Images: 
------------------------

```````````````````````ruby
https://source.unsplash.com/random/300×400

```````````````````````
 
```````````````````````ruby
  //MARK: @escaping

    func dowloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
 
  //MARK: combine

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
```````````````````````

Tasks are a building block for writing Swift Concurrency code. Every time we are in an asynchronous context, we are actually performing work within a Task.
-----------------------------------------------------------------------------------------------------------------------------------------------------------

https://github.com/Elaidzha1940/AsyncAwait/assets/64445918/8894b2ac-f56c-4303-8b41-d833bfba608c

Async Let: 
----------

```````````ruby

  Task {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        async let fetchImage5 = fetchImage()
                        async let fetchImage6 = fetchImage()
                        
                        let (image1, image2, image3, image4, image5, image6) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5, try fetchImage6)
                        self.images.append(contentsOf: [image1, image2, image3, image4, image5, image6])
                    } catch {
                        
                    }
                }
```````````
