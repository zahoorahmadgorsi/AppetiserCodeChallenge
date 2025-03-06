## Architecture Choices: MVC & MVVM  

In this project, I have used both **MVC** and **MVVM** architectural patterns based on the complexity of each view controller:  

### **MovieDetailViewController (MVC)**
The `MovieDetailViewController` follows the **Model-View-Controller (MVC)** pattern because:
- It is relatively simple and primarily responsible for displaying static movie details.
- The logic is straightforward, with minimal data processing or transformations.
- Keeping it in MVC avoids unnecessary complexity, making the codebase easier to manage for such a small component.

### **MovieListViewController (MVVM)**
The `MovieListViewController` follows the **Model-View-ViewModel (MVVM)** pattern because:
- It involves fetching movie data from the iTunes Search API, requiring network calls and data parsing.
- The view needs to handle **search functionality, filtering, and updating UI dynamically**, which benefits from separating business logic into a ViewModel.
- Using **MVVM with Combine/RxSwift** allows for better reactivity, making the UI more responsive and reducing the load on the view controller.
- It improves testability, as the ViewModel can be tested independently of the UI.

By choosing the appropriate architecture for each component, the project maintains **a balance between simplicity and scalability**, ensuring that each view controller is structured efficiently based on its complexity.  

