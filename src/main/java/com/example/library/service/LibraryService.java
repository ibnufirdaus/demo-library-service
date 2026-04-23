package com.example.library.service;

import com.example.library.domain.model.Book;
import com.example.library.store.LibraryStore;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.util.Collection;
import java.util.Optional;
import java.util.UUID;

/**
 * Core library operations.
 * All catalog management lives here — the API layer delegates entirely to this service.
 */
@ApplicationScoped
public class LibraryService {

    @Inject
    LibraryStore store;

    public Book addBook(String title, String author, String isbn) {
        var book = new Book(UUID.randomUUID().toString(), title, author, isbn, true);
        store.saveBook(book);
        return book;
    }

    public Optional<Book> findById(String id) {
        return store.findBook(id);
    }

    public Collection<Book> listAll() {
        return store.allBooks();
    }
}
