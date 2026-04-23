package com.example.library.domain.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * A book in the library catalog.
 * {@code available} reflects whether the book can currently be borrowed.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public record Book(
        String id,
        String title,
        String author,
        String isbn,
        boolean available
) {
    public Book withAvailable(boolean available) {
        return new Book(id, title, author, isbn, available);
    }
}
