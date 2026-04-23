package com.example.library.domain.model;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Domain record deserialization test.
 * Every new domain Record must have a test like this.
 */
class BookDeserializationTest {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void shouldDeserialize_withAllFields() throws Exception {
        // Given
        var json = """
                {
                  "id": "abc-123",
                  "title": "The Pragmatic Programmer",
                  "author": "David Thomas",
                  "isbn": "978-0135957059",
                  "available": true
                }
                """;

        // When
        var book = objectMapper.readValue(json, Book.class);

        // Then
        assertThat(book.id()).isEqualTo("abc-123");
        assertThat(book.title()).isEqualTo("The Pragmatic Programmer");
        assertThat(book.available()).isTrue();
    }

    @Test
    void shouldDeserialize_ignoringUnknownFields() throws Exception {
        // Given — future fields the service doesn't know about yet
        var json = """
                {
                  "id": "abc-456",
                  "title": "Refactoring",
                  "author": "Martin Fowler",
                  "isbn": "978-0134757599",
                  "available": false,
                  "genre": "ignored-future-field"
                }
                """;

        // When / Then — must not throw
        var book = objectMapper.readValue(json, Book.class);
        assertThat(book.available()).isFalse();
    }
}
