package com.example.library.api;

import com.example.library.domain.model.Book;
import com.example.library.service.LibraryService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.Map;

/**
 * REST API for the library catalog.
 *
 * Current endpoints (initial implementation):
 *   GET  /api/books          — list all books
 *   POST /api/books          — add a book to the catalog
 *   GET  /api/books/{id}     — get a book by ID
 *
 * Planned (see TASK-001):
 *   POST /api/books/{id}/borrow   — borrow a book
 *   POST /api/loans/{id}/return   — return a book
 *
 * Planned (see TASK-002):
 *   GET  /api/books/search        — search by title or author
 */
@Path("/api/books")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class LibraryResource {

    @Inject
    LibraryService libraryService;

    @GET
    public Response listAll() {
        return Response.ok(libraryService.listAll()).build();
    }

    @POST
    public Response addBook(Map<String, String> body) {
        var book = libraryService.addBook(
                body.get("title"),
                body.get("author"),
                body.get("isbn")
        );
        return Response.status(Response.Status.CREATED).entity(book).build();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") String id) {
        return libraryService.findById(id)
                .map(book -> Response.ok(book).build())
                .orElse(Response.status(Response.Status.NOT_FOUND).build());
    }
}
