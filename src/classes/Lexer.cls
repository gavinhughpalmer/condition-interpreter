/**
 * Created by admin-1019 on 13/06/2018.
 */
public class Lexer {

    public class InvalidTokenException extends Exception {}
    @testVisible private static final String LEFT_BRACKET = '(';
    @testVisible private static final String RIGHT_BRACKET = ')';

    private final String text;
    private Integer position = 0;
    private String currentCharacter;

    public Lexer(String text) {
        this.text = text;
        currentCharacter = getCurrentCharacter();
    }

    private void advance() {
        position++;
        if (position >= text.length()) {
            currentCharacter = null;
        } else {
            currentCharacter = getCurrentCharacter();
        }
    }

    private String getCurrentCharacter() {
        return text.substring(position, position + 1);
    }

    private void skipWhitespace() {
        while (currentCharacter != null && currentCharacter.isWhitespace()) {
            advance();
        }
    }

    private Integer getIndex() {
        String fullIndex = '';
        while (currentCharacter != null && currentCharacter.isNumeric()) {
            fullIndex += currentCharacter;
            advance();
        }
        return Integer.valueOf(fullIndex);
    }

    private String getKeyword() {
        String keyword = '';
        while (currentCharacter != null && currentCharacter.isAlpha()) {
            keyword += currentCharacter;
            advance();
        }
        return keyword;
    }

    public Token getNextToken() {
        while (currentCharacter != null) {
            if (currentCharacter.isWhitespace()) {
                skipWhitespace();
                continue;
            }
            if (currentCharacter.isNumeric()) {
                return new Token(Token.Type.INDEX, getIndex());
            }
            if (currentCharacter.isAlpha()) {
                return new Token(Token.Type.KEYWORD, getKeyword());
            }
            if (currentCharacter == LEFT_BRACKET) {
                advance();
                return new Token(Token.Type.LEFT_BRACKET, LEFT_BRACKET);
            }
            if (currentCharacter == RIGHT_BRACKET) {
                advance();
                return new Token(Token.Type.RIGHT_BRACKET, RIGHT_BRACKET);
            }
            throw new InvalidTokenException('Invalid syntax, unexpected ' + currentCharacter);
        }
        return new Token(Token.Type.EOF, null);
    }
}