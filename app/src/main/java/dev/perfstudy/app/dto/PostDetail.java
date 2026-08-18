package dev.perfstudy.app.dto;

import java.time.LocalDateTime;
import java.util.List;

public record PostDetail(
        Long id,
        String title,
        String content,
        String authorName,
        int viewCount,
        LocalDateTime createdAt,
        List<CommentView> comments
) {
}
