package com.notehub.dao;

import com.notehub.model.Note;
import com.notehub.model.Category;
import com.notehub.model.Tag;
import com.notehub.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class NoteDAO {
    private CategoryDAO categoryDAO = new CategoryDAO();
    private TagDAO tagDAO = new TagDAO();
    
    public List<Note> findByUserId(Long userId, String query, Long categoryId, String tag, boolean archived) {
        List<Note> notes = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT n.* FROM notes n " +
            "LEFT JOIN note_tag nt ON n.id = nt.note_id " +
            "LEFT JOIN tags t ON nt.tag_id = t.id " +
            "WHERE n.user_id = ? AND n.is_archived = ?"
        );
        
        List<Object> params = new ArrayList<>();
        params.add(userId);
        params.add(archived);
        
        if (query != null && !query.isEmpty()) {
            sql.append(" AND (n.title LIKE ? OR n.content LIKE ?)");
            String searchTerm = "%" + query + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (categoryId != null) {
            sql.append(" AND n.category_id = ?");
            params.add(categoryId);
        }
        
        if (tag != null && !tag.isEmpty()) {
            sql.append(" AND t.name = ?");
            params.add(tag);
        }
        
        sql.append(" ORDER BY n.is_pinned DESC, n.updated_at DESC");
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Note note = mapResultSetToNote(rs);
                note.setCategory(categoryDAO.findById(note.getCategoryId()));
                note.setTags(tagDAO.findByNoteId(note.getId()));
                notes.add(note);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return notes;
    }
    
    public Note create(Long userId, Long categoryId, String title, String content) {
        String sql = "INSERT INTO notes (user_id, category_id, title, content) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, userId);
            if (categoryId != null) {
                stmt.setLong(2, categoryId);
            } else {
                stmt.setNull(2, Types.BIGINT);
            }
            stmt.setString(3, title);
            stmt.setString(4, content);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return findById(rs.getLong(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
    
    public Note findById(Long id) {
        String sql = "SELECT * FROM notes WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Note note = mapResultSetToNote(rs);
                note.setCategory(categoryDAO.findById(note.getCategoryId()));
                note.setTags(tagDAO.findByNoteId(note.getId()));
                return note;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
    
    public Note findByShareToken(String token) {
        String sql = "SELECT * FROM notes WHERE share_token = ? AND is_archived = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Note note = mapResultSetToNote(rs);
                note.setCategory(categoryDAO.findById(note.getCategoryId()));
                return note;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
    
    public void update(Long id, Long categoryId, String title, String content) {
        String sql = "UPDATE notes SET category_id = ?, title = ?, content = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (categoryId != null) {
                stmt.setLong(1, categoryId);
            } else {
                stmt.setNull(1, Types.BIGINT);
            }
            stmt.setString(2, title);
            stmt.setString(3, content);
            stmt.setLong(4, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public void delete(Long id) {
        String sql = "DELETE FROM notes WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public void togglePin(Long id) {
        String sql = "UPDATE notes SET is_pinned = NOT is_pinned WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public void archive(Long id) {
        String sql = "UPDATE notes SET is_archived = TRUE WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public void restore(Long id) {
        String sql = "UPDATE notes SET is_archived = FALSE WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public String generateShareToken(Long id) {
        String token = UUID.randomUUID().toString().replace("-", "").substring(0, 20);
        String sql = "UPDATE notes SET share_token = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setLong(2, id);
            stmt.executeUpdate();
            return token;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public void removeShareToken(Long id) {
        String sql = "UPDATE notes SET share_token = NULL WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public void syncTags(Long noteId, Long userId, String tagsCsv) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            String deleteSql = "DELETE FROM note_tag WHERE note_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
                stmt.setLong(1, noteId);
                stmt.executeUpdate();
            }
            
            if (tagsCsv != null && !tagsCsv.trim().isEmpty()) {
                String[] tagNames = tagsCsv.split(",");
                String insertSql = "INSERT INTO note_tag (note_id, tag_id) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    for (String tagName : tagNames) {
                        tagName = tagName.trim();
                        if (!tagName.isEmpty()) {
                            Tag tag = tagDAO.findOrCreate(userId, tagName);
                            stmt.setLong(1, noteId);
                            stmt.setLong(2, tag.getId());
                            stmt.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    private Note mapResultSetToNote(ResultSet rs) throws SQLException {
        Note note = new Note();
        note.setId(rs.getLong("id"));
        note.setUserId(rs.getLong("user_id"));
        Long catId = rs.getLong("category_id");
        note.setCategoryId(rs.wasNull() ? null : catId);
        note.setTitle(rs.getString("title"));
        note.setContent(rs.getString("content"));
        note.setPinned(rs.getBoolean("is_pinned"));
        note.setArchived(rs.getBoolean("is_archived"));
        note.setShareToken(rs.getString("share_token"));
        return note;
    }
}