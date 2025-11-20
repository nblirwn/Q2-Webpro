package com.notehub.dao;

import com.notehub.model.Tag;
import com.notehub.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TagDAO {
    public Tag findOrCreate(Long userId, String name) {
        Tag tag = findByUserIdAndName(userId, name);
        if (tag != null) return tag;
        
        String sql = "INSERT INTO tags (user_id, name) VALUES (?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, userId);
            stmt.setString(2, name);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return new Tag(rs.getLong(1), userId, name);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
    
    public Tag findByUserIdAndName(Long userId, String name) {
        String sql = "SELECT * FROM tags WHERE user_id = ? AND name = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setString(2, name);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Tag tag = new Tag();
                tag.setId(rs.getLong("id"));
                tag.setUserId(rs.getLong("user_id"));
                tag.setName(rs.getString("name"));
                return tag;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
    
    public List<Tag> findByNoteId(Long noteId) {
        List<Tag> tags = new ArrayList<>();
        String sql = "SELECT t.* FROM tags t INNER JOIN note_tag nt ON t.id = nt.tag_id WHERE nt.note_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, noteId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Tag tag = new Tag();
                tag.setId(rs.getLong("id"));
                tag.setUserId(rs.getLong("user_id"));
                tag.setName(rs.getString("name"));
                tags.add(tag);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return tags;
    }
}