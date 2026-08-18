package dev.perfstudy.app.controller;

import dev.perfstudy.app.dto.PostDetail;
import dev.perfstudy.app.dto.PostSummary;
import dev.perfstudy.app.service.PostService;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    private final PostService postService;

    public PostController(PostService postService) {
        this.postService = postService;
    }

    @GetMapping
    public Page<PostSummary> list(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return postService.getPosts(page, size);
    }

    @GetMapping("/search")
    public List<PostSummary> search(@RequestParam String keyword) {
        return postService.search(keyword);
    }

    @GetMapping("/{id}")
    public PostDetail detail(@PathVariable Long id) {
        return postService.getPost(id);
    }
}
