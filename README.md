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

Important ✌🏻 Async/Await: 
-------------------------

```````````````````````ruby

Swift 5.0

 func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.daraArray.append("Title1 : \(Thread.current)")
        }
    }

Swift 5.5

func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1 : \(Task.currentPriority)")
        }
    }
```````````````````````
