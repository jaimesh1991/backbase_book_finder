# backbase_book_finder

# Book Search Flutter Demo App

This is a Flutter demo app that allows users to search for books via a REST API, save them locally using SQLite, and view the saved records. The project demonstrates clean architecture, BLoC state management, pagination, error handling, basic animation, and unit testing.

---

## 📐 Architecture

This app follows **Clean Architecture**, divided into three layers:

- **Data Layer**: Responsible for API integration, local DB access, and data source implementation.
  - `BookLocalDataSource` – handles local storage using SQLite.
  - `BookRepositoryImpl` – bridges remote and local sources.

- **Domain Layer**: Contains business logic and use cases.
  - `BookRepository` – abstract repository.

- **Presentation Layer**: Manages UI and state.
  - `BookBloc` – manages state using BLoC.
  - `SearchScreen`, `SavedBooksPopup` – Flutter widgets with animations.

---

## 📦 Libraries & Tools Used

| Package              | Purpose                                |
|----------------------|----------------------------------------|
| `flutter_bloc`       | State management using BLoC pattern    |
| `http`               | REST API integration                   |
| `sqflite` + `path`   | SQLite database                        |
| `equatable`          | Simplify equality checks in BLoC       |
| `mockito` + `test`   | Unit testing                           |

---

## ⚙️ Features Implemented

- Book search using OpenLibrary API with pagination.
- Save books to local SQLite database.
- View saved books in a popup dialog.
- Clean separation of concerns using clean architecture.
- State management with BLoC.
- Basic fade-in animation for book list.
- Unit test case for repository logic.

---

## 🧪 Testing

To run unit tests:

```bash
flutter test
