/**
 * Created by admin-1019 on 13/06/2018.
 */

public class Token {
    private static final String TOKEN_STRING = 'Token({0}, {1})';

    public enum Type {
        LEFT_BRACKET,
        RIGHT_BRACKET,
        KEYWORD,
        INDEX,
        EOF
    }

    public final Type type;
    public final Object value;

    public Token(Type type, Object value) {
        this.type = type;
        this.value = value;
    }

    public override String toString() {
        return String.format(TOKEN_STRING, new List<String>{type.name(), String.valueOf(value)});
    }
}