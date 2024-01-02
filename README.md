Swift Concurrency: Async/Await, Combine, MainActor, Task, Thread, @escaping...
============

Links for Random Images: 
------------------------

```````````````````````ruby
https://source.unsplash.com/random/300×400

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

Important ✌🏻 Async/Await.
========================
Swift 5.0
----------

```````````````ruby
 func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.daraArray.append("Title1 : \(Thread.current)")
        }
    }

Swift 5.5
----------

func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1 : \(Task.currentPriority)")
        }
    }
```````````````
